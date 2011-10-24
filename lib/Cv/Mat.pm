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
		[ 'cvDecodeImage' ],
		[ 'cvDecodeImageM' ],
		[ 'cvFindExtrinsicCameraParams2' ],
		[ 'cvInitUndistortMap' ],
		[ 'cvInitUndistortRectifyMap' ],
		[ 'Cv::LoadImageM', 'Load' ],
		[ 'cvStereoCalibrate' ],
		[ 'cvUndistortPoints' ],
		[ 'cvComputeCorrespondEpilines' ],
		);
}

use Data::Dumper;

sub new {
	my $self = shift;
	my $sizes = @_ && ref $_[0] eq 'ARRAY'? shift : $self->sizes;
	my $type = @_? shift : $self->type;
	if (@_) {
		my $mat = Cv::cvCreateMatHeader(@$sizes, $type);
		$mat->setData($_[0], &Cv::MAT_CN($type) * $sizes->[1]) if $_[0];
		$mat;
	} else {
		Cv::cvCreateMat(@$sizes, $type);
	}
}

# double cvmGet(const CvMat* mat, int row, int col)
# void cvmSet(CvMat* mat, int row, int col, double value)
# void cvSolveCubic(const CvMat* coeffs, CvMat* roots)

1;
__END__
