# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::HoughCircles;

use 5.008000;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);
use Data::Dumper;

BEGIN {
	$Data::Dumper::Terse = 1;
}

use Cv::Constant;
use Cv::CxCore qw(:all);
use Cv::Seq;

our @ISA = qw(Cv::Seq);

our $VERSION = '0.04';

# Preloaded methods go here.

# ------------------------------------------------------------
#  HoughCircles - Finds circles in grayscale image using Hough transform
# ------------------------------------------------------------
sub new {
    my $class = shift;
	my %av = &argv([ -image => undef,
					 -storage => undef,
					 -method => undef,
					 -dp => undef,
					 -min_dist => undef,
					 -param1 => 100,
					 -param2 => 100,
					 -min_radius => 0,
					 -max_radius => 0,
				   ], @_);
	unless (blessed $av{-image} &&
			blessed $av{-storage} &&
			defined $av{-method} &&
			defined $av{-dp} &&
			defined $av{-min_dist} &&
			defined $av{-param1} &&
			defined $av{-param2} &&
			defined $av{-min_radius} &&
			defined $av{-max_radius}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv->HoughCircles(
	-image => The input 8-bit single-channel grayscale image. 
	-storage => The storage for the circles detected. It can be a memory
	        storage (in this case a sequence of circles is created in the
	        storage and returned by the function) or single row/single
	        column matrix (CvMat*) of type CV_32FC3, to which the circles\'
	        parameters are written. The matrix header is modified by the
	        function so its cols or rows will contain a number of lines
	        detected. If circle_storage is a matrix and the actual number of
	        lines exceeds the matrix size, the maximum possible number of
	        circles is returned. Every circle is encoded as 3 floating-point
	        numbers: center coordinates (x, y) and the radius.
	-method => Currently, the only implemented method is CV_HOUGH_GRADIENT,
	        which is basically 21HT, described in [Yuen03]. 
	-dp => Resolution of the accumulator used to detect centers of the
	        circles. For example, if it is 1, the accumulator will have the
	        same resolution as the input image, if it is 2 - accumulator
	        will have twice smaller width and height, etc. 
	-min_dist => Minimum distance between centers of the detected circles.
	        If the parameter is too small, multiple neighbor circles may be
	        falsely detected in addition to a true one. If it is too large,
	        some circles may be missed. 
	-param1 => The first method-specific parameter. In case of
	        CV_HOUGH_GRADIENT it is the higher threshold of the two passed
	        to Canny edge detector (the lower one will be twice smaller). 
	-param2 => The second method-specific parameter. In case of
	        CV_HOUGH_GRADIENT it is accumulator threshold at the center
	        detection stage. The smaller it is, the more false circles may
	        be detected. Circles, corresponding to the larger accumulator
	        values, will be returned first. 
	-min_radius => Minimal radius of the circles to search for. 
	-max_radius => Maximal radius of the circles to search for. By default
	        the maximal radius is set to max(image_width, image_height). 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvHoughCircles(
		$av{-image},
		$av{-storage},
		$av{-method},
		$av{-dp},
		$av{-min_dist},
		$av{-param1},
		$av{-param2},
		$av{-min_radius},
		$av{-max_radius},
		), $class;
}


# ------------------------------------------------------------
#  GetSeqElem - Returns pointer to sequence element by its index
# ------------------------------------------------------------
sub GetSeqElem {
	my $self = shift;
	my %av = &argv([ -index => 0,
					 -seq => $self,
				   ], @_);
	unless (defined $av{-index} &&
			blessed $av{-seq}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Seq::CenterRadius->GetSeqElem(
	-index => Index of element.
	-seq => Sequence.
	)
----
			);
		$Data::Dumper::Terse = 1;
		croak $usage, " = ", &Dumper(\%av);
	}
	if (CV_SEQ_ELTYPE($av{-seq}) == &CV_32FC3) {
		my ($x, $y, $r) = cvPoint(
			[unpack("f3", $self->SUPER::GetSeqElem(-index => $av{-index}))]);
		my @circle = ( scalar cvPoint(-x => $x, -y => $y), $r );
		wantarray? @circle : \@circle
	} else {
		goto usage;
	}
}

1;
