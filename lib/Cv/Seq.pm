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

use Cv::Seq::Point;
use Cv::Arr;
our @ISA = qw(Cv::Arr);

sub DESTROY {
}

1;
__END__
