#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;
use Data::Dumper;

my $USE_LINEARPOLAR = 0;

my $capture = undef;
if (@ARGV == 0) {
    $capture = Cv->CreateCameraCapture(0);
} elsif (@ARGV == 1 && $ARGV[0] =~ /^\d$/) {
    $capture = Cv->CreateCameraCapture($ARGV[0]);
} else {
    $capture = Cv->CreateFileCapture($ARGV[0]);
}
unless ($capture) {
    print STDERR <<"----";
Could not initialize capturing...
Usage: $0 <CAMERA_NUMBER>, or
       $0 <VIDEO_FILE>
----
;
    exit(1);
}


Cv->NamedWindow("Log-Polar", 0)->MoveWindow(700, 20);
Cv->NamedWindow("Recovered image", 0)->MoveWindow(20, 700);
if (CV_MAJOR_VERSION >= 2) {
    Cv->NamedWindow("Linear-Polar", 0)->MoveWindow(20, 20);
}

while (my $frame = $capture->QueryFrame) {
    my $center = cvPoint($frame->width/2, $frame->height/2);
    my $log_polar_img = $frame->LogPolar(
	-center => $center, -M => 70,
	-flags => CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS);
    $log_polar_img->ShowImage("Log-Polar");
    unless ($USE_LINEARPOLAR) {
	$log_polar_img->LogPolar(
	    -center => $center, -M => 70,
	    -flags => CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
	    ->ShowImage("Recovered image");
    }
    if (CV_MAJOR_VERSION == 2) {
	my $lin_polar_img = $frame->LinearPolar(
	    -center => $center, -M => 70,
	    -flags => CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS);
	$lin_polar_img->ShowImage("Linear-Polar");
	if ($USE_LINEARPOLAR) {
	    $lin_polar_img->LinearPolar(
		-center => $center, -M => 70,
		-flags => CV_WARP_INVERSE_MAP+CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
		->ShowImage("Recovered image");
	}
    }
    last if (Cv->WaitKey(10) >= 0);
}
