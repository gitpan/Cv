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
	$self->cvSeqPopFront;
}

sub Unshift {
	my $self = CORE::shift;
	$self->cvSeqPushFront($_) for @_;
}

sub Splice {
	# splice($array, $offset, $length, @list)
	# splice($array, $offset, $length)
	# splice($array, $offset)
	my $array = CORE::shift;
	my $offset = CORE::shift;
	my $length = @_? CORE::shift : $array->total - $offset;
	my @le = ();
	foreach (0 .. $offset - 1) {
		push(@le, $array->Shift);
	}
	my @ce = ();
	foreach (0 .. $length - 1) {
		push(@ce, $array->Shift);
	}
	$array->Unshift(@le, @_);
	wantarray? @ce : \@ce;
}

1;
__END__
