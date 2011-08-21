# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Set;

use 5.008008;
use strict;
use warnings;

BEGIN {
	Cv::aliases(
		[ 'Cv::CreateSet', 'new' ],
		);
}

use Cv::Seq;
our @ISA = qw(Cv::Seq);

1;
__END__
