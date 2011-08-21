# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Capture;

use 5.008008;
use strict;
use warnings;

BEGIN {
	Cv::aliases(
		[ 'Cv::CaptureFromCAM', 'FromCAM' ],
		[ 'Cv::CaptureFromFile', 'FromFile' ],
		[ 'Cv::CaptureFromFlipbook', 'FromFlipbook' ],
		[ 'cvGetCaptureProperty', 'GetProperty' ],
		[ 'cvGrabFrame', 'Grab' ],
		[ 'cvQueryFrame', 'Query' ],
		[ 'cvRetrieveFrame', 'Retrieve' ],
		[ 'cvSetCaptureProperty', 'SetProperty' ],
		);
}

1;
__END__
