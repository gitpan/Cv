#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;
use Data::Dumper;

my $src = undef;
my $element_shape = CV_SHAPE_RECT;

# the address of variable which receives trackbar position update 
my $max_iters = 10;

my $filename = @ARGV > 0? shift : dirname($0).'/'."baboon.jpg";
$src = Cv->LoadImage(-filename => $filename, -flags => 1)
    or die "$0: can't loadimage $filename\n";

print "Hot keys: \n",
    "\tESC - quit the program\n",
    "\tr - use rectangle structuring element\n",
    "\te - use elliptic structuring element\n",
    "\tc - use cross-shaped structuring element\n",
    "\tSPACE - loop through all the options\n";

# create windows for output images
my $oc = Cv->NamedWindow(-name => "Open/Close",   -flags => 1);
my $ed = Cv->NamedWindow(-name => "Erode/Dilate", -flags => 1);

$oc->CreateTrackbar(-name => "iterations", -callback => \&OpenClose,
		    -value => $max_iters, -count => $max_iters*2 + 1);
$ed->CreateTrackbar(-name => "iterations", -callback => \&ErodeDilate,
		    -value => $max_iters, -count => $max_iters*2 + 1);

while (1) {
    &OpenClose($oc->GetTrackbarPos("iterations"));
    &ErodeDilate($ed->GetTrackbarPos("iterations"));
    my $c = Cv->WaitKey;
    if (($c & 0x7f) == 27) {
	last;
    } elsif (($c & 0x7f) == ord('e')) {
	$element_shape = CV_SHAPE_ELLIPSE;
    } elsif (($c & 0x7f) == ord('r')) {
	$element_shape = CV_SHAPE_RECT;
    } elsif (($c & 0x7f) == ord('c')) {
	$element_shape = CV_SHAPE_CROSS;
    } elsif (($c & 0x7f) == ord(' ')) {
	$element_shape = ($element_shape + 1) % 3;
    }
}

exit 0;


# callback function for open/close trackbar
sub OpenClose {
    my $pos = shift;
    my $n = $pos - $max_iters;
    my $an = abs($n);

    my $element = Cv->CreateStructuringElementEx(
	-cols => $an*2 + 1, -rows => $an*2 + 1,
	-anchor_x => $an, -anchor_y => $an,
	-shape => $element_shape);

    my $dst;
    if ($n < 0) {
        $dst = $src->Erode($element)->Dilate($element);
    } else {
        $dst = $src->Dilate($element)->Erode($element);
    }
    $dst->ShowImage("Open/Close");
}


# callback function for erode/dilate trackbar
sub ErodeDilate {
    my $pos = shift;
    my $n = $pos - $max_iters;
    my $an = abs($n);

    my $element = Cv->CreateStructuringElementEx(
	-cols => $an*2 + 1, -rows => $an*2 + 1,
	-anchor_x => $an, -anchor_y => $an,
	-shape => $element_shape);

    my $dst;
    if ($n < 0) {
        $dst = $src->Erode($element);
    } else {
        $dst = $src->Dilate($element);
    }
    $dst->ShowImage("Erode/Dilate");
}   
