# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::MemStorage;

use 5.008008;
use strict;
use warnings;

BEGIN {
	Cv::aliases(
		[ 'Cv::CreateMemStorage', 'new' ],
		[ 'cvMemStorageAlloc' ],
		[ 'AllocString' ],
		[ 'cvClearMemStorage' ],
		[ 'cvCreateChildMemStorage' ],
		[ 'cvReleaseMemStorage' ],
		[ 'cvRestoreMemStoragePos' ],
		[ 'cvSaveMemStoragePos' ],
		);
}

use Cv::ChildMemStorage;

sub AllocString {
	# AllocString($stor, $ptr)
	# AllocString($stor, $ptr, $len)
	my ($stor, $ptr) = splice(@_, 0, 2);
	my $len = shift || length($ptr);
	cvMemStorageAllocString($stor, $ptr, $len);
}

1;
__END__
