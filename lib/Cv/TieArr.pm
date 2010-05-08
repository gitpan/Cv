# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
package Cv::TieArr;

use lib qw(blib/lib blib/arch);

use 5.008000;
use strict;
use warnings;

use Tie::Array;
use Cv::Constant;
use Cv::CxCore qw(:all);
use Cv::Arr qw(:all);

use Cv::Arr::C1;
use Cv::Arr::C2;
use Cv::Arr::C3;
use Cv::Arr::C4;

our @ISA = qw(Tie::Array Cv::Arr);

our $VERSION = '0.03';

sub _arr_type {
	my $et = cvGetElemType($_[0]);
	my ($c, $t) = ((($et >> 3) & 3) + 1, $et & 7);
	"Cv::Arr::C$c";
}

sub TIEARRAY {
	if ($_[1]->height >= 2) {
		bless [ $_[1] ], $_[0];
	} else {
		_arr_type($_[1])->TIEARRAY([ $_[1], 0 ]);
	}
}

sub FETCH {
	my $self = shift;
	tie my @line, _arr_type($self->[0]), [ $self->[0], $_[0] ];
	\@line;
}

sub FETCHSIZE {
	(unpack("i2", cvGetSize($_[0]->[0])))[1];
}

1;
