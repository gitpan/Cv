# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
package Cv::Seq::Point;
use lib qw(blib/lib blib/arch);

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

our $VERSION = '0.02';

sub new {
    my $class = shift;
	my %av = &argv([ -seq_flags => &CV_32SC2,
					 -header_size => &SizeOf_CvContour(),
					 -elem_size => &SizeOf_CvPoint(),
					 -storage => undef,
				   ], @_);
	$class->SUPER::new(%av);
}


sub Push {
	my $self = shift;
	my %av = &argv([ -element => undef,
					 -seq => $self,
				   ], @_);
	unless (defined $av{-element} &&
			blessed $av{-seq}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Seq::Point->Push(
	-element => Added element. (scalar cvPoint)
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (&CV_SEQ_ELTYPE($av{-seq}) == &CV_32SC2) {
		$self->SUPER::Push(-element => pack("i2", cvPoint($av{-element})));
	} else {
		croak "CV_SEQ_ELTYPE = ", &CV_SEQ_ELTYPE($av{-seq});
		goto usage;
	}
}


sub Pop {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Seq::Point->Pop(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (&CV_SEQ_ELTYPE($av{-seq}) == &CV_32SC2) {
		cvPoint([unpack("i2", $self->SUPER::Pop)]);
	} else {
		goto usage;
	}
}


sub Unshift {
	my $self = shift;
	my %av = &argv([ -element => undef,
						 -seq => $self,
					   ], @_);
	unless (defined $av{-element} &&
			blessed $av{-seq}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Seq::Point->Unshift(
	-element => Added element. (scalar cvPoint)
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (&CV_SEQ_ELTYPE($av{-seq}) == &CV_32SC2) {
		$self->SUPER::Unshift(-element => pack("i2", cvPoint($av{-element})));
	} else {
		goto usage;
	}
}


sub Shift {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Seq::Point->Shift(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (&CV_SEQ_ELTYPE($av{-seq}) == &CV_32SC2) {
		cvPoint([unpack("i2", $self->SUPER::Shift)]);
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
usage:	Cv::Seq::Point->GetSeqElem(
	-index => Index of element.
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (&CV_SEQ_ELTYPE($av{-seq}) == &CV_32SC2) {
		cvPoint([unpack("i2", $self->SUPER::GetSeqElem(-index => $av{-index}))]);
	} else {
		carp "CV_SEQ_ELTYPE ", CV_SEQ_ELTYPE($av{-seq}), ": not supported";
		goto usage;
	}
}


1;
