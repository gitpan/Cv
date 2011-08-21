#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Helper::Cv::Arr;

use 5.008008;
use strict;
use warnings;

BEGIN {
	*{Show} = \&ShowImage;
}

sub ShowImage {
	my $self = shift;
	my %av = (
		-name => undef,
		-image => $self,
		@_);
	@_ = ($av{-image}, $av{-name});
	goto &Cv::Arr::cvShowImage;
}

sub Smooth {
	my $self = shift;
	my %av = (
		-src => $self,
		-dst => undef,
		-smoothType => &Cv::CV_GAUSSIAN,
		-param1 => 3,
		-param2 => 0,
		-param3 => 0,
		-param4 => 0,
		@_);
	$av{-dst} ||= $av{-src}->new;
	@_ = ($av{-src}, $av{-dst}, $av{-smoothType},
		  $av{-param1}, $av{-param2}, $av{-param3}, $av{-param4});
	goto &Cv::Arr::cvSmooth;
}

package Cv::Helper::Cv::RNG;

use 5.008008;
use strict;
use warnings;

sub new {
	goto &Cv::Helper::Cv::RNG;
}

sub RandArr {
	my $self = shift;
	my %av = (
		-rng => $self,
		-arr => undef,
		-distType => undef,
		-param1 => undef,
		-param2 => undef,
		@_);
	@_ = ($av{-rng}, $av{-arr}, $av{-distType}, $av{-param1}, $av{-param2});
	goto &Cv::RNG::cvRandArr;
}

sub RandInt {
	my $self = shift;
	my %av = (
		-rng => -1,
		@_);
	@_ = ($av{-rng});
	goto &Cv::RNG::cvRandInt;
}

sub RandReal {
	my $self = shift;
	my %av = (
		-rng => -1,
		@_);
	@_ = ($av{-rng});
	goto &Cv::RNG::cvRandReal;
}

package Cv::Helper::Cv;

use 5.008008;
use strict;
use warnings;

sub CreateImage {
	my $self = shift;
	my %av = (
		-size => undef,
		-depth => undef,
		-channels => undef,
		@_);
	@_ = ($av{-size}, $av{-depth}, $av{-channels});
	goto &Cv::cvCreateImage;
}

sub LoadImage {
	my $self = shift;
	my %av = (
		-filename => undef,
		-iscolor => &Cv::CV_LOAD_IMAGE_COLOR,
		@_);
	# use Data::Dumper;
	# print STDERR Data::Dumper->Dump([\%av], [qw($av)]);
	@_ = ($av{-filename}, $av{-iscolor});
	goto &Cv::cvLoadImage;
}

sub RNG {
	my $self = shift;
	my %av = (
		-seed => -1,
		@_);
	@_ = ($av{-seed});
	goto &Cv::cvRNG;
}

package Cv::Helper;

use 5.008008;
use strict;
use warnings;

use lib qw(blib/lib blib/arch);
use Cv qw(:all);

sub alias {
	my $short = shift;
	my @packages = ();
	foreach (@_) {
		if ($_->can($short) || $_->can("cv$short")) {
			push(@packages, $_);
		}
	}
	return undef if scalar @packages == 0;

	my $alias = $short;
	my %subr = ();
	$subr{$alias} = $short;
	if ($alias =~ s/^[A-Z][a-z]+/\L$&/) {
		$subr{$alias} = $short;
	} elsif ($alias =~ s/^[A-Z]+$/\L$&/) {
		$subr{$alias} = $short;
	}

	foreach my $s (keys %subr) {
		foreach my $p (@packages) {
			no warnings;
			no strict 'refs';
			my $full = join('::', $p, $s);
			my $helper = join('::', "Cv::Helper::$p", $short);
			# print STDERR "*{$full} = \\&$helper\n";
			*{$full} = \&$helper;
		}
	}
}

our %EXPORT_TAGS = (
	'Cv'      => [ keys %Cv::Helper::Cv:: ],
	'Cv::Arr' => [ keys %Cv::Helper::Cv::Arr:: ],
	'Cv::RNG' => [ keys %Cv::Helper::Cv::RNG:: ],
	);

sub import {
	my $self = shift;
	foreach my $class (@_) {
		# print STDERR "alias($_, ...)\n";
		if (my $subr = $EXPORT_TAGS{$class}) {
			foreach (@$subr) {
				# print STDERR "alias($_, ...)\n";
				alias($_, $class);
			}
		}
	}
}

package main;

use strict;
use lib qw(blib/lib blib/arch);

use Cv;
use File::Basename;

Cv::Helper->import(qw(Cv Cv::RNG Cv::Arr));

my $imagename = shift || dirname($0) . "/lena.jpg";
my $img = Cv->loadImage(-filename => $imagename);

# check if the image has been loaded properly
die "$0: Can not load image $imagename" unless $img;

my $rng = Cv::RNG->new(-seed => -1);
my $noise = Cv->createImage(
	-size => $img->getSize, -depth => IPL_DEPTH_32F, -channels => 1,
	);
$rng->randArr(
	-arr => $noise, -distType => CV_RAND_NORMAL,
	-param1 => cvScalarAll(0), -param2 => cvScalarAll(20),
	);
$noise->smooth(
	-dst => $noise, -smoothType => CV_GAUSSIAN,
	-param1 => 5, -param2 => 5, -param3 => 1, -param4 => 1,
	);

# convert image to YUV color space. The output image will be created
# automatically, and split the image into separate color planes
my ($y, $u, $v) = $img->cvtColor(CV_BGR2YCrCb)->split;
$y->acc($noise)->convert($y);
Cv->merge($y, $u, $v)->cvtColor(CV_YCrCb2BGR)->show(-name => $imagename);
Cv->waitKey();
