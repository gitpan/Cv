# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq::Circle;

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

1;
__END__
