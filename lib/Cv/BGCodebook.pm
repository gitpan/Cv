# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::BGCodebook;

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
	my $phys = cvCreateBGCodeBookModel();
	bless $phys, $class;
}

sub modMin {
	my $self = shift;
	my @r;
	if (@_ == 3) {
		@r = cvSetmodMin($self, @_);
	} else {
		@r = cvGetmodMin($self);
	}
	wantarray? @r : \@r;
}

sub modMax {
	my $self = shift;
	my @r;
	if (@_ == 3) {
		@r = cvSetmodMax($self, @_);
	} else {
		@r = cvGetmodMax($self);
	}
	wantarray? @r : \@r;
}

sub cbBounds {
	my $self = shift;
	my @r;
	if (@_ == 3) {
		@r = cvSetcbBounds($self, @_);
	} else {
		@r = cvGetcbBounds($self);
	}
	wantarray? @r : \@r;
	
}

sub t {
	my $self = shift;
	cvGett($self);
}

sub BGCodeBookUpdate {
	my $self = shift;
	my %av = &argv([ -image => undef,
					 -roi => [0, 0, 0, 0],
					 -mask => \0,
					 -model => $self,
					 ], @_);
	cvBGCodeBookUpdate($av{-model},
					   $av{-image},
					   pack("i4", cvRect($av{-roi})),
					   $av{-mask},
					   );
}

sub BGCodeBookClearStale {
	my $self = shift;
	my %av = &argv([ -staleThresh => undef,
					 -roi => [0, 0, 0, 0],
					 -mask => \0,
					 -model => $self,
					 ], @_);
	cvBGCodeBookClearStale($av{-model},
						   $av{-staleThresh},
						   pack("i4", cvRect($av{-roi})),
						   $av{-mask},
						   );
}

sub BGCodeBookDiff {
	my $self = shift;
	my %av = &argv([ -image => undef,
					 -fgmask => undef,
					 -roi => [0, 0, 0, 0],
					 -model => $self,
					 ], @_);
	cvBGCodeBookDiff($av{-model},
					 $av{-image},
					 $av{-fgmask},
					 pack("i4", cvRect($av{-roi})),
					 );
}

sub SegmentFGMask {
	my $self = shift;
	my %av = &argv([ -fgmask => undef,
					 -poly1Hull0 => 1,
					 -perimScale => 4.0,
					 -storage => \0,
					 -offset => [0, 0],
					 ], @_);
	cvSegmentFGMask($av{-fgmask},
					$av{-poly1Hull0},
					$av{-perimScale},
					$av{-storage},
					pack("i2", cvPoint($av{-offset})),
					);
}

sub DESTROY {
    my $self = shift;
}

1;
__END__
