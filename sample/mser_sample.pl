#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);

use Cv;
use File::Basename;

my @colors = (
	[   0,   0, 255 ],
	[   0, 128, 255 ],
	[   0, 255, 255 ],
	[   0, 255,   0 ],
	[ 255, 128,   0 ],
	[ 255, 255,   0 ],
	[ 255,   0,   0 ],
	[ 255,   0, 255 ],
	[ 255, 255, 255 ],
	[ 196, 255, 255 ],
	[ 255, 255, 196 ],
	);

my @bcolors = (
	[   0,   0, 255 ],
	[   0, 128, 255 ],
	[   0, 255, 255 ],
	[   0, 255,   0 ],
	[ 255, 128,   0 ],
	[ 255, 255,   0 ],
	[ 255,   0,   0 ],
	[ 255,   0, 255 ],
	[ 255, 255, 255 ],
	);

my $path = shift || dirname($0) . "/puzzle.png";
my $img = Cv->LoadImage($path, CV_LOAD_IMAGE_GRAYSCALE);
die "Usage: mser_sample <path_to_image>\n" unless $img;

my $rsp = Cv->LoadImage($path, CV_LOAD_IMAGE_COLOR);
my $ellipses = $img->CvtColor(CV_GRAY2BGR);
my $hsv = $rsp->CvtColor(CV_BGR2YCrCb);

my $params = cvMSERParams();
# my $params = cvMSERParams(5, 60, cvRound(0.2 * $img->width * $img->height), 0.25, 0.2);

my $storage= Cv::MemStorage->new;
my $t = Cv->GetTickCount();
Cv::Arr::cvExtractMSER($hsv, \0, my $contours, $storage, $params);
$t = Cv->GetTickCount() - $t;
printf "MSER extracted %d contours in %g ms.\n",
	$contours->total, $t/(Cv->GetTickFrequency()*1000);

# draw mser with different color
foreach my $i (0 .. $contours->total - 1) {
	my $c = $bcolors[$i % @bcolors];
	my $r = $contours->GetSeq($i);
	foreach my $j (0 .. $r->total - 1) {
		my $pt = $r->GetPoint($j);
		$rsp->Circle($pt, 1, $c);
	}
}

# find ellipse ( it seems cvfitellipse2 have error or sth?
foreach my $i (0 .. $contours->total - 1) {
	my $r = $contours->GetSeq($i);
	my $box = $r->FitEllipse;
	# $box->[4] = CV_PI()/2 - $box->[4];
	$ellipses->ellipseBox($box, $colors[int rand @colors], 3);
}

# $rsp->SaveImage("rsp.png");

Cv->NamedWindow("original", 0);
$img->ShowImage("original");

Cv->NamedWindow("response", 0);
$rsp->ShowImage("response");

Cv->NamedWindow("ellipses", 0);
$ellipses->ShowImage("ellipses");

Cv->WaitKey(0);
