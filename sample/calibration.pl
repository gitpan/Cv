#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

# http://opencv.jp/sample/camera_calibration.html

use strict;
use lib qw(blib/lib blib/arch);
use lib qw(../blib/lib ../blib/arch);
use Cv;
use IO::File;
use File::Basename;
use Data::Dumper;

my @images;
my $calib_image;

&Calibrate;
&Undistort($calib_image);
#&UndistortMap($calib_image);
exit 0;

sub Calibrate {
	# (1) キャリブレーション画像の読み込み
	my $imageList = $ARGV[0] || "calibration.txt";
	my $f = new IO::File join('/', dirname($0), $imageList), "r";
	die "can not open file $imageList\n" unless ($f);

	while (<$f>) {
		next if (/^#/);
		chomp;
		my $image;
		unless ($image = Cv->LoadImage($_, CV_LOAD_IMAGE_COLOR)) {
			print STDERR "cannot load image file : $_\n";
		}
		push(@images, $image);
		$calib_image = $image->CloneImage unless $calib_image;
	}
	
	# (2) 3次元空間座標の設定
	my $IMAGE_NUM = @images;		# 画像数
	my $PAT_ROW = 6;				# パターンの行数
	my $PAT_COL = 9;				# パターンの列数
	my $PAT_SIZE   = $PAT_ROW * $PAT_COL;
	my $ALL_POINTS = $IMAGE_NUM * $PAT_SIZE;
	my $CHESS_SIZE = 24.0;			# パターン1マスの1辺サイズ[mm]
	
	my $object_points = Cv->CreateMat($ALL_POINTS, 1, CV_32FC3);
#	my $object_points = Cv->CreateMat($ALL_POINTS, 3, CV_32FC1);
	
	for my $i (0 .. $IMAGE_NUM-1) {
		for my $j (0 .. $PAT_ROW-1) {
			for my $k (0 .. $PAT_COL-1) {
				$object_points->SetD(
					-idx   => [$i*$PAT_SIZE + $j*$PAT_COL + $k],
					-value => [$j*$CHESS_SIZE, $k*$CHESS_SIZE, 0],
					);
#				my $idx = $i*$PAT_SIZE + $j*$PAT_COL + $k;
#				$object_points->SetD([$idx, 0], [$j*$CHESS_SIZE]);
#				$object_points->SetD([$idx, 1], [$k*$CHESS_SIZE]);
#				$object_points->SetD([$idx, 2], [0]);
			}
		}
	}

	# (3) チェスボード（キャリブレーションパターン）のコーナー検出
	my $image_points = Cv->CreateMat($ALL_POINTS, 1, CV_32FC2); # corners
	my $point_counts = Cv->CreateMat($IMAGE_NUM,  1, CV_32SC1); # p_count;
	
	my $pattern_size = [$PAT_COL, $PAT_ROW];
	my @corners = ();
	my $corner_count = 0;
	my $found_num = 0;
	
	for (my $i = 0; $i < $IMAGE_NUM; $i++) {
		my $found = Cv->FindChessboardCorners(
			-image        => $images[$i],
			-pattern_size => $pattern_size,
			-corners      => \@corners,
			-corner_count => \$corner_count,
			-flags => (CV_CALIB_CB_ADAPTIVE_THRESH |
					   CV_CALIB_CB_NORMALIZE_IMAGE),
			);
		
		printf STDERR "%02d...", $i;
		
		if ($found) {
			print STDERR "ok\n";
			$found_num++;
		} else {
			print STDERR "fail\n";
		}
		
		# (4) コーナー位置をサブピクセル精度に修正，描画
		my $gray = $images[$i]->CvtColor(CV_BGR2GRAY);
		$gray->FindCornerSubPix(
			-corners   => \@corners,
			-count     => $corner_count,
			-win       => [3, 3],
			-zero_zone => [-1, -1],
			-criteria  => scalar cvTermCriteria(
				 CV_TERMCRIT_ITER | CV_TERMCRIT_EPS,
				 20,
				 0.03 ),
			);
		Cv->DrawChessboardCorners(
			-image             => $images[$i],
			-pattern_size      => $pattern_size,
			-corners           => \@corners,
			-corner_count      => $corner_count,
			-pattern_was_found => $found,
			);
		$point_counts->SetD([$i], [$corner_count]);
		for (0..$#corners) {
			my $point = [$corners[$_]->{x}, $corners[$_]->{y}];
			$image_points->SetD([$i*$PAT_SIZE + $_], $point);
		}
		$images[$i]->ShowImage("Calibration");
		Cv->WaitKey(100);
	}

	exit -1 if ($found_num != $IMAGE_NUM);

	# (5) 内部パラメータ，歪み係数の推定
	my $intrinsic   = Cv->CreateMat(3, 3, CV_32FC1);
	my $rotation    = Cv->CreateMat(1, 3, CV_32FC1);
	my $translation = Cv->CreateMat(1, 3, CV_32FC1);
	my $distortion  = Cv->CreateMat(1, 4, CV_32FC1);

	Cv->CalibrateCamera2(
		-object_points     => $object_points,
		-image_points      => $image_points,
		-point_counts      => $point_counts,
		-image_size        => [$calib_image->GetSize],
		-intrinsic_matrix  => $intrinsic,
		-distortion_coeffs => $distortion,
		);

	# (6) 外部パラメータの推定
	my $sub_image_points = Cv->CreateMat($PAT_SIZE, 1, CV_32FC2);
	my $sub_object_points = Cv->CreateMat($PAT_SIZE, 1, CV_32FC3);
#	my $sub_object_points = Cv->CreateMat($PAT_SIZE, 3, CV_32FC1);
	my $base = 0;
	$image_points->GetRows(
		-submat    => $sub_image_points,
		-start_row => $base * $PAT_SIZE,
		-end_row   => ($base+1) * $PAT_SIZE,
		);
	$object_points->GetRows(
		-submat    => $sub_object_points,
		-start_row => $base * $PAT_SIZE,
		-end_row   => ($base+1) * $PAT_SIZE,
		);
	Cv->FindExtrinsicCameraParams2(
		-object_points      => $sub_object_points,
		-image_points       => $sub_image_points,
		-intrinsic_matrix   => $intrinsic,
		-distortion_coeffs  => $distortion,
		-rotation_vector    => $rotation,
		-translation_vector => $translation,
		);
	
	# (7) XMLファイルへの書き出し
	my $fs = Cv->OpenFileStorage("camera.xml", CV_STORAGE_WRITE);
	$fs->Write("intrinsic", $intrinsic);
	$fs->Write("rotation", $rotation);
	$fs->Write("translation", $translation);
	$fs->Write("distortion", $distortion);
}

sub Undistort {

	# (1)補正対象となる画像の読み込み
	my $src_img = shift;
	$src_img = $src_img->CvtColor(CV_RGB2GRAY) if ($src_img->channels == 3);

	# (2)パラメータファイルの読み込み
	my $param;
	my $fs = Cv->OpenFileStorage("camera.xml", CV_STORAGE_READ);
	$param = $fs->GetFileNodeByName("intrinsic");
	my $intrinsic = $fs->Read($param);
	$param = $fs->GetFileNodeByName("distortion");
	my $distortion = $fs->Read($param);
	
	# (3)歪み補正
	my $dst_img = $src_img->Undistort2($intrinsic, $distortion);

	# (4)画像を表示，キーが押されたときに終了
	$src_img->ShowImage("Distortion");
	$dst_img->ShowImage("UnDistortion");
	Cv->WaitKey;
}


sub UndistortMap {

	# (1)補正対象となる画像の読み込み
	my $src_img = shift;
	$src_img = $src_img->CvtColor(CV_RGB2GRAY) if ($src_img->channels == 3);
	my $mapx = Cv->CreateImage([640, 480], IPL_DEPTH_32F, 1);
	my $mapy = Cv->CreateImage([640, 480], IPL_DEPTH_32F, 1);

	# (2)パラメータファイルの読み込み
	my $param;
	my $fs = Cv->OpenFileStorage("camera.xml", CV_STORAGE_READ);
	$param = $fs->GetFileNodeByName("intrinsic");
	my $intrinsic = $fs->Read($param);
	$param = $fs->GetFileNodeByName("distortion");
	my $distortion = $fs->Read($param);

	# (3) 歪み補正のためのマップ初期化
	Cv->InitUndistortMap($intrinsic, $distortion, $mapx, $mapy);

	# (4) 歪み補正
	my $dst_img = $src_img->Remap($mapx, $mapy);

	$src_img->ShowImage("Distortion");
	$dst_img->ShowImage("UnDistortion");
	Cv->WaitKey;
}
