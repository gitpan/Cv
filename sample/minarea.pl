#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use lib qw(../blib/lib ../blib/arch);
use Cv;
use Data::Dumper;

my $ARRAY = 1;					# 1: Cv:Mat, 0: Cv::Seq

my $win = Cv->NamedWindow(-name => "rect & circle", -flags => 1);
my $img = Cv->new(-size => [ 500, 500 ], -depth => 8, -channels => 3);
my $mem = Cv->CreateMemStorage;

while (1) {
	my $p = undef;
	my $count = rand(100) + 1;

	if ($ARRAY) {
        $p = Cv->CreateMat(
			-rows => 1,
			-cols => $count,
			-type => CV_32SC2,	# as cvPoint
			);
	} else {
		use Cv::Seq::Point;
		$p = Cv::Seq::Point->new(
			-seq_flags => CV_SEQ_KIND_GENERIC | CV_32SC2,
			-storage => $mem,
			);
	}

	foreach (0 .. $count - 1) {
		my $pt = cvPoint(
			-x => rand($img->width/2)  + $img->width/4,
			-y => rand($img->height/2) + $img->height/4,
			);
		if ($ARRAY) {
			$p->SetD(-idx => $_, -value => $pt);
		} else {
			$p->Push(-element => $pt);
        }
	}

	$img->Zero;
	foreach (0 .. $count - 1) {
		my $pt;
		if ($ARRAY) {
			$pt = $p->GetD(-idx => $_);
		} else {
			$pt = $p->GetSeqElem(-index => $_);
		}
		$img->Circle(
			-center => $pt,
			-radius => 2,
			-color => CV_RGB(255, 0, 0),
			-thickness => CV_FILLED,
			-line_type => CV_AA,
			-shift => 0,
			);
	}

	my @b = Cv->BoxPoints(-box => $p->MinAreaRect2());
	foreach ([ $b[0], $b[1] ], [ $b[1], $b[2] ],
			 [ $b[2], $b[3] ], [ $b[3], $b[0] ]) {
		$img->Line(
			-pt1 => $_->[0],
			-pt2 => $_->[1],
			-color => CV_RGB(0, 255, 0),
			-thickness => 1,
			-line_type => CV_AA,
			-shift => 0,
			);
	}

	$img->Circle(
		-circle => $p->MinEnclosingCircle(),
		-color => CV_RGB(255, 255, 0),
		-thickness => 1,
		-line_type => CV_AA,
		-shift => 0,
		);

	$win->ShowImage(-image => $img);
	my $key = $win->WaitKey;
	$key &= 0x7f if $key >= 0;
	last if $key == 27 || $key == ord('q') || $key == ord('Q'); # 'ESC'
}

$win->DestroyWindow;

exit 0;
