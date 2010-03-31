#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use lib qw(../blib/lib ../blib/arch);
use Cv;
use File::Basename;
use List::Util qw(min);

# This is a standalone program. Pass an image name as a first
# parameter of the program.  Switch between standard and probabilistic
# Hough transform by changing "$HOUGH_STANDARD = 1" to
# "$HOUGH_STANDARD = 0" and back.

my $HOUGH_STANDARD = 0;

my $filename = @ARGV > 0? shift : dirname($0).'/'."pic1.png";
my $src = Cv->LoadImage(-filename => $filename, -flags => 0)
    or die "$0: can't loadimage $filename\n";

my $dst = $src->new(-depth => 8, -channels => 1);
my $color_dst = $src->new(-depth => 8, -channels => 3);
my $storage = Cv::CreateMemStorage;

$src->Canny(
	-threshold1 => 50, -threshold2 => 200,
	-aperture_size => 3,
	-dst => $dst,
	);
$dst->CvtColor(
	-code => CV_GRAY2BGR, -dst => $color_dst,
	);

if ($HOUGH_STANDARD) {
    my $lines = Cv->HoughLines2(
		-image => $dst,
		-storage => $storage,
		-method => CV_HOUGH_STANDARD,
		-rho => 1,
		-theta => CV_PI/180,
		-threshold => 100,
		);
    for (my $i = 0; $i < min($lines->total, 100); $i++) {
        my ($rho, $theta) = $lines->GetSeqElem(-index => $i);
        my ($a, $b) = (cos($theta), sin($theta));
        my ($x0, $y0) = ($a * $rho, $b * $rho);
        my $pt1 = cvPoint(-x => $x0 + 1000 * (-$b), -y => $y0 + 1000 * $a);
        my $pt2 = cvPoint(-x => $x0 - 1000 * (-$b), -y => $y0 - 1000 * $a);
		$color_dst->Line(
			-pt1 => $pt1, -pt2 => $pt2,
			-color => CV_RGB(255, 0, 0),
			-thickness => 3,-line_type => CV_AA,
			-shift => 0,
			);
    }
} else {
	my $lines = Cv->HoughLines2(
		-image => $dst,
		-storage => $storage,
		-method => CV_HOUGH_PROBABILISTIC,
		-rho => 1,
		-theta => CV_PI/180,
		-threshold => 50,
		-param1 => 50,
		-param2 => 10,
		);
    for (my $i = 0; $i < $lines->total; $i++) {
        my ($pt1, $pt2) = $lines->GetSeqElem(-index => $i);
        $color_dst->Line(
			-pt1 => $pt1, -pt2 => $pt2,
			-color => CV_RGB(255, 0, 0),
			-thickness => 3, -line_type => CV_AA,
			-shift => 0,
			);
    }
}

Cv->NamedWindow(-name => "Source", -flags => 1)
	->ShowImage(-image => $src);
Cv->NamedWindow(-name => "Hough", -flags => 1)
	->ShowImage(-image => $color_dst);
Cv->WaitKey;
