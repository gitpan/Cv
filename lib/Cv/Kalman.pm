# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Kalman;

use 5.008008;
use strict;
use warnings;

BEGIN {
	Cv::aliases(
		[ 'Cv::CreateKalman', 'new' ],
		[ 'cvKalmanCorrect', 'Correct' ],
		[ 'cvKalmanPredict', 'Predict' ],
		);
}

1;
__END__
