# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::HoughLines2;

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
#  HoughLines2 - Finds lines in binary image using Hough transform
# ------------------------------------------------------------
sub new {
    my $class = shift;
	my %av = &argv([ -image => \0,
					 -storage => \0,
					 -method => &CV_HOUGH_PROBABILISTIC,
					 -rho => undef,
					 -theta => undef,
					 -threshold => undef,
					 -param1 => 0,
					 -param2 => 0,
				   ], @_);
	unless (blessed $av{-image} &&
			blessed $av{-storage} &&
			defined $av{-method} &&
			defined $av{-rho} &&
			defined $av{-theta} &&
			defined $av{-threshold} &&
			defined $av{-param1} &&
			defined $av{-param2}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv->HoughLine2(
	-image => The input 8-bit single-channel binary image. In case of
	        probabilistic method the image is modified by the function.
	-storage => The storage for the lines detected. It can be a memory
	        storage (in this case a sequence of lines is created in the
	        storage and returned by the function) or single row/single
	        column matrix (CvMat*) of a particular type (see below) to
	        which the lines\' parameters are written. The matrix header
	        is modified by the function so its cols or rows will contain
	        a number of lines detected. If line_storage is a matrix and
	        the actual number of lines exceeds the matrix size, the maximum
	        possible number of lines is returned (in case of standard hough
	        transform the lines are sorted by the accumulator value).
	-method => The Hough transform variant, one of:
	        * CV_HOUGH_STANDARD - classical or standard Hough transform.
	          Every line is represented by two floating-point numbers (rho,
			  theta), where rho is a distance between (0, 0) point and the
	          line, and theta is the angle between x-axis and the normal to
	          the line. Thus, the matrix must be (the created sequence will
	          be) of CV_32FC2 type.
	        * CV_HOUGH_PROBABILISTIC - probabilistic Hough transform (more
	          efficient in case if picture contains a few long linear
	          segments). It returns line segments rather than the whole
	          lines. Every segment is represented by starting and ending
	          points, and the matrix must be (the created sequence will be)
	          of CV_32SC4 type.
	        * CV_HOUGH_MULTI_SCALE - multi-scale variant of classical Hough
	          transform. The lines are encoded the same way as in
	          CV_HOUGH_STANDARD. 
	-rho => Distance resolution in pixel-related units. 
	-theta => Angle resolution measured in radians. 
	-threshold => Threshold parameter. A line is returned by the function if
	        the corresponding accumulator value is greater than threshold. 
	-param1 => The first method-dependent parameter:
	        * For classical Hough transform it is not used (0).
	        * For probabilistic Hough transform it is the minimum line
	          length.
	        * For multi-scale Hough transform it is divisor for distance
	          resolution rho. (The coarse distance resolution will be rho
	          and the accurate resolution will be (rho / param1)). 
	-param2 => The second method-dependent parameter:
	        * For classical Hough transform it is not used (0).
	        * For probabilistic Hough transform it is the maximum gap
	          between line segments lying on the same line to treat them as
	          the single line segment (i.e. to join them).
	        * For multi-scale Hough transform it is divisor for angle
	          resolution theta. (The coarse angle resolution will be theta
	          and the accurate resolution will be (theta / param2)). 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if ($av{-method} == &CV_HOUGH_PROBABILISTIC) {
		bless cvHoughLines2(
			$av{-image},
			$av{-storage},
			$av{-method},
			$av{-rho},
			$av{-theta},
			$av{-threshold},
			$av{-param1},
			$av{-param2},
			), $class;
	} elsif ($av{-method} == &CV_HOUGH_STANDARD) {
		use Cv::HoughLines;
		Cv::HoughLines->new(%av);
	} else {
		goto usage;
	}
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
usage:	Cv::Seq::Point2->GetSeqElem(
	-index => Index of element.
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (CV_SEQ_ELTYPE($av{-seq}) == &CV_32SC4) {
		my ($x1, $y1, $x2, $y2) = cvPoint(
			[unpack("i4", $self->SUPER::GetSeqElem(-index => $av{-index}))]);
		my @point2 = (scalar cvPoint(-x => $x1, -y => $y1),
					  scalar cvPoint(-x => $x2, -y => $y2));
		wantarray? @point2 : \@point2
	} else {
		goto usage;
	}
}

1;
