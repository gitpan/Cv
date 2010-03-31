#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

########################################################################
#
#  This program is demonstration for ellipse fitting. Program finds 
#  contours and approximate it by ellipses.
#
#  Trackbar specify threshold parametr.
#
#  White lines is contours. Red lines is fitting ellipses.
#
#
#  Autor:  Denis Burenkov.
#
########################################################################

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;
use Data::Dumper;

my $FITELLIPSE2 = 1;

my $slider_pos = 70;

# Load the source image. HighGUI use.
my $filename = @ARGV > 0? shift : dirname($0).'/'."stuff.jpg";

# load image and force it to be grayscale
my $image03 = Cv->LoadImage(
	-filename => $filename,
	-flags => CV_LOAD_IMAGE_GRAYSCALE)
    or die "$0: can't loadimage $filename\n";
    
# Create windows.
my $swin = Cv->NamedWindow("Source", 1)
	->ShowImage(-image => $image03);

# Create toolbars. HighGUI use.
my $rwin = Cv->NamedWindow("Result", 1)
	->CreateTrackbar(
    -name => "Threshold",
    -value => \$slider_pos,
    -count => 255,
    -callback => \&process_image,
    );
&process_image;

# Wait for a key stroke; the same function arranges events processing
Cv->WaitKey;
exit 0;

# Define trackbar callback functon. This function find contours, draw
# it and approximate it by ellipses.

sub process_image {
	# Create dynamic structure
	my $stor = Cv::MemStorage->new;

	# Threshold the source image. This needful for cvFindontours().
	my $image02 = $image03->Threshold(
		-threshold => $slider_pos,
		-max_value => 255,
		-threshold_type => CV_THRESH_BINARY,
		);
	$rwin->ShowImage($image02);

	# Find all contours.
	my $cont = Cv->FindContours(
		-image => $image02,
		-storage => $stor,
		# -header_size => sizeof(CvContour), 
		-mode => CV_RETR_LIST,
		-method => CV_CHAIN_APPROX_NONE,
		-offset => scalar cvPoint(0, 0),
		);

	# Clear images. IPL use.
	my $image04 = $image02->new(-channels => 3)->Zero;

	# This cycle draw all contours and approximate it by ellipses.
	for ( ; $cont; $cont = $cont->h_next) {
		my $count = $cont->total; # This is number point in contour

		# Number point must be more than or equal to 6 (for cvFitEllipse_32f).
		next if ($count < 6);

		my $box;
		if ($FITELLIPSE2) {
			# Fits ellipse to current contour.
			$box = $cont->FitEllipse;
		} else {
			# Get contour point set.
			$cont->CvtSeqToArray(
				-elements => my $points = [],
				-slice => CV_WHOLE_SEQ,
				);
			# Fits ellipse to current contour.
			$box = Cv->FitEllipse(-points => $points); # XXXXX
		}

		# Draw current contour.
		$cont->Draw(
			-image => $image04,
			-external_color => CV_RGB(255, 255, 255),
			-hole_color => CV_RGB(255, 255, 255),
			-max_level => 0,
			-thickness => 1,
			-line_type => 8,
			-offset => scalar cvPoint(0, 0),
			);

		# Convert ellipse data and draw it.
		$image04->Ellipse(
			-center => $box->{center},
			-axes => scalar cvSize(
				 -width  => $box->{size}{width}  / 2,
				 -height => $box->{size}{height} / 2,
			),
			-angle => -$box->{angle},
			-start_angle => 0,
			-end_angle => 360,
			-color => CV_RGB(0, 0, 255),
			-thickness => 1,
			-line_type => CV_AA,
			-shift => 0,
			);
	}
    
	# Show image. HighGUI use.
	$rwin->ShowImage($image04);
}
