# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
package Cv::Kalman;

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
use Cv::Mat::Ghost;

our $VERSION = '0.02';

# Preloaded methods go here.

sub new {
    my $class = shift;
    my %av = &argv([ -dynam_params => undef,
					 -measure_params => undef,
					 -control_params => \0,
				   ], @_);
	unless (defined $av{-dynam_params} &&
			defined $av{-measure_params} &&
			defined $av{-control_params}) {
		chop(my $usage = <<"----"
usage:	Cv::Kalman->new(
	-dynam_params => dimensionality of the state vector,
	-measure_params => dimensionality of the measurement vector,
	-control_params => dimensionality of the control vector,
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvCreateKalman(
		$av{-dynam_params},
		$av{-measure_params},
		$av{-control_params},
		), $class;
}

sub transition_matrix {
    my $self = shift;
	bless CvKalman_transition_matrix($self), 'Cv::Mat::Ghost';
}

sub measurement_matrix {
    my $self = shift;
	bless CvKalman_measurement_matrix($self), 'Cv::Mat::Ghost';
}

sub process_noise_cov {
    my $self = shift;
	bless CvKalman_process_noise_cov($self), 'Cv::Mat::Ghost';
}

sub measurement_noise_cov {
    my $self = shift;
	bless CvKalman_measurement_noise_cov($self), 'Cv::Mat::Ghost';
}

sub error_cov_pre {
    my $self = shift;
	bless CvKalman_error_cov_pre($self), 'Cv::Mat::Ghost';
}

sub error_cov_post {
    my $self = shift;
	bless CvKalman_error_cov_post($self), 'Cv::Mat::Ghost';
}

sub state_pre {
    my $self = shift;
	bless CvKalman_state_pre($self), 'Cv::Mat::Ghost';
}

sub state_post {
    my $self = shift;
	bless CvKalman_state_post($self), 'Cv::Mat::Ghost';
}

sub Predict {
    my $self = shift;
    my %av = &argv([ -control => \0,
					 -kalman => $self,
				   ], @_);
	unless (defined $av{-kalman}) {
		chop(my $usage = <<"----"
usage:	Cv::Kalman->Predict(
	-kalman => Kalman filter state. 
	-control => Control vector (uk), should be NULL if there is no external
	        control (control_params=0). 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvKalmanPredict($av{-kalman},	$av{-control}), 'Cv::Mat::Ghost';
}


sub Correct {
    my $self = shift;
    my %av = &argv([ -measurement => undef,
					 -kalman => $self,
				   ], @_);
	unless (defined $av{-kalman} &&
			defined $av{-measurement}) {
		chop(my $usage = <<"----"
usage:	Cv::Kalman->Correct(
	-kalman => Pointer to the structure to be updated. 
	-measurement => Pointer to the structure CvMat containing the
	        measurement vector. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvKalmanCorrect($av{-kalman},	$av{-measurement}), 'Cv::Mat::Ghost';
}


sub DESTROY {
    my $self = shift;
    cvReleaseKalman($self);
}

1;
