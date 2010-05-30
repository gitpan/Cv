# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::StereoBMState;

use 5.008000;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);
use Data::Dumper;

BEGIN {
	$Data::Dumper::Terse = 1;
}

use Cv::Constant;
use Cv::CxCore qw(:all);

our $VERSION = '0.04';


# ------------------------------------------------------------
#  CvStereoBMState - The structure for block matching stereo
#  correspondence algorithm
# ------------------------------------------------------------
sub get_preFilterType       { CvStereoBMState_get_preFilterType(@_); }
sub GetPreFilterType        { CvStereoBMState_get_preFilterType(@_); }
sub set_preFilterType       { CvStereoBMState_set_preFilterType(@_); }
sub SetPreFilterType        { CvStereoBMState_set_preFilterType(@_); }
sub get_preFilterSize       { CvStereoBMState_get_preFilterSize(@_); }
sub GetPreFilterSize        { CvStereoBMState_get_preFilterSize(@_); }
sub set_preFilterSize       { CvStereoBMState_set_preFilterSize(@_); }
sub SetPreFilterSize        { CvStereoBMState_set_preFilterSize(@_); }
sub get_preFilterCap        { CvStereoBMState_get_preFilterCap(@_); }
sub GetPreFilterCap         { CvStereoBMState_get_preFilterCap(@_); }
sub set_preFilterCap        { CvStereoBMState_set_preFilterCap(@_); }
sub SetPreFilterCap         { CvStereoBMState_set_preFilterCap(@_); }
sub get_SADWindowSize       { CvStereoBMState_get_SADWindowSize(@_); }
sub GetSADWindowSize        { CvStereoBMState_get_SADWindowSize(@_); }
sub set_SADWindowSize       { CvStereoBMState_set_SADWindowSize(@_); }
sub SetSADWindowSize        { CvStereoBMState_set_SADWindowSize(@_); }
sub get_minDisparity        { CvStereoBMState_get_minDisparity(@_); }
sub GetMinDisparity         { CvStereoBMState_get_minDisparity(@_); }
sub set_minDisparity        { CvStereoBMState_set_minDisparity(@_); }
sub SetMinDisparity         { CvStereoBMState_set_minDisparity(@_); }
sub get_numberOfDisparities { CvStereoBMState_get_numberOfDisparities(@_); }
sub GetNumberOfDisparities  { CvStereoBMState_get_numberOfDisparities(@_); }
sub set_numberOfDisparities { CvStereoBMState_set_numberOfDisparities(@_); }
sub SetNumberOfDisparities  { CvStereoBMState_set_numberOfDisparities(@_); }
sub get_textureThreshold    { CvStereoBMState_get_textureThreshold(@_); }
sub GetTextureThreshold     { CvStereoBMState_get_textureThreshold(@_); }
sub set_textureThreshold    { CvStereoBMState_set_textureThreshold(@_); }
sub SetTextureThreshold     { CvStereoBMState_set_textureThreshold(@_); }
sub get_uniquenessRatio     { CvStereoBMState_get_uniquenessRatio(@_); }
sub GetUniquenessRatio      { CvStereoBMState_get_uniquenessRatio(@_); }
sub set_uniquenessRatio     { CvStereoBMState_set_uniquenessRatio(@_); }
sub SetUniquenessRatio      { CvStereoBMState_set_uniquenessRatio(@_); }
sub get_speckleWindowSize   { CvStereoBMState_get_speckleWindowSize(@_); }
sub GetSpeckleWindowSize    { CvStereoBMState_get_speckleWindowSize(@_); }
sub set_speckleWindowSize   { CvStereoBMState_set_speckleWindowSize(@_); }
sub SetSpeckleWindowSize    { CvStereoBMState_set_speckleWindowSize(@_); }
sub get_speckleRange        { CvStereoBMState_get_speckleRange(@_); }
sub GetSpeckleRange         { CvStereoBMState_get_speckleRange(@_); }
sub set_speckleRange        { CvStereoBMState_set_speckleRange(@_); }
sub SetSpeckleRange         { CvStereoBMState_set_speckleRange(@_); }
sub get_preFilteredImg0     { CvStereoBMState_get_preFilteredImg0(@_); }
sub GetPreFilteredImg0      { CvStereoBMState_get_preFilteredImg0(@_); }
sub set_preFilteredImg0     { CvStereoBMState_set_preFilteredImg0(@_); }
sub SetPreFilteredImg0      { CvStereoBMState_set_preFilteredImg0(@_); }
sub get_preFilteredImg1     { CvStereoBMState_get_preFilteredImg1(@_); }
sub GetPreFilteredImg1      { CvStereoBMState_get_preFilteredImg1(@_); }
sub set_preFilteredImg1     { CvStereoBMState_set_preFilteredImg1(@_); }
sub SetPreFilteredImg1      { CvStereoBMState_set_preFilteredImg1(@_); }
sub get_slidingSumBuf       { CvStereoBMState_get_slidingSumBuf(@_); }
sub GetSlidingSumBuf        { CvStereoBMState_get_slidingSumBuf(@_); }
sub set_slidingSumBuf       { CvStereoBMState_set_slidingSumBuf(@_); }
sub SetSlidingSumBuf        { CvStereoBMState_set_slidingSumBuf(@_); }

# ------------------------------------------------------------
#  CreateStereoBMState - Creates block matching stereo correspondence
#          structure
# ------------------------------------------------------------
sub new {
	my $class = shift;
	my %av = &argv([ -preset => CV_STEREO_BM_BASIC,
					 -numberOfDisparities => 0,
				   ], @_);
	unless (defined $av{-preset} &&
			defined $av{-numberOfDisparities}) {
		chop(my $usage = <<"----"
usage:	Cv->CreateStereoBMState(
	-preset => ID of one of the pre-defined parameter sets. Any of the
	        parameters can be overridden after creating the structure. 
	-numberOfDisparities => The number of disparities. If the parameter is
	        0, it is taken from the preset, otherwise the supplied value
	        overrides the one from preset.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvCreateStereoBMState(
		$av{-preset},
		$av{-numberOfDisparities},
		), $class;
}


# ------------------------------------------------------------
#  ReleaseStereoBMState - Releases block matching stereo
#          correspondence structure
# ------------------------------------------------------------
sub DESTROY {
	my $self = shift;
	cvReleaseStereoBMState($self);
}


# ------------------------------------------------------------
#  FindStereoCorrespondenceBM - Computes the disparity map using block
#          matching algorithm
# ------------------------------------------------------------
sub FindStereoCorrespondenceBM {
	my $self = shift;
	my %av = &argv([ -left => undef,
					 -right => undef,
					 -disparity => undef,
					 -state => $self,
				   ], @_);
	$av{-disparity} ||= $av{-left}->new(-depth => &IPL_DEPTH_16S);
	unless (blessed $av{-left} &&
			blessed $av{-right} &&
			blessed $av{-disparity} &&
			blessed $av{-state}) {
		chop(my $usage = <<"----"
usage:	Cv->FindStereoCorrespondenceBM(
	-left => The left single-channel, 8-bit image. 
	-right => The right image of the same size and the same type. 
	-disparity The output single-channel 16-bit signed disparity map of the
	        same size as input images. Its elements will be the computed
	        disparities, multiplied by 16 and rounded to integer\'s. 
	-state => Stereo correspondence structure.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvFindStereoCorrespondenceBM(
		$av{-left},
		$av{-right},
		$av{-disparity},
		$av{-state},
		);
	$av{-disparity};
}


1;
__END__
