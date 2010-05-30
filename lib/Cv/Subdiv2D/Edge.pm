# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Subdiv2D::Edge;

use 5.008000;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);
use Data::Dumper;

use Cv::Constant;
use Cv::CxCore qw(:all);

BEGIN {
	$Data::Dumper::Terse = 1;
}

our $VERSION = '0.04';

sub new {
    my $class = shift;
    my %av = &argv([ -edge => undef,
				   ], @_);
	bless $av{-edge}, $class;
}

sub eq {
    my $self = shift;
    ${$self} == ${$_[0]};
}

sub ne {
    my $self = shift;
    ${$self} != ${$_[0]};
}

# ------------------------------------------------------------
#  Subdiv2DEdgeOrg - Returns edge origin
# ------------------------------------------------------------
sub Org {
    my $self = shift;
    my %av = &argv([ -edge => $self,
				   ], @_);
	if (my $org = cvSubdiv2DEdgeOrg($av{-edge})) {
		my ($flags, $first, $x, $y) = unpack("i2f2", $org);
		my $pt = {
			'flags' => $flags,
			'first' => $first,
			'x' => $x,
			'y' => $y,
		};
	} else {
		undef;
	}
}

sub Dst {
    my $self = shift;
    my %av = &argv([ -edge => $self,
				   ], @_);
	if (my $dst = cvSubdiv2DEdgeDst($av{-edge})) {
		my ($flags, $first, $x, $y) = unpack("i2f2", $dst);
		my $pt = {
			'flags' => $flags,
			'first' => $first,
			'x' => $x,
			'y' => $y,
		};
	} else {
		undef;
	}
}

sub GetEdge {
    my $self = shift;
    my %av = &argv([ -type => undef,
					 -edge => $self,
				   ], @_);
	if (my $edge = cvSubdiv2DGetEdge($av{-edge}, $av{-type})) {
		bless $edge;
	} else {
		undef;
	}
}

# ------------------------------------------------------------
#  Subdiv2DRotateEdge - Returns another edge of the same quad-edge
# ------------------------------------------------------------
sub Rotate {
    my $self = shift;
    my %av = &argv([ -rotate => undef,
					 -edge => $self,
				   ], @_);
	if (my $edge = cvSubdiv2DRotateEdge($av{-edge}, $av{-rotate})) {
		bless $edge;
	} else {
		undef;
	}
}

sub DESTROY {
}


1;
__END__
