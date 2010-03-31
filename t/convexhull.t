# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use Test::More qw(no_plan);
#use Test::More tests => 2;
BEGIN {
	use_ok('Cv');
}
use File::Basename;
use Data::Dumper;
use List::Util qw(min);

#use Cv::Mat;
#use Cv::Seq::Point;

my $ARRAY = 1;					# 1: Cv:Mat, 0: Cv::Seq

my $win = Cv->NamedWindow(-name => "hull", -flags => 1);
my $img = Cv->new(-size => [ 500, 500 ], -depth => 8, -channels => 3);
my $storage = Cv->CreateMemStorage(0);

for (0 .. 3) {
	my $count = int(rand(100) + 1);
	my $p;

	if (!$ARRAY) {
        $p = Cv::Seq::Point->new(
			-flags => &CV_SEQ_KIND_GENERIC | &CV_32SC2,
			-storage => $storage,
			);
	} else {
        $p = Cv::Mat->new(
			-rows => 1,
			-cols => $count,
			-type => CV_32SC2,	# as cvPoint
			);
	}

	foreach (0 .. $count - 1) {
		my $pt = cvPoint(
			-x => rand($img->width/2)  + $img->width/4,
			-y => rand($img->height/2) + $img->height/4,
			);
		if (!$ARRAY) {
			$p->Push(-element => $pt);
		} else {
			$p->SetD(-idx => $_, -value => $pt);
		}
	}

	my $hull;
	if (!$ARRAY) {
		$hull = $p->ConvexHull2(
			# -storage => $storage,
			# -orientation => CV_CLOCKWISE,
			-return_points => 1, # cold not use pointer of sequence
			);
	} else {
		$hull = Cv::Mat->new(
			-rows => 1,
			-cols => $count,
			-type => CV_32SC1,
			);
        $p->ConvexHull2(
			-storage => $hull,
			# -orientation => CV_CLOCKWISE,
			# -return_points => 0,
			);
	}

	$img->Zero;
	foreach (0 .. $count - 1) {
		my $pt;
		if (!$ARRAY) {
			$pt = $p->GetSeqElem(-index => $_);
		} else {
			$pt = $p->GetD(-idx => $_);
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
	my @pts = map {
		if (!$ARRAY) {
			scalar $hull->GetSeqElem(-index => $_);
		} else {
			# scalar $p->GetD(-idx => scalar $hull->GetD(-idx => $_));
			[ @{$p->GetD(-idx => ${$hull->GetD(-idx => $_)}[0])}[0..1] ];
		}
	} (0 .. $hull->total - 1, 0);
	my $pt0 = shift(@pts);
	foreach my $pt (@pts) {
		$img->Line(
			-pt1 => $pt0,
			-pt2 => $pt,
			-color => CV_RGB(0, 255, 0),
			-thickness => 1,
			-line_type => CV_AA,
			-shift => 0,
			);
		$pt0 = $pt;
	}
	$img->ShowImage("hull");

	my $key = Cv->WaitKey(1000);
	$key &= 0x7f if $key >= 0;
	last if ($key == 27 || $key == ord('q') || $key == ord('Q')); # 'ESC'
}

exit 0;
