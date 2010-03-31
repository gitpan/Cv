# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
package Cv::MemStorage;

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

# Preloaded methods go here.

sub new {
    my $class = shift;
	my %av = argv([ -block_size => 0 ], @_);
	bless cvCreateMemStorage($av{-block_size}), $class;
}

sub DESTROY {
	my $self = shift;
	cvReleaseMemStorage($self);
}

sub ClearMemStorage {
    my $self = shift;
	my %av = argv([ -storage => $self ], @_);
	cvClearMemStorage($av{-storage});
}


1;
