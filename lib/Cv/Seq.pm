# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq;

use 5.008008;
use strict;
use warnings;

BEGIN {
	Cv::aliases(
		[ 'Cv::CreateSeq', 'new' ],
		[ 'cvClearSeq' ],
		[ 'cvCloneSeq' ],
		[ 'cvCvtSeqToArray', 'CvtSeqToArray' ],
		[ 'cvStartReadSeq', 'StartReadSeq' ],
		[ 'cvGetSeqElem', 'GetSeqElem' ],
		[ 'cvGetSeqElem_Point', 'GetPoint' ],
		[ 'cvGetSeqElem_Seq', 'GetSeq' ],
		[ 'cvGetSeqElem_Contour', 'GetContour' ],
		[ 'cvGetSeqElem_SURFPoint', 'GetSURFPoint' ],
		);
}

#use Cv::Seq::Point;
#use Cv::Seq::Circle;
use Cv::Arr;
our @ISA = qw(Cv::Arr);

sub DESTROY {
}

sub Pop {
	my $self = CORE::shift;
	$self->cvSeqPop;
}

sub Push {
	my $self = CORE::shift;
	eval {
		$self->cvSeqPush($_) for @_;
	};
	if (my $err = $@) {
		chop($err);
		$err =~ s/\s*at .* line \d+\.//;
		croak $err;
	}
}

sub Shift {
	my $self = CORE::shift;
	$self->cvSeqShift;
}

sub Unshift {
	my $self = CORE::shift;
	$self->cvSeqUnshift($_) for @_;
}

1;
__END__
