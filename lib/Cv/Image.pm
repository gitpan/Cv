# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Image;

use 5.008008;
use strict;
use warnings;
use Carp;

use Cv::Image::Ghost;
use Cv::Arr;
our @ISA = qw(Cv::Arr);

BEGIN {
	Cv::aliases(
		[ 'cvCloneImage', 'Clone' ],
		[ 'COI' ],
		[ 'cvGetImageCOI', 'GetCOI' ],
		[ 'cvGetImageROI', 'GetROI' ],
		[ 'Cv::LoadImage', 'Load' ],
		[ 'cvResetImageROI', 'ResetROI' ],
		[ 'ROI' ],
		[ 'cvSetImageCOI', 'SetCOI' ],
		[ 'cvSetImageROI', 'SetROI' ]
		);
}

sub new {
	my $self = shift;
	my $sizes = @_? shift : $self->sizes;
	my $type = @_? shift : $self->type;
	my ($channels, $depth) = (&Cv::MAT_CN($type), &Cv::IPL_DEPTH($type));
	croak "usage: Cv::Image->new(sizes, type)" unless defined $depth;
	my $image;
	if (@_) {
		my $data = shift;		# XXXXX
		$image = Cv::cvCreateImageHeader([reverse @$sizes], $depth, $channels);
	} else {
		$image = Cv::cvCreateImage([reverse @$sizes], $depth, $channels);
	}
	if (ref $self && $self->can('origin')) {
		$image->origin($self->origin);
		my $roi = $self->getImageROI;
		unless ($roi->[0] == 0 &&
				$roi->[1] == 0 &&
				$roi->[2] == $self->width &&
				$roi->[3] == $self->height) {
			$image->setImageROI($roi);
		}
	}
	$image;
}

sub COI {
	my $self = shift;
	my $coi = $self->cvGetImageCOI;
	$self->cvSetImageCOI(@_) if @_;
	$coi;
}

sub ROI {
	my $self = shift;
	my $roi = $self->cvGetImageROI;
	$self->cvSetImageROI(@_) if @_;
	$roi;
}

1;
__END__
