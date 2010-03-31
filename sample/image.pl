#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;
use Data::Dumper;

# The short example shows how to use new-style image classes declared
# in cxcore.hpp.  There is also a very similar matrix class (CvMatrix)
# - a wrapper for CvMat

# load image in constructor: the image can be loaded either from
# bitmap (see cvLoadImage), or from XML/YAML (see cvLoad)

my $img = Cv->load(
    -filename => @ARGV > 0 ? shift : dirname($0).'/'."lena.jpg",
    -flags => CV_LOAD_IMAGE_COLOR);
die "$0: can't load\n" unless $img; # check if the image has been loaded properly
my $rng = Cv->RNG;

# clone the image (although, later the content will be replaced with
# cvCvtColor, clone() is used for simplicity and for the illustration)
my $img_yuv = $img->clone;

# simply call OpenCV functions and pass the class instances there
Cv->CvtColor(-src => $img, -dst => $img_yuv, -code => CV_BGR2YCrCb);

# we can do it more easily. 
# my $img_yuv = $img->CvtColor(-code => CV_BGR2YCrCb);

# another method to create an image - from scratch
my $y = $img->new(-depth => IPL_DEPTH_8U, -channels => 1);
my $noise = $img->new(-depth => IPL_DEPTH_32F, -channels => 1);

Cv->Split(-src => $img_yuv, -dst => [ $y, undef, undef, undef ]);
$rng->RandArr(
    -arr => $noise,
    -dist_type => CV_RAND_NORMAL,
    -param1 => scalar cvScalarAll(0),
    -param2 => scalar cvScalarAll(20),
    );
$noise->Smooth(
    -dst => $noise,
    -smoothtype => CV_GAUSSIAN,
    -size1 => 5, -size2 => 5,
    -sigma1 => 1, -sigma2 => 1,
    );
$noise->Acc(-image => $y)
    ->Convert(-dst => $y);
Cv->Merge(-src => [ $y, undef, undef, undef ], -dst => $img_yuv)
	->CvtColor(-dst => $img, -code => CV_YCrCb2BGR);

# show method is the conveninient form of cvShowImage
$img->NamedWindow(-name => "image with grain", -flags => CV_WINDOW_AUTOSIZE)
	->show->WaitKey;

# all the images will be released automatically

exit 0;
