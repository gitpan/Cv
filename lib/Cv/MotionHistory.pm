# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::MotionHistory;

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
use Cv::Seq;

our @ISA = qw(Cv::Seq);

our $VERSION = '0.04';

# ------------------------------------------------------------
#  GetSeqElem - Returns pointer to sequence element by its index
# ------------------------------------------------------------
sub GetSeqElem {
	my $self = shift;
	my %av = &argv([ -index => 0,
					 -seq => $self,
				   ], @_);
	unless (defined $av{-index} &&
			blessed $av{-seq}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::MotionHistory->GetSeqElem(
	-index => Index of element.
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my ($area, $v0, $v1, $v2, $v3, $x, $y, $width, $height, $contour) =
		unpack("d d4 i4 P", $self->SUPER::GetSeqElem(-index => $av{-index}));
	my %ConnectedComp = (
		'area' => $area,
		'value' => [ $v0, $v1, $v2, $v3 ],
		'rect' => {
			'x' => $x,
			'y' => $y,
			'width' => $width,
			'height' => $height,
		},
		'contour' => $contour,
		);
	#print STDERR Data::Dumper->Dump([\%ConnectedComp], [qw(ConnectedComp)]);
	wantarray? %ConnectedComp : \%ConnectedComp;
}

# ------------------------------------------------------------
#  SegmentMotion - Segments whole motion into separate moving parts
# ------------------------------------------------------------
sub SegmentMotion {
	my $class = shift;
	my %av = &argv([ -mhi => undef,
					 -seg_mask => undef,
					 -storage => undef,
					 -timestamp => undef,
					 -seg_thresh => undef,
				   ], @_);
	# $av{-storage} ||= Cv::MemStorage->new;
	unless (defined($av{-mhi}) &&
			defined($av{-seg_mask}) &&
			defined($av{-storage}) &&
			defined $av{-timestamp} &&
			defined $av{-seg_thresh}) {
		chop(my $usage = <<"----"
usage:	Cv::MotionHistory->SegmentMotion(
	-mhi => Motion history image. 
	-seg_mask => Image where the mask found should be stored, single-
	        channel, 32-bit floating-point.
	-storage => Memory storage that will contain a sequence of motion
	        connected components.
	-timestamp => Current time in milliseconds or other units. 
	-seg_thresh => Segmentation threshold; recommended to be equal to the
	        interval between motion history \"steps\" or greater.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $seq = cvSegmentMotion(
		$av{-mhi},
		$av{-seg_mask},
		$av{-storage},
		$av{-timestamp},
		$av{-seg_thresh},
		);
	bless $seq, $class;
}

1;
__END__
