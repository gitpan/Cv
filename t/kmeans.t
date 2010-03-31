# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use Test::More qw(no_plan);
#use Test::More tests => 2;
BEGIN {
	use_ok('Cv');
}
use File::Basename;
use Data::Dumper;
use List::Util qw(min);

my $MAX_CLUSTERS = 5;
my @color_tab = (
    &CV_RGB(255,   0,   0),
    &CV_RGB(  0, 255,   0),
    &CV_RGB(100, 100, 255),
    &CV_RGB(255,   0, 255),
    &CV_RGB(255, 255,   0),
	);

my $img = Cv->new(
	-size => scalar cvSize(500, 500),
	-depth => 8, -channels => 3);
my $rng = Cv->RNG;


Cv->NamedWindow(-name => "clusters", -flags => 1);
        
for (0..3) {
	my $cluster_count = $rng->RandInt % $MAX_CLUSTERS + 1;
	my $sample_count = $rng->RandInt % 1000 + $MAX_CLUSTERS;
	my $points   = Cv->CreateMat(-rows => $sample_count, -type => CV_32FC2);
	my $clusters = Cv->CreateMat(-rows => $sample_count, -type => CV_32SC1);

	# generate random sample from multigaussian distribution
	for (my $k = 0; $k < $cluster_count; $k++) {
		my $point_chunk =
			Cv->CreateMat(-rows => 1, -cols => 1, -type => CV_32FC2);
		$points->GetRows(
			-submat => $point_chunk,
			-start_row => ($sample_count * $k) / $cluster_count,
			-end_row => $k == $cluster_count - 1 ?
				$sample_count :	$sample_count * ($k + 1) / $cluster_count,
			-delta_row => 1,
			);
		$rng->RandArr(
			-arr => $point_chunk,
			-dist_type => &CV_RAND_NORMAL,
			-param1 => scalar cvScalar(
				 -x => $rng->RandInt % $img->width,
				 -y => $rng->RandInt % $img->height,
			),
			-param2 => scalar cvScalar(
				 -x => $img->width * 0.1,
				 -y => $img->height * 0.1,
			),
			);
		# print STDERR "point_chunk->refcount = ", $point_chunk->refcount, "\n";
	}

	# shuffle samples
	for (my $i = 0; $i < $sample_count / 2; $i++) {
		my $i1 = $rng->RandInt % $sample_count;
		my $i2 = $rng->RandInt % $sample_count;
		my $pt1 = $points->GetD($i1);
		my $pt2 = $points->GetD($i2);
		$points->SetD($i1, $pt2);
		$points->SetD($i2, $pt1);
	}
	$points->KMeans2(
		-labels => $clusters,
		-cluster_count => $cluster_count,
		-criteria => scalar cvTermCriteria(
			 -type => &CV_TERMCRIT_EPS | &CV_TERMCRIT_ITER,
			 -max_iter => 10,
			 -epsilon => 1.0,
		));
	$img->Zero;
	for (my $i = 0; $i < $sample_count; $i++) {
		my $cluster_idx = $clusters->GetD($i)->[0];
		$img->Circle(
			-center => scalar $points->GetD($i),
			-radius => 2,
			-color => $color_tab[$cluster_idx],
			-thickness => &CV_FILLED,
			-line_type => &CV_AA,
			-shift => 0,
			);
	}

	$img->ShowImage("clusters");

	my $key = Cv->WaitKey(1000);
	$key &= 0x7f if ($key >= 0);
	last if ($key == 27 || $key == ord('q') || $key == ord('Q')); # 'ESC'
}
