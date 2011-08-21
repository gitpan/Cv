# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Mat;

use 5.008008;
use strict;
use warnings;

use Cv::Mat::Ghost;
use Cv::Arr;
our @ISA = qw(Cv::Arr);

BEGIN {
	Cv::aliases(
		[ 'cvCloneMat', 'Clone' ],
		[ 'cvCalibrateCamera2' ],
		[ 'cvFindExtrinsicCameraParams2' ],
		[ 'cvInitUndistortMap' ],
		[ 'cvInitUndistortRectifyMap' ],
		[ 'Cv::LoadImageM', 'Load' ],
		[ 'cvStereoCalibrate' ],
		[ 'cvUndistortPoints' ],
		[ 'cvComputeCorrespondEpilines' ],
		);
}


sub new {
	my $self = shift;
	my $sizes = @_? shift : $self->sizes;
	my $type = @_? shift : $self->type;
	if (@_) {
		my $data = shift;
		Cv::cvCreateMatHeader(@$sizes, $type);
	} else {
		Cv::cvCreateMat(@$sizes, $type);
	}
}

# double cvmGet(const CvMat* mat, int row, int col)
# void cvmSet(CvMat* mat, int row, int col, double value)
# void cvSolveCubic(const CvMat* coeffs, CvMat* roots)

1;
__END__
