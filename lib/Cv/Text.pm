# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Text;
use lib qw(blib/lib blib/arch);

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

# ======================================================================
#  4.2. Text
# ======================================================================

# ------------------------------------------------------------
#  InitFont - Initializes font structure
# ------------------------------------------------------------
sub new {
	my $class = shift;
	my %av = argv([ -font_face => &CV_FONT_HERSHEY_PLAIN,
					-hscale => undef,
					-vscale => undef,
					-shear => 0,
					-thickness => 1,
					-line_type => 16,
				  ], @_);
	unless (defined($av{-hscale}) && defined($av{-vscale})) {
		$av{-hscale} = $av{-vscale} = $av{-scale} || 1.0;
	}
	my $font = cvInitFont(
		$av{-font_face},
		$av{-hscale},
		$av{-vscale},
		$av{-shear},
		$av{-thickness},
		$av{-line_type},
		);
	bless $font, $class;
}


sub DESTROY {
	my $self = shift;
	cvReleaseFont($self);
}


# ------------------------------------------------------------
#  PutText - Draws text string
# ------------------------------------------------------------
sub PutText {
	my $self = shift;
	my %av = &argv([ -img => undef,
					 -text => '',
					 -org => undef,
					 -font => $self,
					 -color => [ 255, 255, 255 ],
				   ], @_);
	my @color = cvScalar($av{-color});
	my ($x, $y) = cvPoint($av{-org});
	$av{-img} = $av{-image} unless (defined $av{-img});
	if ($av{-overstrike} || $av{-ov}) {
		cvPutText(
			$av{-img},
			$av{-text},
			pack("i2", $x + 1, $av{-img}->GetOrigin? $y - 1 : $y + 1),
			$av{-font},
			pack("d4", cvScalar(map { $_ / 4 } @color)),
			);
	}
	cvPutText(
		$av{-img},
		$av{-text},
		pack("i2", $x, $y),
		$av{-font},
		pack("d4", @color),
		);
	$self;
}


# ------------------------------------------------------------
#  GetTextSize - Retrieves width and height of text string
# ------------------------------------------------------------
sub GetTextSize {
	my $self = shift;
	my %av = &argv([ -text => '',
					 -font => $self,
				   ], @_);
	my $sz = cvGetTextSize(
		$av{-text},
		$av{-font},
		);
	if ($av{-overstrike} || $av{-ov}) {
		$sz->[0]++; $sz->[1]++;
	}
	wantarray? @$sz : $sz;
}

1;
