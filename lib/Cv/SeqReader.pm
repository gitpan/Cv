# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::SeqReader;

use 5.008008;
use strict;
use warnings;

use Cv::Seq;
our @ISA = qw(Cv::Seq);

BEGIN {
	Cv::aliases(
		[ 'cvReadSeqElem' ],
		[ 'cvNextSeqElem' ],
		);
}

1;
__END__
