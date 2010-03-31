# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

# This is sample from the OpenCV book. The copyright notice is below

# *************** License:**************************
#  Oct. 3, 2008
#  Right to use this code in any way you want without warrenty,
#  support or any guarentee of it working.
#
#  BOOK: It would be nice if you cited it:
#  Learning OpenCV: Computer Vision with the OpenCV Library
#    by Gary Bradski and Adrian Kaehler
#    Published by O'Reilly Media, October 3, 2008
# 
#  AVAILABLE AT: 
#    http://www.amazon.com/Learning-OpenCV-Computer-Vision-Library/dp/0596516134
#    Or: http://oreilly.com/catalog/9780596516130/
#    ISBN-10: 0596516134 or: ISBN-13: 978-0596516130
#
#  OTHER OPENCV SITES:
#  * The source code is on sourceforge at:
#    http://sourceforge.net/projects/opencvlibrary/
#  * The OpenCV wiki page (As of Oct 1, 2008 this is down for
#    changing over servers, but should come back):
#    http://opencvlibrary.sourceforge.net/
#  * An active user group is at:
#    http://tech.groups.yahoo.com/group/OpenCV/
#  * The minutes of weekly OpenCV development meetings are at:
#    http://pr.willowgarage.com/wiki/OpenCV
# ************************************************** */

#use Test::More qw(no_plan);
use Test::More tests => 2;
use Test::Output;
BEGIN {
	use_ok('Cv');
}
use File::Basename;
use Data::Dumper;
use IO::File;
use List::Util qw(max min);

eval { &StereoCalib("stereo_calib.txt", 9, 6, 1) };
ok(!$@, "StereoCalib");

exit;

# Given a list of chessboard images, the number of corners (nx, ny)
# on the chessboards, and a flag: useCalibrated for calibrated (0) or
# uncalibrated (1: use cvStereoCalibrate(), 2: compute fundamental
# matrix separately) stereo. Calibrate the cameras and display the
# rectified results along with the computed disparity images.

