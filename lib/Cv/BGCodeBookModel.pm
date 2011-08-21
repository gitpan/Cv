# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::BGCodeBookModel;

use 5.008000;
use strict;
use warnings;

BEGIN {
	Cv::aliases(
		[ 'Cv::CreateBGCodeBookModel', 'new' ],
		[ 'cvBGCodeBookUpdate', 'Update' ],
		[ 'cvBGCodeBookClearStale', 'ClearStale' ],
		[ 'cvBGCodeBookDiff', 'Diff' ],
		);
}

1;
__END__
