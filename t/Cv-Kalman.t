# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

# Tracking of rotating point.  Rotation speed is constant.  Both state
# and measurements vectors are 1D (a point angle), Measurement is the
# real point angle + gaussian noise.  The real and the estimated
# points are connected with yellow line segment, the real and the
# measured points are connected with red line segment.  (if Kalman
# filter works correctly, the yellow segment should be shorter than
# the red one).  Pressing any key (except ESC) will reset the tracking
# with a different speed.  Pressing ESC will stop the program.

use Test::More qw(no_plan);
#use Test::More tests => 2;
use Test::Output;
BEGIN {
	use_ok('Cv');
}

my $img = Cv->new(
    -size => scalar cvSize(500, 500), -depth => 8, -channels => 3,
    );

my $kalman = Cv->CreateKalman(
    -dynam_params => 2, -measure_params => 1, -control_params => 0,
	);

my $state         = Cv->CreateMat(-rows => 2, -cols => 1, -type => CV_32FC1);
my $process_noise = Cv->CreateMat(-rows => 2, -cols => 1, -type => CV_32FC1);
my $measurement   = Cv->CreateMat(-rows => 1, -cols => 1, -type => CV_32FC1)
	->Zero;

my $rng = Cv->RNG;
my $code = -1;

Cv->NamedWindow(-name => "Kalman", -flags => 1);

my $t0 = time;
while (1) {
    $rng->RandArr(-arr => $state,
				  -dist_type => CV_RAND_NORMAL,
				  -param1 => scalar cvRealScalar(0),
				  -param2 => scalar cvRealScalar(0.1),
		);

	my @A = ( 1, 1, 0, 1 );
	$kalman->transition_matrix		->SetReal1D($_, $A[$_]) for (0 .. $#A);
	$kalman->measurement_matrix		->SetIdentity(scalar cvRealScalar(1));
	$kalman->process_noise_cov		->SetIdentity(scalar cvRealScalar(1e-5));
	$kalman->measurement_noise_cov	->SetIdentity(scalar cvRealScalar(1e-1));
	$kalman->error_cov_post			->SetIdentity(scalar cvRealScalar(1));

	$rng->RandArr(-arr => $kalman->state_post,
				  -dist_type => CV_RAND_NORMAL,
				  -param1 => scalar cvRealScalar(0),
				  -param2 => scalar cvRealScalar(0.1),
	);

    while (1) {
		my $state_pt = &calc_point($state->GetReal1D(0));

		my $prediction = $kalman->Predict(-control => \0);
		my $predict_pt = &calc_point($prediction->GetReal1D(0));

		my $MNCovariance = $kalman->measurement_noise_cov->GetReal1D(0);
		$rng->RandArr(-arr => $measurement,
					  -dist_type => CV_RAND_NORMAL,
					  -param1 => scalar cvRealScalar(0),
					  -param2 => scalar cvRealScalar(sqrt($MNCovariance)),
			);

		# generate measurement
		Cv->MatMulAdd(-src1 => $kalman->measurement_matrix,
					  -src2 => $state, -src3 => $measurement,
					  -dst => $measurement,
			);

		my $measurement_pt = &calc_point($measurement->GetReal1D(0));

		# plot points
		$img->Zero;
		&draw_cross($state_pt,       CV_RGB(255, 255, 255), 3);
		&draw_cross($measurement_pt, CV_RGB(255,   0,   0), 3);
		&draw_cross($predict_pt,     CV_RGB(  0, 255,   0), 3);
		$img->Line(-pt1 => $state_pt, -pt2 => $measurement_pt,
				   -color => CV_RGB(255, 0, 0), -thickness => 3,
				   -line_type => CV_AA, -shift => 0,
			);
		$img->Line(-pt1 => $state_pt, -pt2 => $predict_pt,
				   -color => CV_RGB(255, 255, 0), -thickness => 3,
				   -line_type => CV_AA, -shift => 0,
			);
		$kalman->Correct(-measurement => $measurement);
		my $PNCovariance = $kalman->process_noise_cov->GetReal1D(0);
		$rng->RandArr(-arr => $process_noise,
					  -dist_type => CV_RAND_NORMAL,
					  -param1 => scalar cvRealScalar(0),
					  -param2 => scalar cvRealScalar(sqrt($PNCovariance)),
			);
		Cv->MatMulAdd(-src1 => $kalman->transition_matrix,
					  -src2 => $state, -src3 => $process_noise,
					  -dst => $state,
			);

		$img->ShowImage(-name => "Kalman");
		$code = Cv->WaitKey(100);
		$code &= 0x7f if ($code > 0);
		if ($code < 0) {
			if (time - $t0 >= 10) {
				$code = 27;
			}
		}
		last if ($code >= 0);
	}

	last if ($code == 27 || $code == ord('q') || $code == ord('Q'));
}


sub calc_point {
    my $angle = shift;
    cvPoint(
		-x => $img->width/2 + $img->width/3*cos($angle),
		-y => $img->height/2 - $img->width/3*sin($angle),
	);
}


sub draw_cross {
    my ($center, $color, $d) = @_;
	my ($x, $y) = cvPoint($center);
    $img->Line(
		-pt1 => scalar cvPoint($x - $d, $y - $d),
		-pt2 => scalar cvPoint($x + $d, $y + $d),
		-color => $color, -thickness => 1, -line_type => CV_AA, -shift => 0,
	);
    $img->Line(
		-pt1 => scalar cvPoint($x + $d, $y - $d),
		-pt2 => scalar cvPoint($x - $d, $y + $d),
		-color => $color, -thickness => 1, -line_type => CV_AA, -shift => 0,
	);
}
