# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Arr::Cx;

use 5.008000;
use strict;
use warnings;

use Tie::Array;
use Cv::Constant;
use Cv::CxCore qw(:all);
use Cv::Arr qw(:all);

our @ISA = qw(Tie::Array Cv::Arr);

our $VERSION = '0.03';

sub TIEARRAY {
	bless $_[1], $_[0];
}

=pod
sub FETCH {
	[ unpack("d1", cvGet2D(@{$_[0]}, $_[1])) ];
}
=cut

sub FETCHSIZE {
	(unpack("i2", cvGetSize($_[0]->[0])))[0];
}

sub STORE {
	my $self = shift; my $index = shift;
	for (@_) {
		if (ref $_) {
			cvSet2D(@$self, $index++, pack("d4", @$_));
		} else {
			cvSet2D(@$self, $index++, pack("d4", $_, 0, 0, 0));
		}
	}
}

1;
