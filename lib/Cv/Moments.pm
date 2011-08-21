# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Moments;

use 5.008000;
use strict;
use warnings;

BEGIN {
	Cv::aliases(
		[ 'cvGetSpatialMoment' ],
		[ 'cvGetCentralMoment' ],
		[ 'cvGetNormalizedCentralMoment' ],
		[ 'cvGetHuMoments' ],
		);
}

1;
__END__
