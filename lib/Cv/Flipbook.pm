# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Flipbook;

use 5.008008;
use strict;
use warnings;

use File::Basename;

BEGIN {
	Cv::aliases(
		[ 'GrabFrame', 'Grab' ],
		[ 'QueryFrame', 'Query' ],
		[ 'RetrieveFrame', 'Retrieve' ],
		[ 'SetProperty' ],
		[ 'GetProperty' ],
		);
}

sub new {
    my $class = shift;
	my $dir = shift;
	my $flags = shift || &Cv::CV_LOAD_IMAGE_COLOR;
	my $pattern = shift || [
		"*.bmp", "*.BMP", "*.jpg", "*.JPG", "*.png", "*.PNG",
		];
	my $self;
	if (-d $dir) {
		if (my $list = list($dir, $pattern)) {
			$self = bless {
				dir => $dir,
				files => $list,
				flags => $flags,
				pattern => $pattern,
			}, $class;
			$self->{&Cv::CV_CAP_PROP_POS_FRAMES} = 0;
			$self->{&Cv::CV_CAP_PROP_FPS} = 0;
			$self->{&Cv::CV_CAP_PROP_POS_MSEC} = 0;
		}
	}
	$self;
}

sub list { 
	my $dir = shift;
	my @files = ();
	foreach (@_) {
		if (ref $_) {
			push(@files, list($dir, @{$_}));
		} else {
			push(@files, map { $_->[0] } sort { $a->[1] <=> $b->[1] } map {
				basename($_) =~ /\d+/; [ $_, $& ];
				 } glob("$dir/$_"));
		}
	}
	wantarray ? @files : \@files;
}

sub DESTROY {
}

sub GrabFrame {
	my $self = shift;
	my $i = $self->{&Cv::CV_CAP_PROP_POS_FRAMES};
	if ($i >= 0 && $i < @{$self->{files}}) {
		$self->{file} = ${$self->{files}}[$i];
	} else {
		$self->{file} = undef;
	}
}

sub NextFrame {
	my $self = shift;
	$self->{&Cv::CV_CAP_PROP_POS_FRAMES}++;
}

sub PrevFrame {
	my $self = shift;
	$self->{&Cv::CV_CAP_PROP_POS_FRAMES}--;
}

sub RetrieveFrame {
	my $self = shift;
	if ($self->{file}) {
		if (my $image = Cv->LoadImage($self->{file}, $self->{flags})) {
			$self->NextFrame;
			if ($self->{&Cv::CV_CAP_PROP_FPS}) {
				$self->{&Cv::CV_CAP_PROP_POS_MSEC} =
					$self->{&Cv::CV_CAP_PROP_POS_FRAMES} / $self->{&Cv::CV_CAP_PROP_FPS};
			}
			return $image;
		}
	}
	undef;
}

sub QueryFrame {
	my $self = shift;
	$self->GrabFrame &&	$self->RetrieveFrame;
}

sub GetProperty {
	my $self = shift;
	my $property = shift;
	$self->{$property};
}

sub SetProperty {
	my $self = shift;
	my $property = shift;
	my $value = shift;
	$self->{$property} = $value;
}

1;
