# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

#  Before `make install' is performed this script should be runnable with
#  `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
# use Test::More tests => 13;

BEGIN {
	use_ok('Cv');
}

my $verbose = Cv->hasGUI;

if (1) {
	my $image = Cv::Image->new([240, 320], CV_8UC3)->zero;
	if ($verbose) {
		$image->ShowImage("win");
		Cv->SetMouseCallback("win", \&onMouse);
		Cv->WaitKey(1000);
	}
}

sub onMouse {
	print STDERR join(', ', @_), "\n";
}
