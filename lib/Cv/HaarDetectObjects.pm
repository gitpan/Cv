# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::HaarDetectObjects;

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

our $VERSION = '0.03';

# ------------------------------------------------------------
#  HaarDetectObjects - Detects objects in the image
# ------------------------------------------------------------

sub new {
    my $class = shift;
	my %av = &argv([ -image => undef,
					 -cascade => undef,
					 -storage => undef,
					 -scale_factor => 1.1,
					 -min_neighbors => 3,
					 -flags => 0,
					 -min_size => [0, 0],
				   ], @_);
	unless (blessed $av{-image} &&
			defined $av{-cascade} &&
			blessed $av{-storage}) {
		chop(my $usage = <<"----"
usage:	Cv::HaarDetectObjects->new(
	-image => Image to detect objects in.
	-cascade => Haar classifier cascade in internal representation.
	-storage => Memory storage to store the resultant sequence of the object
	        candidate rectangles.
	-scale_factor => The factor by which the search window is scaled between
	        the subsequent scans, for example, 1.1 means increasing	window
	        by 10%.
	-min_neighbors => Minimum number (minus 1) of neighbor rectangles that
	        makes up an object. All the groups of a smaller number of
	        rectangles than min_neighbors-1 are rejected. If min_neighbors
	        is 0, the function does not any grouping at all and returns all
	        the detected candidate rectangles, which may be useful if the
	        user wants to apply a customized grouping procedure. 
	-flags => Mode of operation. It can be a combination of zero or more of
	        the following values:
	        CV_HAAR_SCALE_IMAGE - for each scale factor used the function
	        will downscale the image rather than "zoom" the feature
	        coordinates in the classifier cascade. Currently, the option can
	        only be used alone, i.e. the flag can not be set together with
	        the others.
	        CV_HAAR_DO_CANNY_PRUNING - If it is set, the function uses Canny
	        edge detector to reject some image regions that contain too few
	        or too much edges and thus can not contain the searched object.
	        The particular threshold values are tuned for face detection and
	        in this case the pruning speeds up the processing.
	        CV_HAAR_FIND_BIGGEST_OBJECT - If it is set, the function finds
	        the largest object (if any) in the image. That is, the output
	        sequence will contain one (or zero) element(s).
	        CV_HAAR_DO_ROUGH_SEARCH - It should be used only when
	        CV_HAAR_FIND_BIGGEST_OBJECT is set and min_neighbors > 0. If the
	        flag is set, the function does not look for candidates of a
	        smaller size as soon as it has found the object (with enough
	        neighbor candidates) at the current scale. Typically, when
	        min_neighbors is fixed, the mode yields less accurate (a bit
	        larger) object rectangle than the regular single-object mode
	        (flags=CV_HAAR_FIND_BIGGEST_OBJECT), but it is much faster, up
	        to an order of magnitude. A greater value of min_neighbors may
	        be specified to improve the accuracy.
	        Note, that in single-object mode CV_HAAR_DO_CANNY_PRUNING does
	        not improve performance much and can even slow down the
	        processing. 
	-min_size => Minimum window size. By default, it is set to the size of
	        samples the classifier has been trained on (~20×20 for face
	        detection). 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvHaarDetectObjects(
		$av{-image},
		$av{-cascade},
		$av{-storage},
		$av{-scale_factor},
		$av{-min_neighbors},
		$av{-flags},
		pack("i2", Cv::cvSize($av{-min_size})),
		);
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
usage:	Cv::HaarDetectObjects->GetSeqElem(
	-index => Index of element.
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (CV_SEQ_ELTYPE($av{-seq}) == &CV_32SC4) {
		my ($x, $y, $width, $height) = cvRect(
			[unpack("i4", $self->SUPER::GetSeqElem(-index => $av{-index}))]);
		my @rect = cvRect(
			-x => $x, -y => $y, -width => $width, -height => $height);
		wantarray? @rect : \@rect
	} else {
		goto usage;
	}
}


1;
__END__
