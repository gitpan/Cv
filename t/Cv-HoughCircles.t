#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use Test::More qw(no_plan);
#use Test::More tests => 18;
use Test::Output;
use File::Basename;
use List::Util qw(min max);
BEGIN {
	use_ok('Cv');
}

my $filename = @ARGV > 0? shift : dirname($0).'/'."apollonius.png";
my $img = Cv->LoadImage(-filename => $filename, -flags => 1)
    or die "$0: can't loadimage $filename\n";

my $gray = $img->CvtColor(-code => CV_BGR2GRAY)
	->Smooth(-smoothtype => CV_GAUSSIAN, -size1 => 9, -size2 => 9);
my $storage = Cv::MemStorage->new;
my $circles = Cv->HoughCircles(
	-image => $gray,
	-storage => $storage,
	-method => CV_HOUGH_GRADIENT,
	-dp => 2,
	-min_dist => $gray->height/4,
	-param1 => 200,
	-param2 => 100,
	);
for (my $i = 0; $i < $circles->total; $i++) {
	my ($center, $radius) = $circles->GetSeqElem(-index => $i);
	$img->Circle(
		-center => $center, -radius => 3,
		-color => CV_RGB(0, 255, 0),
		-thickness => -1,-line_type => 8,
		-shift => 0,
		);
	$img->Circle(
		-center => $center, -radius => $radius,
		-color => CV_RGB(255, 0, 0),
		-thickness => 3,-line_type => 8,
		-shift => 0,
		);
}

Cv->NamedWindow(-name => "Circles", -flags => 1)
	->ShowImage(-image => $img);
Cv->WaitKey(1000);
ok(1);
