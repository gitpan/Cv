# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::ConvKernel;

use 5.008000;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);
use Data::Dumper;

use Cv::Constant;
use Cv::CxCore qw(:all);

our $VERSION = '0.04';

# Preloaded methods go here.

sub new {
	my $class = shift;
	my %av = argv([ -cols => 3,
					-rows => 3,
					-anchor_x => 1,
					-anchor_y => 1,
					-shape => &CV_SHAPE_ELLIPSE,
					-values => \0,
					], @_);
	my $elem = cvCreateStructuringElementEx(
		$av{-cols}, $av{-rows},
		$av{-anchor_x}, $av{-anchor_y},
		$av{-shape}, $av{-values},
		);
	bless $elem, $class;
}

sub DESTROY {
	my $self = shift;
	cvReleaseStructuringElement($self);
}

1;
