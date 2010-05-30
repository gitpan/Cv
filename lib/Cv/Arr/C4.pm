# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Arr::C4;

use 5.008000;
use strict;
use warnings;

use Cv::Constant;
use Cv::CxCore qw(:all);
use Cv::Arr::Cx;

our @ISA = qw(Cv::Arr::Cx);

our $VERSION = '0.04';

sub FETCH {
	[ unpack("d4", cvGet2D(@{$_[0]}, $_[1])) ];
}

1;
