#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;
use Data::Dumper;

my $edge_thresh = 1;

my $filename = @ARGV > 0 ? shift : dirname($0).'/'."fruits.jpg";
my $image = Cv->LoadImage($filename, CV_LOAD_IMAGE_COLOR) or 
	die "Image was not loaded.\n";

# Convert to grayscale
my $gray = $image->CvtColor(CV_BGR2GRAY);
my $edge = Cv->CreateImage([$image->width, $image->height], IPL_DEPTH_8U, 1);

# Create the output image
my $cedge = Cv->CreateImage([$image->width, $image->height], IPL_DEPTH_8U, 3);

# Create a window
my $win = Cv->NamedWindow("Edge")
	->CreateTrackbar( -name => "Threshold", -value => \$edge_thresh,
					  -count => 100, -callback => \&on_trackbar);

# Show the image
&on_trackbar;

# Wait for a key stroke; the same function arranges events processing
Cv->WaitKey;


# define a trackbar callback
sub on_trackbar {

	# XXXXX
    $edge = $gray->Smooth( -smoothtype => CV_BLUR, -size1 => 3, -size2 => 3 );
    $edge = $gray->Not;

    # Run the edge detector on grayscale
    $edge = $gray->Canny( -threshold1 => $edge_thresh,
						  -threshold2 => $edge_thresh*3 );

    # copy edge points
    $cedge->Zero;
    $image->Copy( -dst => $cedge, -mask => $edge );

    $cedge->ShowImage("Edge");
}
