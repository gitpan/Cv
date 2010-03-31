# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
package Cv::Moments;

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

our $VERSION = '0.02';


# ======================================================================
#  1.7. Image and Contour moments
# ======================================================================

sub m00 { my $self = shift; $self->CvMoments_m00; }
sub m10 { my $self = shift; $self->CvMoments_m10; }
sub m01 { my $self = shift; $self->CvMoments_m01; }
sub m20 { my $self = shift; $self->CvMoments_m20; }
sub m11 { my $self = shift; $self->CvMoments_m11; }
sub m02 { my $self = shift; $self->CvMoments_m02; }
sub m30 { my $self = shift; $self->CvMoments_m30; }
sub m21 { my $self = shift; $self->CvMoments_m21; }
sub m12 { my $self = shift; $self->CvMoments_m12; }
sub m03 { my $self = shift; $self->CvMoments_m03; }
sub inv_sqrt_m00 { my $self = shift; $self->CvMoments_inv_sqrt_m00; }


# ------------------------------------------------------------
#  Moments - Calculates all moments up to third order of a polygon or
#          rasterized shape
# ------------------------------------------------------------
sub new {
	my $class = shift;
	my %av = &argv([ -arr => undef,
					 -binary => 0,
				   ], @_);
	unless (blessed $av{-arr} &&
			defined $av{-binary}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Moments->new(
	-arr => Image (1-channel or 3-channel with COI set) or polygon (CvSeq of
	        points or a vector of points). 
	-moments => Pointer to returned moment state structure. 
	-binary => (For images only) If the flag is non-zero, all the zero pixel
	        values are treated as zeroes, all the others are treated as 1\'s.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $coi = $av{-arr}->GetImageCOI;
	if ($av{-arr}->GetChannels != 1 && $coi == 0) {
		$av{-arr}->SetImageCOI(1);
	} else {
		$coi = undef;
	}
	my $moments = cvMoments($av{-arr}, $av{-binary});
	if (defined $coi) {
		$av{-arr}->SetImageCOI($coi);
	}
	if ($moments) {
		bless $moments, $class;
	} else {
		undef;
	}
}

sub DESTROY {
	my $self = shift;
	cvReleaseMoments($self);
}


# ------------------------------------------------------------
#  GetSpatialMoment - Retrieves spatial moment from moment state structure
# ------------------------------------------------------------
sub GetSpatialMoment {
	my $self = shift;
	my %av = &argv([ -x_order => undef,
					 -y_order => undef,
					 -moments => $self,
				   ], @_);
	if (defined $av{-order}) {
		($av{-x_order}, $av{-y_order}) = @{$av{-order}};
	}
	unless (blessed $av{-moments} &&
			defined $av{-x_order} &&
			defined $av{-y_order}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Moments->GetSpatialMoment(
	-moments => The moment state, calculated by cvMoments. 
	-x_order => x order of the retrieved moment, x_order >= 0. 
	-y_order => y order of the retrieved moment, y_order >= 0 and x_order +
	        y_order <= 3.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetSpatialMoment($av{-moments}, $av{-x_order}, $av{-y_order});
}

# ------------------------------------------------------------
# GetCentralMoment - Retrieves central moment from moment state structure
# ------------------------------------------------------------
sub GetCentralMoment {
	my $self = shift;
	my %av = &argv([ -x_order => undef,
					 -y_order => undef,
					 -moments => $self,
				   ], @_);
	if (defined $av{-order}) {
		($av{-x_order}, $av{-y_order}) = @{$av{-order}};
	}
	unless (blessed $av{-moments} &&
			defined $av{-x_order} &&
			defined $av{-y_order}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Moments->GetCentralMoment(
	-moments => Pointer to the moment state structure. 
	-x_order => x order of the retrieved moment, x_order >= 0. 
	-y_order => y order of the retrieved moment, y_order >= 0 and
	        x_order + y_order <= 3.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetCentralMoment($av{-moments}, $av{-x_order}, $av{-y_order});
}


# ------------------------------------------------------------
#  GetNormalizedCentralMoment - Retrieves normalized central moment
#          from moment state structure
# ------------------------------------------------------------
sub GetNormalizedCentralMoment {
	my $self = shift;
	my %av = &argv([ -x_order => undef,
					 -y_order => undef,
					 -moments => $self,
				   ], @_);
	if (defined $av{-order}) {
		($av{-x_order}, $av{-y_order}) = @{$av{-order}};
	}
	unless (blessed $av{-moments} &&
			defined $av{-x_order} &&
			defined $av{-y_order}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Moments->GetCentralMoment(
	-moments => Pointer to the moment state structure. 
	-x_order => x order of the retrieved moment, x_order >= 0. 
	-y_order => y order of the retrieved moment, y_order >= 0 and
	        x_order + y_order <= 3.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetNormalizedCentralMoment($av{-moments}, $av{-x_order}, $av{-y_order});
}


# ------------------------------------------------------------
#  GetHuMoments - Calculates seven Hu invariants
# ------------------------------------------------------------
sub GetHuMoments {
	my $self = shift;
	my %av = &argv([ -moments => $self,
				   ], @_);
	unless (blessed $av{-moments}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Moments->GetCentralMoment(
	-moments => Pointer to the moment state structure. 
	-hu_moments => Pointer to Hu moments structure.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $hu_moments = cvGetHuMoments($av{-moments});
	if ($hu_moments) {
		use Cv::HuMoments;
		bless $hu_moments, 'Cv::HuMoments';
	} else {
		undef;
	}
}


1;
__END__
