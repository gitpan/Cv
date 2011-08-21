# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

#  Before `make install' is performed this script should be runnable with
#  `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

my $verbose = Cv->hasGUI;

if (1) {
	my $rng = Cv->RNG(-1);
	ok($rng);
	ok($rng->isa("Cv::RNG"));
}

if (2) {
	my $rng = Cv::RNG->new(-1);
	ok($rng);
	ok($rng->isa("Cv::RNG"));
}

if (3) {
	my $rng = Cv->RNG(-1);
	$rng->arr(
		my $image = Cv::Image->new([240, 320], CV_8UC3),
		CV_RAND_NORMAL,
		cvScalarAll(127),
		cvScalarAll(64)
		);
	if ($verbose) {
		$image->Show("rng");
		Cv->WaitKey(1000);
	}
}
