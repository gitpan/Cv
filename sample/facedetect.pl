#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);

use Cv;
use File::Basename;

my $haarDir = "/usr/local/share/OpenCV/haarcascades";

sub help {
	die << "----";

This program demonstrates the haar cascade recognizer this classifier
can recognize many ~rigid objects, it\'s most known use is for faces.

Usage:
\$ .\/facedetect
	[--cascade=<cascade_path>]
		this is the primary trained classifier such as frontal face
	[--nested-cascade[=<nested_cascade_path>]]
		this an optional secondary classifier such as eyes
	[--scale=<image scale greater or equal to 1, try 1.3 for example>]
	[filename|camera_index]

see facedetect.cmd for one call:
\$ .\/facedetect
	--cascade=$haarDir/haarcascade_frontalface_alt.xml
	--nested-cascade=$haarDir/haarcascade_eye.xml
	--scale=1.3

Hit any key to quit.
----
	 ;
}

my $cascadeName       = "$haarDir/haarcascade_frontalface_alt.xml";
my $nestedCascadeName = "$haarDir/haarcascade_eye_tree_eyeglasses.xml";
my $scale = 1;

my $inputName;
my $cascade;
my $nestedCascade;

use Getopt::Long;
unless (GetOptions(
	"--cascade=s" => \$cascadeName,
	"--nested-cascade=s" => \$nestedCascadeName,
	"--scale=s" => \$scale,
		)) {
	help();
}

my $inputName = shift(@ARGV);
my $cascade = Cv::FileStorage->Load($cascadeName);
unless ($cascade) {
	die "ERROR: Could not load classifier cascade";
}
my $nestedCascade = Cv::FileStorage->Load($nestedCascadeName);
unless ($nestedCascade) {
	warn "WARNING: Could not load classifier cascade for nested objects\n";
}

my $capture;
my $image;
if ($inputName =~ /^\d$/) {
    $capture = Cv->captureFromCAM($inputName);
	unless ($capture) {
		warn "Capture from CAM $inputName didn't work\n";
	}
} elsif ($inputName) {
	$image = Cv->loadImage($inputName);
	unless ($image) {
		$capture = Cv->captureFromFile($inputName);
		unless ($capture) {
			warn "Capture from AVI $inputName didn't work\n";
		}
	}
}
unless ($capture || $image) {
	my $lena = dirname($0) . "/lena.jpg";
	$image = Cv->loadImage($lena);
}

Cv->NamedWindow("result", 0);

if ($capture) {
	while (my $frame = $capture->queryFrame) {
		my $frameCopy = $frame->flip(\0, 1)->clone;
		detectAndDraw($frameCopy, $cascade, $nestedCascade, $scale);
		last if Cv->waitKey(10) > 0;
	}
} elsif ($image) {
	detectAndDraw($image, $cascade, $nestedCascade, $scale);
	Cv->waitKey;
}


sub detectAndDraw {
	my ($img, $cascade, $nestedCascade, $scale) = @_;
    my @colors = (
		CV_RGB(  0,   0, 255),
        CV_RGB(  0, 128, 255),
        CV_RGB(  0, 255, 255),
        CV_RGB(  0, 255,   0),
        CV_RGB(255, 128,   0),
        CV_RGB(255, 255,   0),
        CV_RGB(255,   0,   0),
        CV_RGB(255,   0, 255)
		);
    my $gray = $img->cvtColor(CV_BGR2GRAY);
	my $smallSize = [map { cvRound($_ / $scale) } @{$img->sizes}];
	my $smallImg = $img->new($smallSize, CV_8UC1);
	$gray->resize($smallImg, CV_INTER_LINEAR);
	$smallImg->EqualizeHist($smallImg);
	my $storage = Cv::MemStorage->new;
    my $t = Cv->GetTickCount();
	my $faces = $smallImg->HaarDetectObjects(
		$cascade, $storage, 1.1, 2, 0
        # |CV_HAAR_FIND_BIGGEST_OBJECT
        # |CV_HAAR_DO_ROUGH_SEARCH
        |CV_HAAR_SCALE_IMAGE
		,
        cvSize(30, 30)
		);
    $t = Cv->GetTickCount() - $t;
    printf("detection time = %g ms\n", $t/(Cv->GetTickFrequency()*1000));
	foreach my $i (0 .. $faces->total - 1) {
		my $color = $colors[$i % @colors];
		my ($x, $y, $w, $h) = unpack("i4", $faces->GetSeqElem($i));
		my $center = [
			cvRound(($x + $w * 0.5) * $scale),
			cvRound(($y + $h * 0.5) * $scale),
			];
		my $radius = cvRound(($w + $h) * 0.25 * $scale);
        $img->circle($center, $radius, $color, 3, 8, 0);
		next unless $nestedCascade;
        $smallImg->ROI([$x, $y, $w, $h]);
		my $nestedObjects = $smallImg->HaarDetectObjects(
			$nestedCascade, $storage, 1.1, 2, 0
            # |CV_HAAR_FIND_BIGGEST_OBJECT
            # |CV_HAAR_DO_ROUGH_SEARCH
            # |CV_HAAR_DO_CANNY_PRUNING
            |CV_HAAR_SCALE_IMAGE
			,
			cvSize(30, 30)
			);
        $smallImg->resetROI;
		foreach my $j (0 .. $nestedObjects->total - 1) {
			my ($nx, $ny, $nw, $nh) =
				unpack("i4", $nestedObjects->GetSeqElem($j));
			my $center = [
				cvRound(($x + $nx + $nw * 0.5) * $scale),
				cvRound(($y + $ny + $nh * 0.5) * $scale),
				];
			my $radius = cvRound(($nw + $nh) * 0.25 * $scale);
			# $img->circle($center, $radius, $color, 3, 8, 0);
			$img->rectangle(
				[$x + $nx, $y + $ny], [$x + $nx + $nw, $y + $ny + $nh ], 
				$color, 3, 8, 0);
		}
	}
	$img->show("result");
}
