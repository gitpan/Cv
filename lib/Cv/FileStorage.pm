# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::FileStorage;

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

sub new {
    my $class = shift;
	my %av = &argv([ -filename => 0,
					 -flags => undef,
					 -memstorage => \0,
				   ], @_);
	my $fs = cvOpenFileStorage($av{-filename}, $av{-memstorage}, $av{-flags});
	bless $fs, $class;
}

sub DESTROY {
	my $self = shift;
	cvReleaseFileStorage($self);
}

sub Write {
	my $self = shift;
	my %av = &argv([ -name => undef,
					 -ptr => \0,
					 -attributes => cvAttrList(\0, \0),
					 -fs => $self,
				   ], @_);
	cvWrite($av{-fs}, $av{-name}, $av{-ptr}, $av{-attributes});
}

sub Read {
	my $self = shift;
	my %av = &argv([ -node => undef,
					 -attributes => \0,
					 -fs => $self,
				   ], @_);
	cvRead($av{-fs}, $av{-node}, $av{-attributes});
}

sub GetFileNodeByName {
	my $self = shift;
	my %av = &argv([ -name => undef,
					 -map => \0,
					 -fs => $self,
				   ], @_);
	cvGetFileNodeByName($av{-fs}, $av{-map}, $av{-name});
}

1;