sub StereoCalib {
	my $imageList = shift;
	my $nx = shift;
	my $ny = shift;
	my $useUncalibrated = shift;

    my $displayCorners = 0;
    my $showUndistorted = 1;
    my $isVerticalStereo = 0;		# OpenCV can handle left-right
									# or up-down camera arrangements
    my $maxScale = 1;
    my $squareSize = 1.0;			# Set this to your actual square size

    my $f = new IO::File join('/', dirname($0), $imageList), "r";
	die "can not open file $imageList\n" unless ($f);

	my $nframes;
	my $n = $nx * $ny;
	my $N = 0;
	my @imageNames = ([ ], [ ]);
    my @points = ([ ], [ ]);
    my @active = ([ ], [ ]);;
    # my $imageSize = [ 0, 0 ];
    my ($w, $h) = (0, 0);

    # ARRAY AND VECTOR STORAGE:
	my $M1 = Cv->CreateMat(3, 3, CV_64F);
    my $M2 = Cv->CreateMat(3, 3, CV_64F);
    my $D1 = Cv->CreateMat(1, 5, CV_64F);
    my $D2 = Cv->CreateMat(1, 5, CV_64F);
    my $R  = Cv->CreateMat(3, 3, CV_64F);
    my $T  = Cv->CreateMat(3, 1, CV_64F);
    my $E  = Cv->CreateMat(3, 3, CV_64F);
    my $F  = Cv->CreateMat(3, 3, CV_64F);

    if ($displayCorners) {
        Cv->NamedWindow("corners", 1);
	}

	# READ IN THE LIST OF CHESSBOARDS:
	my $i = 0;
	while (<$f>) {
		chomp;
        next if (/^\#/);

        my $count = 0;
		my $result = 0;
        my $lr = $i % 2;
		#my $pts = $points[$lr];

		my $filename = join('/', dirname($0), $_);
		my $img = Cv->LoadImage($filename, 0);
        next unless ($img);

        ($w, $h) = $img->GetSize;
        push(@{$imageNames[$lr]}, $filename);

		# FIND CHESSBOARDS AND CORNERS THEREIN:
		my @temp = ();
        for (my $s = 1; $s <= $maxScale; $s++) {
            my $timg = $img;
            if ($s != 1) {
                $timg = $img->new(-size => map { $_ * $s } $img->GetSize);
                $img->Resize(-dst => $timg, -interpolation => CV_INTER_CUBIC);
            }
            $result = $timg->FindChessboardCorners(
				# -image => $timg,
				-pattern_size => [ $nx, $ny ],
				-corners => \@temp,
				-corner_count => \$count,
				-flags => (CV_CALIB_CB_ADAPTIVE_THRESH |
						   CV_CALIB_CB_NORMALIZE_IMAGE),
				);
			for (my $j = 0; $j < $count; $j++ ) {
				$temp[$j]->{x} /= $s;
				$temp[$j]->{y} /= $s;
			}
			last if ($result);
        }
        if ($displayCorners) {
            print STDERR "$_\n";
            my $cimg = Cv->CreateImage([ $w, $h ], 8, 3);
            $cimg = $img->CvtColor(CV_GRAY2RGB);
            Cv->DrawChessboardCorners(
				-image => $cimg,
				-pattern_size => [$nx, $ny],
				-corners => \@temp,
				-count => $count,
				-pattern_was_found => $result,
				);
            $cimg->ShowImage("corners");

			# Allow ESC to quit
            my $c = Cv->WaitKey(100);
			$c &= 0x7f if ($c >= 0);
            exit -1 if ($c == 27 || $c == ord('q') || $c == ord('Q') );
        } else {
            print STDERR '.';
		}

		$N = $n*($i - $lr)/2;
        push(@{$active[$lr]}, $result);

        if ($result) {
			# Calibration will suffer without subpixel interpolation
            $img->FindCornerSubPix(
				# -image => $img,
				-corners => \@temp,
				-count => $count,
				-win => [ 11, 11 ],
				-zero_zone => [ -1, -1 ],
				-criteria => scalar cvTermCriteria(
					 CV_TERMCRIT_ITER + CV_TERMCRIT_EPS,
					 30, 0.01),
				);
			foreach my $j (0 .. $#temp) {
				${$points[$lr]}[$N + $j] =
					[ $temp[$j]->{x}, $temp[$j]->{y} ];
			}
        }

		$i++;
    }
	close $f;
	print STDERR "\n";

	# HARVEST CHESSBOARD 3D OBJECT POINT LIST:
	$nframes = @{$active[0]}; # Number of good chessboads found
    $N = $nframes * $n;

    my $objectPoints = Cv->CreateMat(1, $N, CV_32FC3);
    my $imagePoints1 = Cv->CreateMat(1, $N, CV_32FC2);
    my $imagePoints2 = Cv->CreateMat(1, $N, CV_32FC2);
    my $npoints = Cv->CreateMat(1, $nframes, CV_32S);

	for (my $k = 0; $k < $nframes; $k++) {
		for (my $j = 0; $j < $ny; $j++) {
			for (my $i = 0; $i < $nx; $i++) {
				my $idx = ($k * $ny + $j) * $nx + $i;
				my ($y, $x, $z) = ($j * $squareSize, $i * $squareSize, 0);
				$objectPoints->SetD([ 0, $idx ], [ $y, $x, $z ]);
				$imagePoints1->SetD([ 0, $idx ], ${$points[0]}[$idx]);
				$imagePoints2->SetD([ 0, $idx ], ${$points[1]}[$idx]);
			}
		}
		$npoints->SetD(-idx => [ 0, $k ], -value => [ $n ]);
	}

	# CALIBRATE THE STEREO CAMERAS
    print STDERR "Running stereo calibration ...";
    Cv->StereoCalibrate(
		-object_points => $objectPoints,
		-image_points1 => $imagePoints1,
		-image_points2 => $imagePoints2,
		-point_counts => $npoints,
		-camera_matrix1 => $M1->SetIdentity, -dist_coeffs1 => $D1->Zero,
		-camera_matrix2 => $M2->SetIdentity, -dist_coeffs2 => $D2->Zero,
		-image_size => [ $w, $h ],
		-R => $R, -T => $T, -E => $E, -F => $F,
		-term_crit => scalar cvTermCriteria(
			 -type => CV_TERMCRIT_ITER+CV_TERMCRIT_EPS,
			 -max_iter => 100, -epsilon => 1e-5),
		-flags => (CV_CALIB_FIX_ASPECT_RATIO +
				   CV_CALIB_ZERO_TANGENT_DIST +
				   CV_CALIB_SAME_FOCAL_LENGTH),
		);
    print STDERR " done\n";

	# CALIBRATION QUALITY CHECK
	# because the output fundamental matrix implicitly includes all
	# the output information, we can check the quality of calibration
	# using the epipolar geometry constraint: m2^t*F*m1=0

	# Always work in undistorted space
    Cv->UndistortPoints(
		-src => $imagePoints1, -dst => $imagePoints1,
		-camera_matrix => $M1, -dist_coeffs => $D1,
		-R => \0, -P => $M1,
		);
    Cv->UndistortPoints(
		-src => $imagePoints2, -dst => $imagePoints2,
		-camera_matrix => $M2, -dist_coeffs => $D2,
		-R => \0, -P => $M2,
		);

    my $L1 = Cv->CreateMat(1, $N, CV_32FC3);
    my $L2 = Cv->CreateMat(1, $N, CV_32FC3);
    Cv->ComputeCorrespondEpilines(
		-points => $imagePoints1, -which_image => 1,
		-fundamental_matrix => $F, -correspondent_lines => $L1,
		);
    Cv->ComputeCorrespondEpilines(
		-points => $imagePoints2, -which_image => 2,
		-fundamental_matrix => $F, -correspondent_lines => $L2,
		);

    my $avgErr = 0;
    for (my $i = 0; $i < $N; $i++) {
		my $l0 = $L1->GetD([ 0, $i ]);
		my $p0 = $imagePoints1->GetD([ 0, $i ]);
		my $l1 = $L2->GetD([ 0, $i ]);
		my $p1 = $imagePoints2->GetD([ 0, $i ]);
        my $err =
			abs($p0->[1] * $l1->[1] + $p0->[0] * $l1->[0] + $l1->[2]) +
			abs($p1->[1] * $l0->[1] + $p1->[0] * $l0->[0] + $l0->[2]);
        $avgErr += $err;
    }
    printf STDERR "avg err = %g\n", $avgErr/($nframes*$n);

	# COMPUTE AND DISPLAY RECTIFICATION
    if ($showUndistorted) {

        my $mx1   = Cv->CreateMat(-cols => $w, -rows => $h, -type => CV_32F);
        my $my1   = Cv->CreateMat(-cols => $w, -rows => $h, -type => CV_32F);
        my $mx2   = Cv->CreateMat(-cols => $w, -rows => $h, -type => CV_32F);
        my $my2   = Cv->CreateMat(-cols => $w, -rows => $h, -type => CV_32F);
        my $img1r = Cv->CreateMat(-cols => $w, -rows => $h, -type => CV_8U);
        my $img2r = Cv->CreateMat(-cols => $w, -rows => $h, -type => CV_8U);
        my $disp  = Cv->CreateMat(-cols => $w, -rows => $h, -type => CV_16S);
        my $vdisp = Cv->CreateMat(-cols => $w, -rows => $h, -type => CV_8U);

        my $R1 = Cv->CreateMat(3, 3, CV_64F);
        my $R2 = Cv->CreateMat(3, 3, CV_64F);

		# IF BY CALIBRATED (BOUGUET'S METHOD)
        if ($useUncalibrated == 0) {
            my $P1 = Cv->CreateMat(3, 4, CV_64F);
            my $P2 = Cv->CreateMat(3, 4, CV_64F);

            Cv->StereoRectify(
				-camera_matrix1 => $M1,
				-camera_matrix2 => $M2,
				-dist_coeffs1 => $D1,
				-dist_coeffs2 => $D2,
				-image_size => [ $w, $h ],
				-R => $R, -T => $T,
				-R1 => $R1, -R2 => $R2,
				-P1 => $P1, -P2 => $P2,
				-Q => \0,
				-flags => 0 # CV_CALIB_ZERO_DISPARITY,
				);
			
            $isVerticalStereo =
				abs($P2->GetReal2D([1, 3]) > $P2->GetReal2D([0, 3]));

			# Precompute maps for cvRemap()
            printf STDERR "Precompute maps for cvRemap\n";
            Cv->InitUndistortRectifyMap(
				-camera_matrix => $M1,
				-dist_coeffs => $D1,
				-R => $R1,
				-new_camera_matrix => $P1,
				-mapx => $mx1,
				-mapy => $my1,
				);
            Cv->InitUndistortRectifyMap(
				-camera_matrix => $M2,
				-dist_coeffs => $D2,
				-R => $R2,
				-new_camera_matrix => $P2,
				-mapx => $mx2,
				-mapy => $my2,
				);
        } elsif ($useUncalibrated == 1 || $useUncalibrated == 2) {

			# OR ELSE HARTLEY'S METHOD
			# use intrinsic parameters of each camera, but compute the
			# rectification transformation directly from the
			# fundamental matrix

			my $H1 = Cv->CreateMat(3, 3, CV_64F);
            my $H2 = Cv->CreateMat(3, 3, CV_64F);
            my $iM = Cv->CreateMat(3, 3, CV_64F);

			# Just to show you could have independently used F
			if ($useUncalibrated == 2) {
				Cv->FindFundamentalMat(
					-point1 => $imagePoints1,
					-point2 => $imagePoints2,
					-fundamental_matrix => $F);
			}
			Cv->StereoRectifyUncalibrated(
				-points1 => $imagePoints1,
				-points2 => $imagePoints2,
				-F => $F,
				-image_size => [ $w, $h ],
				-H1 => $H1,
				-H2 => $H2,
				-threshold => 3,
				);

            Cv->Invert(-src => $M1, -dst => $iM);
            Cv->MatMul(-src1 => $H1, -src2 => $M1, -dst => $R1);
            Cv->MatMul(-src1 => $iM, -src2 => $R1, -dst => $R1);
            Cv->Invert(-src => $M2, -dst => $iM);
            Cv->MatMul(-src1 => $H2, -src2 => $M2, -dst => $R2);
            Cv->MatMul(-src1 => $iM, -src2 => $R2, -dst => $R2);

			# Precompute map for cvRemap()
            Cv->InitUndistortRectifyMap(
				-camera_matrix => $M1, -dist_coeffs => $D1,
				-R => $R1, -new_camera_matrix => $M1,
				-mapx => $mx1, -mapy => $my1);
            Cv->InitUndistortRectifyMap(
				-camera_matrix => $M2, -dist_coeffs => $D2,
				-R => $R2, -new_camera_matrix => $M2,
				-mapx => $mx2, -mapy => $my2);
        } else {
            die "bad combination of useUncalibrated and useUncalibrated";
		}

		# RECTIFY THE IMAGES AND FIND DISPARITY MAPS
        my $pair;
        unless ($isVerticalStereo) {
            $pair = Cv->CreateMat(-rows => $h, -cols => $w * 2, -type => CV_8UC3);
        } else {
            $pair = Cv->CreateMat(-rows => $h * 2, -cols => $w, -type => CV_8UC3);
		}

		# Setup for finding stereo corrrespondences
        my $BMState = Cv->CreateStereoBMState;
        die "can\'t CreateStereoBMState" unless $BMState;

        $BMState->SetPreFilterSize(41);
        $BMState->SetPreFilterCap(31);
        $BMState->SetSADWindowSize(41);
        $BMState->SetMinDisparity(-64);
        $BMState->SetNumberOfDisparities(128);
        $BMState->SetTextureThreshold(10);
        $BMState->SetUniquenessRatio(15);

        for (my $i = 0; $i < $nframes; $i++ ) {
            my $img1 = Cv->LoadImage(${$imageNames[0]}[$i], 0);
            my $img2 = Cv->LoadImage(${$imageNames[1]}[$i], 0);
            if ($img1 && $img2) {
                $img1->Remap(-dst => $img1r, -mapx => $mx1, -mapy => $my1);
                $img2->Remap(-dst => $img2r, -mapx => $mx2, -mapy => $my2);

                $img1r->ShowImage("img1r");
                $img2r->ShowImage("img2r");
                Cv->WaitKey(100);

                #Cv->SaveImage(sprintf("remap_l_%02d.png", $i), $img1r);
                #Cv->SaveImage(sprintf("remap_r_%02d.png", $i), $img2r);

                if (!$isVerticalStereo || $useUncalibrated) {
					# When the stereo camera is oriented vertically,
					# useUncalibrated==0 does not transpose the image,
					# so the epipolar lines in the rectified images
					# are vertical. Stereo correspondence function
					# does not support such a case.
                    $BMState->FindStereoCorrespondenceBM(
						-left => $img1r, -right => $img2r, -disparity => $disp);
                    $disp->Normalize(-dst => $vdisp, -a => 0, -b => 256,
									 -norm_type => CV_MINMAX);
                    $vdisp->ShowImage("disparity");
                }
                unless ($isVerticalStereo) {
                    $img1r->CvtColor(
						-dst => $pair->GetCols(-start => 0, -end => $w),
						-code => CV_GRAY2BGR);
                    $img2r->CvtColor(
						-dst => $pair->GetCols(-start => $w, -end => $w + $w),
						-code => CV_GRAY2BGR);
                    for (my $j = 0; $j < $h; $j += 16) {
                        $pair->Line(-pt1 => [ 0, $j ], -pt2 => [ $w * 2, $j ],
									-color => CV_RGB(0, 255, 0),
							);
					}
                } else {
                    $img1r->CvtColor(
						-dst => $pair->GetRows(-start => 0, -end => $h),
						-code => CV_GRAY2BGR);
                    $img2r->CvtColor(
						-dst => $pair->GetRows(-start => $h, -end => $h + $h),
						-code => CV_GRAY2BGR);
                    for (my $j = 0; $j < $w; $j += 16) {
                        $pair->Line(-pt1 => [ $j, 0 ], -pt2 => [ $j, $h * 2],
									-color => CV_RGB(0, 255, 0),
							);
					}
                }
                $pair->ShowImage("rectified");
                my $c = Cv->WaitKey(100);
				$c &= 0x7f if ($c >= 0);
                last if ($c == 27);
            }
        }
    }
}
