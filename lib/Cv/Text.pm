# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Text;

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

our $VERSION = '0.04';

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
	if (defined($av{-scale})) {
		$av{-hscale} = $av{-vscale} = $av{-scale};
	}
	$av{-hscale} ||= 1.0;
	$av{-vscale} ||= 1.0;
	unless (defined $av{-font_face} &&
			# defined $av{-hscale} &&
			# defined $av{-vscale} &&
			defined $av{-shear} &&
			defined $av{-thickness} &&
			defined $av{-line_type}) {
		chop(my $usage = <<"----"
usage:	Cv->InitFont(
	-font => Pointer to the font structure initialized by the function. 
	-font_face => Font name identifier. Only a subset of Hershey fonts
	        (http://sources.isc.org/utils/misc/hershey-font.txt) are
	        supported now:
	          * CV_FONT_HERSHEY_SIMPLEX - normal size sans-serif font
	          * CV_FONT_HERSHEY_PLAIN - small size sans-serif font
	          * CV_FONT_HERSHEY_DUPLEX - normal size sans-serif font
	            (more complex than CV_FONT_HERSHEY_SIMPLEX)
	          * CV_FONT_HERSHEY_COMPLEX - normal size serif font
	          * CV_FONT_HERSHEY_TRIPLEX - normal size serif font
	            (more complex than CV_FONT_HERSHEY_COMPLEX)
	          * CV_FONT_HERSHEY_COMPLEX_SMALL - smaller version of
	            CV_FONT_HERSHEY_COMPLEX
	          * CV_FONT_HERSHEY_SCRIPT_SIMPLEX - hand-writing style font
	          * CV_FONT_HERSHEY_SCRIPT_COMPLEX - more complex variant of
	            CV_FONT_HERSHEY_SCRIPT_SIMPLEX
	        The parameter can be composed from one of the values above and
	        optional CV_FONT_ITALIC flag, that means italic or oblique font. 
	-hscale => Horizontal scale. If equal to 1.0f, the characters have the
	        original width depending on the font type. If equal to 0.5f,
	        the characters are of half the original width. 
	-vscale => Vertical scale. If equal to 1.0f, the characters have the
	        original height depending on the font type. If equal to 0.5f,
	        the characters are of half the original height. 
	-shear => Approximate tangent of the character slope relative to the
	        vertical line. Zero value means a non-italic font, 1.0f means
	        ≈45° slope, etc. thickness Thickness of lines composing letters
	        outlines. The function cvLine is used for drawing letters. 
	-thickness => Thickness of the text strokes. 
	-line_type => Type of the strokes, see cvLine description.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $font = cvInitFont(
			$av{-font_face},
			$av{-hscale},
			$av{-vscale},
			$av{-shear},
			$av{-thickness},
			$av{-line_type},
		)) {
		bless $font, $class;
	} else {
		undef;
	}
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
