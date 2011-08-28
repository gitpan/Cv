#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package main;

use strict;
use lib qw(blib/lib blib/arch);
use Cv;

foreach my $dir (@ARGV) {
	my $capture = Cv::Capture->fromFlipbook($dir);
	$capture or die "can't create capture";
	while (my $frame = $capture->queryFrame) {
		$frame->show($dir);
		my $c = Cv->waitKey(33);
		$c &= 0x7f if ($c >= 0);
		last if ($c == 27);
	}
	Cv->destroyWindow($dir);
}
