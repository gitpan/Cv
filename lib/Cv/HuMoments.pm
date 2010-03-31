# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
package Cv::HuMoments;

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


sub hu1 { my $self = shift; $self->CvHuMoments_hu1; }
sub hu2 { my $self = shift; $self->CvHuMoments_hu2; }
sub hu3 { my $self = shift; $self->CvHuMoments_hu3; }
sub hu4 { my $self = shift; $self->CvHuMoments_hu4; }
sub hu5 { my $self = shift; $self->CvHuMoments_hu5; }
sub hu6 { my $self = shift; $self->CvHuMoments_hu6; }
sub hu7 { my $self = shift; $self->CvHuMoments_hu7; }

sub DESTROY {
	my $self = shift;
	cvReleaseHuMoments($self);
}


1;
__END__
