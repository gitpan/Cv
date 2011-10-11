# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Histogram;

use 5.008008;
use strict;
use warnings;

BEGIN {
	Cv::aliases(
		[ 'cvCalcHist', 'Calc' ],
		[ 'cvClearHist', 'Clear' ],
		[ 'cvCalcBackProject' ],
		[ 'cvCompareHist', 'Compare' ],
		[ 'CopyHist', 'Copy' ],
		[ 'cvGetMinMaxHistValue' ],
		[ 'cvNormalizeHist', 'Normalize' ],
		[ 'cvSetHistBinRanges', 'SetBinRanges' ],
		[ 'cvThreshHist', 'Thresh' ],
		[ 'GetHistValue' ],
		[ 'QueryHistValue' ],
		);
}

sub new {
	my $self = shift;
	my $sizes = @_? shift : $self->sizes;
	my $type = @_? shift : &Cv::CV_HIST_ARRAY; # $self->type;
	my $ranges = @_? shift : $self->thresh;
	unshift(@_, $sizes, $type, $ranges);
	# use Data::Dumper;
	# print STDERR Data::Dumper->Dump([\@_], [qw($av)]);
	goto &Cv::cvCreateHist;
}

sub QueryHistValue {
	my $self = shift;
	if (ref $_[0] eq 'ARRAY') {
		unshift(@_, $self);
		goto &cvQueryHistValue_nD;
	} elsif (@_ == 1) {
		unshift(@_, $self);
		goto &cvQueryHistValue_1D;
	} elsif (@_ == 2) {
		unshift(@_, $self);
		goto &cvQueryHistValue_2D;
	} elsif (@_ == 3) {
		unshift(@_, $self);
		goto &cvQueryHistValue_3D;
	} else {
		@_ = ($self, \@_);
		goto &cvQueryHistValue_nD;
	}
}

sub GetHistValue {
	my $self = shift;
	if (ref $_[0] eq 'ARRAY') {
		unshift(@_, $self);
		goto &cvGetHistValue_nD;
	} elsif (@_ == 1) {
		unshift(@_, $self);
		goto &cvGetHistValue_1D;
	} elsif (@_ == 2) {
		unshift(@_, $self);
		goto &cvGetHistValue_2D;
	} elsif (@_ == 3) {
		unshift(@_, $self);
		goto &cvGetHistValue_3D;
	} else {
		@_ = ($self, \@_);
		goto &cvGetHistValue_nD;
	}
}

sub CopyHist {
	# CopyHist(src. dst)
	my $src = shift;
	my $dst = shift || $src->new;
	unshift(@_, $src, $dst);
	goto &cvCopyHist;
}

1;
__END__
