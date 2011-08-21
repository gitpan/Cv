#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::TieHash;

use 5.008000;
use strict;
use warnings;

use Tie::Hash;

use lib qw(blib/lib blib/arch);
use Cv;

our @ISA = qw(Tie::Hash);

sub TIEHASH {
	my $class = shift;
	bless {
		image => $_[0],
		fetch => {
			image =>    sub { $_[0] },
			depth =>    sub { $_[0]->depth },
			channels => sub { $_[0]->channels },
			origin =>   sub { $_[0]->origin },
			width =>    sub { $_[0]->width },
			height =>   sub { $_[0]->height },
		},
		store => {
			origin =>   sub { $_[0]->origin($_[1]) },
		},
	}, $class;
}

sub FETCH {
	my $self = shift;
	my $key = shift;
	if (defined (my $fetch = $self->{fetch}{$key})) {
		&{$fetch}($self->{image}, @_);
	} else {
		$self->{image}->get([map int, split($;, $key)]);
	}
}

sub STORE {
	my $self = shift;
	my $key = shift;
	if (defined (my $store = $self->{store}{$key})) {
		&{$store}($self->{image}, @_);
	} else {
		$self->{image}->set([map int, split($;, $key)], @_);
	}
}	

1;

package main;

use strict;

use lib qw(blib/lib blib/arch);
use Cv;
use Time::HiRes qw(gettimeofday);

tie my %hash, 'Cv::TieHash', Cv::Image->new([ 240, 320 ], CV_8UC3);

foreach ('depth', 'channels', 'origin', 'width', 'height') {
	print STDERR "$_ = ", $hash{$_}, "\n";
}

my $t0 = gettimeofday;

$hash{origin} = 1;
foreach my $row (0 .. $hash{height} - 1) {
	for (my $col = 0; $col <= $hash{width} - 8; $col += 8) {
		$hash{$row, $col + 0} = [   0,   0,   0 ];
		$hash{$row, $col + 1} = [ 255,   0,   0 ];
		$hash{$row, $col + 2} = [   0, 255,   0 ];
		$hash{$row, $col + 3} = [ 255, 255,   0 ];
		$hash{$row, $col + 4} = [   0,   0, 255 ];
		$hash{$row, $col + 5} = [ 255,   0, 255 ];
		$hash{$row, $col + 6} = [   0, 255, 255 ];
		$hash{$row, $col + 7} = [ 255, 255, 255 ];
	}
	$hash{image}->show($0);
	my $c = Cv->waitKey(33);
	last if ($c >= 0 && ($c & 0x7f) == 27);
}

my $t1 = gettimeofday;
print $t1 - $t0, "\n";

$hash{origin} = 0;
foreach my $row (0 .. $hash{height} - 1) {
	foreach my $col (0 .. $hash{width} - 1) {
		$hash{$row, $col} = [ map { $_ ^ 0xff } @{$hash{$row, $col}} ];
	}
	$hash{image}->show($0);
	my $c = Cv->waitKey(33);
	last if ($c >= 0 && ($c & 0x7f) == 27);
}

my $t2 = gettimeofday;
print $t2 - $t1, "\n";

Cv->waitKey(1000);
