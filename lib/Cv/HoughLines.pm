# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::HoughLines;

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
					 -method => &CV_HOUGH_STANDARD,
					 -rho => undef,
					 -theta => undef,
					 -threshold => undef,
					 -param1 => 0,
					 -param2 => 0,
				   ], @_);
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
usage:	Cv::Seq::RhoTheta->GetSeqElem(
	-index => Index of element.
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (CV_SEQ_ELTYPE($av{-seq}) == &CV_32FC2) {
		my ($rho, $theta) = cvPoint(
			[unpack("f2", $self->SUPER::GetSeqElem(-index => $av{-index}))]);
		my @line = ($rho, $theta);
		wantarray? @line : \@line
	} else {
		goto usage;
	}
}

1;
