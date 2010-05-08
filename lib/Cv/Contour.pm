# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Contour;

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
use Cv::Seq::Point;

our @ISA = qw(Cv::Seq::Point);

our $VERSION = '0.03';

# ------------------------------------------------------------
#  ApproxChains - Approximates Freeman chain(s) with polygonal curve
#  (see Cv::Seq)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  StartReadChainPoints - Initializes chain reader
#  (see Cv::Seq)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  ReadChainPoint - Gets next chain point
#  (see Cv::Seq)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  ApproxPoly - Approximates polygonal curve(s) with desired precision
#  (see Cv::Seq)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  BoundingRect - Calculates up-right bounding rectangle of point set
#  (see Cv::Seq)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  ContourArea - Calculates area of the whole contour or contour section
#  (see Cv::Seq)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  FindContours - Finds contours in binary image
# ------------------------------------------------------------
sub Find {
    my $class = shift;
	my %av = &argv([ -image => undef,
					 -storage => undef,
					 -contour => undef,
					 -header_size => undef,
					 -mode => &CV_RETR_LIST,
					 -method => &CV_CHAIN_APPROX_SIMPLE,
					 -offset => [ 0, 0 ],
				   ], @_);
	if ($av{-method} == &CV_CHAIN_CODE) {
		$av{-header_size} ||= SizeOf_CvChain();
	} else {
		$av{-header_size} ||= SizeOf_CvContour();
	}
	unless (blessed($av{-image}) &&
			blessed($av{-storage})) {
		chop(my $usage = <<"----"
usage:	Cv::Contour->Find(
	-image => The source 8-bit single channel image. Non-zero pixels are
	        treated as 1\'s, zero pixels remain 0\'s - that is image treated
	        as binary. To get such a binary image from grayscale, one may
	        use cvThreshold, cvAdaptiveThreshold or cvCanny.  The function
	        modifies the source image content.
	-storage => Container of the retrieved contours. 
	-first_contour => Output parameter, will contain the pointer to the
	        first outer contour.
	-header_size => Size of the sequence header, >= sizeof(CvChain) if
	        method = CV_CHAIN_CODE, and >= sizeof(CvContour) otherwise.
	-mode => Retrieval mode.
	         * CV_RETR_EXTERNAL - retrieve only the extreme outer contours
	         * CV_RETR_LIST - retrieve all the contours and puts them in
	           the list
	         * CV_RETR_CCOMP - retrieve all the contours and organizes them
	           into two-level hierarchy: top level are external boundaries
	           of the components, second level are boundaries of the holes
	         * CV_RETR_TREE - retrieve all the contours and reconstructs
	           the full hierarchy of nested contours 
	-method => Approximation method (for all the modes, except CV_RETR_RUNS,
	        which uses built-in approximation).
	         * CV_CHAIN_CODE - output contours in the Freeman chain code.
	           All other methods output polygons (sequences of vertices).
	         * CV_CHAIN_APPROX_NONE - translate all the points from the
	           chain code into points;
	         * CV_CHAIN_APPROX_SIMPLE - compress horizontal, vertical, and
	           diagonal segments, that is, the function leaves only their
	           ending points;
	         * CV_CHAIN_APPROX_TC89_L1,
	         * CV_CHAIN_APPROX_TC89_KCOS - apply one of the flavors of
	           Teh-Chin chain approximation algorithm. CV_LINK_RUNS - use
	           completely different contour retrieval algorithm via linking
	           of horizontal segments of 1\'s. Only CV_RETR_LIST retrieval
	           mode can be used with this method.
	-offset => Offset, by which every contour point is shifted. This is
	        useful if the contours are extracted from the image ROI and then
	        they should be analyzed in the whole image context.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $self = undef; my $phys;
	if (cvFindContours(
			$av{-image},
			$av{-storage},
			$phys,
			$av{-header_size},
			$av{-mode},
			$av{-method},
			pack("i2", cvPoint($av{-offset})))) {
		$self = bless $phys, $class;
	}
	$self;
}


# ------------------------------------------------------------
#  DrawContours - Draws contour outlines or interiors in the image
# ------------------------------------------------------------
sub Draw {
	my $self = shift;
	my %av = argv([ -image => undef,
					-contour => $self,
					-external_color => undef,
					-hole_color => undef,
					-max_level => 1,
					-thickness => 1,
					-line_type => 8,
					-offset => [ 0, 0 ],
				  ], @_);

	unless (blessed($av{-image}) &&
			blessed($av{-contour}) &&
			CV_IS_SEQ($av{-contour})) {
		chop(my $usage = <<"----"
usage:	Cv::Contour->Draw(
	-image => Image where the contours are to be drawn. Like in any other
	        drawing function, the contours are clipped with the ROI.
    -contour => Pointer to the first contour.
    -external_color => Color of the external contours.
	-hole_color => Color of internal contours (holes).
	-max_level => Maximal level for drawn contours. If 0, only contour is
	        drawn. If 1, the contour and all contours after it on the same
	        level are drawn. If 2, all contours after and all contours one
	        level below the contours are drawn, etc. If the value is
	        negative, the function does not draw the contours following
	        after contour but draws child contours of contour up to
	        abs(max_level)-1 level. 
	-thickness => Thickness of lines the contours are drawn with. If it
	        is negative (e.g. =CV_FILLED), the contour interiors are drawn.
	-line_type => Type of the contour segments, see cvLine description.
	-offset => Shift all the point coordinates by the specified value.
	        It is useful in case if the contours retrieved in some image ROI
	        and then the ROI offset needs to be taken into account during
	        the rendering. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvDrawContours(
		$av{-image},
		$av{-contour},
		pack("d4", cvScalar($av{-external_color})),
		pack("d4", cvScalar($av{-hole_color})),
		$av{-max_level},
		$av{-thickness},
		$av{-line_type},
		pack("i2", cvPoint($av{-offset})),
		);
	$av{-image};
}

# ------------------------------------------------------------
#  CheckContourConvexity - Tests contour convex
# ------------------------------------------------------------
sub CheckContourConvexity {
	my $self = shift;
	my %av = argv([ -contour => $self,
					  ], @_);
	unless (defined($av{-contour})) {
		chop(my $usage = <<"----"
usage:	Cv::Contour->CheckContourConvexity(
	-contour => Tested contour (sequence or array of points).
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCheckContourConvexity(
		$av{-contour},
		);
}


1;
