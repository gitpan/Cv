# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

#  Before `make install' is performed this script should be runnable with
#  `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

use File::Basename;
my $lena = dirname($0) . "/lena.jpg";
my $verbose = Cv->hasGUI;

my $arr = Cv->loadImage($lena);
isa_ok($arr, 'Cv::Image');

if (1) {
	my $out = dirname($0) . "/tmp.jpg";
	rmdir($out);
	unlink($out);
	my $saved = $arr->SaveImage($out);
	unlink($out);
	ok($saved);
	isa_ok($saved, 'Cv::Image');
}

if (cvVersion() >= 2.0) {
	my $out = dirname($0) . "/tmp.jpg";
	rmdir($out);
	unlink($out);
	mkdir $out, 0755;
	my $saved = $arr->SaveImage($out);
	rmdir($out);
	ok(!$saved);
}
