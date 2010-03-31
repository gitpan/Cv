# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
#use Test::More tests => 8;
use Test::Output;
use Test::File;

use POSIX; 
use Data::Dumper;

BEGIN {
	use_ok('Cv');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.


{
	# http://opencv.jp/sample/linear_algebra.html#cvinvert

	my $nrow = 3;
	my $ncol = 3;

	# (1) 行列のメモリ確保
	my $src = Cv->CreateMat($nrow, $ncol, CV_32FC1);

	# (2) 行列srcに乱数を代入
	printf "src\n";
	$src->SetD([0, 0], 1);
	for my $i (0 .. $src->rows -1) {
		for my $j (0 .. $src->cols -1) {
			$src->SetD([$i, $j], rand());
			printf "%.4f\t", $src->GetD([$i, $j])->[0];
		}
		print "\n";
	}
	
	# (3) 行列srcの逆行列を求めて，行列dstに代入
	my $dst = $src->Invert(CV_SVD);
	
	# (5) 行列dstの表示
	print "dst\n";
	for my $i (0 .. $dst->rows -1) {
		for my $j (0 .. $dst->cols -1) {
			printf "%.4f\t", $dst->GetD([$i, $j])->[0];
		}
		printf "\n";
	}

	# (6) 行列srcとdstの積を計算して確認
	my $mul = $src->MatMul($dst);
	print "mul\n";
	for my $i (0 .. $mul->rows -1) {
		for my $j (0 .. $mul->cols -1) {
			printf "%.4f\t", $mul->GetD([$i, $j])->[0];
		}
		print "\n";
	}
}
