# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq::Reader;

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

# Preloaded methods go here.

# ------------------------------------------------------------
#  StartReadSeq - Initializes process of sequential reading from sequence
# ------------------------------------------------------------
sub new {
	my $class = shift;
	my %av = &argv([ -reverse => 0,
					 # -reader => undef,
					 -seq => undef,
				   ], @_);
	unless (blessed($av{-seq})) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->StartReadSeq(
	-seq => Sequence.
	-reader => Reader state; initialized by the function. 
	-reverse => Determines the direction of the sequence traversal. If
	        reverse is 0, the reader is positioned at the first sequence
	        element, otherwise it is positioned at the last element.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvStartReadSeq($av{-seq}, $av{-reverse}), $class;
}

sub DESTROY {
	my $self = shift;
	cvReleaseReader($self);
}

sub ReadSeqElem {
	my $self = shift;
	cvReadSeqElem($self);
}

sub NextSeqElem {
	my $self = shift;
	cvNextSeqElem($self);
}

sub ptr {
	my $self = shift;
	CvSeqReader_ptr($self);
}


1;
