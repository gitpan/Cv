# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::RNG;

use 5.008008;
use strict;
use warnings;

BEGIN {
	Cv::aliases(
		[ 'cvRandReal', 'Real' ],
		[ 'cvRandArr', 'Arr' ],
		[ 'cvRandInt', 'Int' ],
		);
}

sub new {
	my $class = shift;
	Cv::cvRNG(@_);
}

1;
__END__
