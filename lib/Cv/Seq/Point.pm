# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq::Point;

use 5.008008;
use strict;
use warnings;
use Carp;

use Cv::MemStorage;
use Cv::Seq;
our @ISA = qw(Cv::Seq);

BEGIN {
	Cv::aliases(
		[ 'cvGetSeqElem', 'Get' ],
		);
}

sub new {
	my ($class, $flags, $stor) = @_;
	bless Cv::cvCreateSeq($flags, &Cv::Sizeof::CvSeq, &Cv::Sizeof::CvPoint, $stor);
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
