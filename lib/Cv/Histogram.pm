# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Histogram;

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

our $VERSION = '0.03';

# Preloaded methods go here.


# ======================================================================
#  1.9. Histograms
# ======================================================================

# ------------------------------------------------------------
#  CvHistogram - Multi-dimensional histogram
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CreateHist - Creates histogram
# ------------------------------------------------------------
sub new {
    my $class = shift;
	my %av = argv([ -dims => undef,
					-sizes => undef,
					-type => undef,
					-ranges => \0,
					-uniform => 1,
				  ], @_);

	unless (defined($av{-sizes}) && defined($av{-type})) {
		chop(my $usage = <<"----"
usage:	Cv->CreateHist(
	-dims => Number of histogram dimensions.
	-sizes => Array of histogram dimension sizes.
	-type => Histogram representation format: CV_HIST_ARRAY means that
	        histogram data is represented as an multi-dimensional
	        dense array CvMatND; CV_HIST_SPARSE means that histogram
	        data is represented as a multi-dimensional sparse array
	        CvSparseMat. 
	-ranges => Array of ranges for histogram bins. Its meaning depends
	        on the uniform parameter value. The ranges are used for
	        when histogram is calculated or back-projected to
	        determine, which histogram bin corresponds to which
	        value/tuple of values from the input image[s]. 
	-uniform => Uniformity flag; if not 0, the histogram has evenly
	        spaced bins and for every 0<=i<cDims ranges[i] is array of
	        two numbers: lower and upper boundaries for the i-th
	        histogram dimension. The whole range [lower,upper] is
	        split then into dims[i] equal parts to determine i-th
	        input tuple value ranges for every histogram bin. And if
	        uniform=0, then i-th element of ranges array contains
	        dims[i]+1 elements: lower0, upper0, lower1, upper1 ==
	        lower2, ..., upperdims[i]-1, where lowerj and upperj are
	        lower and upper boundaries of i-th input tuple value for
	        j-th bin, respectively. In either case, the input values
	        that are beyond the specified range for a histogram bin,
	        are not counted by cvCalcHist and filled with 0 by
	        cvCalcBackProject. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	$av{-dims} ||= scalar @{$av{-sizes}};
	my $hist = cvCreateHist( $av{-dims}, $av{-sizes}, $av{-type},
							 $av{-ranges}, $av{-uniform} );
	bless $hist, $class;
}

# ------------------------------------------------------------
#  ReleaseHist - Releases histogram
# ------------------------------------------------------------
sub DESTROY {
	my $self = shift;
	$self->ReleaseHist;
}

sub ReleaseHist {
	my $self = shift;
	cvReleaseHist($self);
}

# ------------------------------------------------------------
#  SetHistBinRanges - Sets bounds of histogram bins
# ------------------------------------------------------------


# ------------------------------------------------------------
#  ClearHist - Clears histogram
# ------------------------------------------------------------
sub ClearHist {
	my $self = shift;
	cvClearHist($self);
}

sub Clear { ClearHist(@_) }

# ------------------------------------------------------------
#  MakeHistHeaderForArray - Makes a histogram out of array
# ------------------------------------------------------------


# ------------------------------------------------------------
#  QueryHistValue_*D - Queries value of histogram bin
# ------------------------------------------------------------
sub QueryHistValue {
	my $self = shift;
	my %av = &argv([ -idx => undef,
					 -hist => $self,
				   ], @_);
	unless (defined $av{-hist} &&
			(defined $av{-idx} || defined $av{-idx0} ||
			 defined $av{-idx1} || defined $av{-idx2} )
			) {
		chop(my $usage = <<"----"
usage:	Cv::Histogram->QueryHistValue(
	-idx0 => Indices of the bin
	-idx1 => Indices of the bin
	-idx2 => Indices of the bin
	-idx => Array of indices.
	-hist => Histogram, (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my @idx = &cvIndex(%av);
	if    (@idx == 1) { cvQueryHistValue_1D($av{-hist}, @idx); }
	elsif (@idx == 2) { cvQueryHistValue_2D($av{-hist}, @idx); }
	elsif (@idx == 3) { cvQueryHistValue_3D($av{-hist}, @idx); }
	else { goto usage; }
}


# ------------------------------------------------------------
#  GetHistValue_*D - Returns pointer to histogram bin
# ------------------------------------------------------------


# ------------------------------------------------------------
#  GetMinMaxHistValue - Finds minimum and maximum histogram bins
# ------------------------------------------------------------
sub GetMinMaxHistValue {
	my $self = shift;
	cvGetMinMaxHistValue($self);
}


# ------------------------------------------------------------
#  NormalizeHist - Normalizes histogram
# ------------------------------------------------------------
sub NormalizeHist {
	my $self = shift;
	my %av = argv([ -factor => undef,
					-hist => $self,
				  ], @_);

	unless (blessed($av{-hist}) && defined($av{-factor})) {
		chop(my $usage = <<"----"
usage:	Cv::Histgram->NormalizeHist(
	-hist => Pointer to the histogram. 
	-factor => Normalization factor. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvNormalizeHist($av{-hist}, $av{-factor});
	$av{-hist};
}

sub Normalize { NormalizeHist(@_) }

# ------------------------------------------------------------
#  ThreshHist - Thresholds histogram
# ------------------------------------------------------------
sub ThreshHist {
	my $self = shift;
	my %av = argv([ -threshold => undef,
					-hist => $self,
				  ], @_);

	unless (blessed($av{-hist}) && defined($av{-threshold})) {
		chop(my $usage = <<"----"
usage:	Cv->ThreshHist(
    -threshold => Threshold level.
    -hist => Pointer to the histogram.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvThreshHist($av{-hist}, $av{-threshold});
	$av{-hist};
}

sub Thresh { ThreshHist(@_) }

# ------------------------------------------------------------
#  CompareHist - Compares two dense histograms
# ------------------------------------------------------------
sub CompareHist {
	my $self = shift;
	my %av = argv([	-hist2 => undef,
					-method => undef,
					-hist1 => $self,
				  ], @_);

	unless (blessed($av{-hist1}) &&
			blessed($av{-hist2}) &&
			defined($av{-method})) {
		chop(my $usage = <<"----"
usage:	Cv::Histgram->CompareHist(
	-hist1 => The first dense histogram. 
	-hist2 => The second dense histogram. 
	-method => Comparison method, one of:
	        CV_COMP_CORREL
	        CV_COMP_CHISQR
	        CV_COMP_INTERSECT
	        CV_COMP_BHATTACHARYYA 
	Note: the method CV_COMP_BHATTACHARYYA only works with normalized
	histograms
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCompareHist(
		$av{-hist1},
		$av{-hist2},
		$av{-method},
		);
}

sub Compare { CompareHist(@_) }

# ------------------------------------------------------------
#  CopyHist - Copies histogram
# ------------------------------------------------------------
sub CopyHist {
	my $self = shift;
	my %av = argv([ -dst => \0,
					-src => $self,
				  ], @_);

	unless (defined($av{-src}) && defined($av{-dst})) {
		chop(my $usage = <<"----"
usage:	Cv->CopyHist(
    -dst => Pointer to destination histogram.
    -src => Source histogram.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCopyHist( $av{-src}, $av{-dst});
 	bless $av{-dst}, blessed $av{-src} unless (blessed $av{-dst});
	$av{-dst};
}

sub Copy { CopyHist(@_) }

# ------------------------------------------------------------
#  CalcHist - Calculates histogram of image(s)
# ------------------------------------------------------------
sub CalcHist {
	my $self = shift;
	my %av = argv([ -images => undef,
					-hist => $self,
					-accumulate => 0,
					-mask => \0,
				  ], @_);

	unless (defined($av{-images})) {
		chop(my $usage = <<"----"
usage:	Cv->CalcHist(
	-images => Source images (though, you may pass CvMat** as well),
	        all are of the same size and type.
    -hist => Pointer to the histogram.
    -accumulate => Accumulation flag. If it is set, the histogram is
	        not cleared in the beginning. This feature allows user to
	        compute a single histogram from several images, or to update
	        the histogram online. 
    -mask => The operation mask, determines what pixels of the source
	        images are counted.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	cvCalcHist( \@{$av{-images}},
				$av{-hist},
				$av{-accumulate},
				$av{-mask});
	$av{-hist};
}

sub Calc { CalcHist(@_) }

# ------------------------------------------------------------
#  CalcBackProject - Calculates back projection
# ------------------------------------------------------------
sub CalcBackProject {
	my $self = shift;
	my %av = argv([ -images => undef,
					-back_project => undef,
					-hist => $self,
				  ], @_);
	unless (blessed($av{-hist}) && defined($av{-images})) {
		chop(my $usage = <<"----"
usage:  Cv->CalcBackProject(
        -images => image -- Source images (though you may pass CvMat** as well)
        -back_project => Destination back projection image of the same type as
                the source images
        -hist => Histogram
        )
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-back_project} ||= ${$av{-images}}[0]->new;
	cvCalcBackProject($av{-images}, $av{-back_project}, $av{-hist});
	$av{-back_project};
}

# ------------------------------------------------------------
#  CalcBackProjectPatch - Locates a template within image by histogram
#  comparison
# ------------------------------------------------------------
sub CalcBackProjectPatch {
	my $self = shift;
	my %av = argv([ -images => undef,
					-dst => undef,
					-patch_size => undef,
					-method => undef,
					-factor => undef,
					-hist => $self,
				  ], @_);
	unless (blessed($av{-hist}) && 
			defined($av{-images}) && 
			defined($av{-dst}) && 
			defined($av{-patch_size})
		) {
		chop(my $usage = <<"----"
usage:  Cv->CalcBackProjectPatch(
	-images => Source images (though, you may pass CvMat** as well)
	-dst => Destination image.
	-patch_size => Size of the patch slid though the source image.
	-method => Compasion method, passed to CompareHist
	           (see description of that function).
	-factor => Normalization factor for histograms, will affect the
               normalization scale of the destination image, pass 1 if unsure.
	-hist => Histogram
        )
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	my $image = ${$av{-images}}[0];
	my $SZ = $image->GetSize;
	my $sz = cvSize($av{-patch_size});
	$av{-dst} ||= $image->new(
		-size => [ $SZ->[0] - $sz->[0] + 1, $SZ->[1] - $sz->[1] + 1 ],
		-depth => &IPL_DEPTH_32F,
		-channels => 1,
		);
	cvCalcBackProjectPatch(
		$av{-images},
		$av{-dst},
		$av{-hist},
		pack("i2", cvSize($av{-patch_size})),
		$av{-method} || &CV_COMP_CORREL,
		$av{factor} || 1,
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  CalcProbDensity - Divides one histogram by another
# ------------------------------------------------------------


# ------------------------------------------------------------
#  EqualizeHist - Equalizes histogram of grayscale image
#  (see Cv::Histogram)
# ------------------------------------------------------------


# ------------------------------------------------------------
#  CalcPGH - Calculates pair-wise geometrical histogram for contour
# ------------------------------------------------------------
sub CalcPGH {
	my $self = shift;
	my %av = &argv([ -contour => undef,
					 -hist => $self,
				   ], @_);
	cvCalcPGH(
		$av{-contour},
		$av{-hist},
		);
	$self;
}


# ------------------------------------------------------------
#  ScaleHist - Converts one hist to another with optional linear transformation
# ------------------------------------------------------------
sub ScaleHist {
	my $self = shift;
	my %av = argv([ -src => $self,
					-dst => undef,
					-scale => 1,
					-shift => 0,
				  ], @_);

	unless (defined $av{-src}) {
		chop(my $usage = <<"----"
usage:	Cv->Scale(
	-src => Source histograms.
	-dst => Destination histograms.
	-scale => Scale factor. 
	-shift => Value added to the scaled source array elements.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->Copy;

 	cvScaleHist($av{-src}, $av{-dst}, $av{-scale}, $av{-shift});
 	$av{-dst};
}

sub Scale { ScaleHist(@_) }

1;
