#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use lib qw(blib/lib blib/arch);
use strict;
use Cv qw(:all);
use File::Basename;
use Time::HiRes qw(gettimeofday);
use Data::Dumper;

my $filename = @ARGV > 0 ? shift : dirname($0).'/'."stuff.jpg";
my $gray = Cv->LoadImage($filename, CV_LOAD_IMAGE_GRAYSCALE)
	or die "Image was not loaded.\n";

print "Hot keys: \n",
	"\tESC - quit the program\n",
	"\tC - use C/Inf metric\n",
	"\tL1 - use L1 metric\n",
	"\tL2 - use L2 metric\n",
	"\t3 - use 3x3 mask\n",
	"\t5 - use 5x5 mask\n",
	"\t0 - use precise distance transform\n",
	"\tv - switch Voronoi diagram mode on/off\n",
	"\tSPACE - loop through all the modes\n";

my $dist = Cv->CreateImage( scalar $gray->GetSize, IPL_DEPTH_32F, 1 );
my $dist8u1 = $gray->new;
my $dist8u2 = $gray->new;
my $dist8u = Cv->CreateImage( scalar $gray->GetSize, IPL_DEPTH_8U, 3 );
my $dist32s = Cv->CreateImage( scalar $gray->GetSize, IPL_DEPTH_32S, 1 );
my $labels = Cv->CreateImage( scalar $gray->GetSize, IPL_DEPTH_32S, 1 );

my $build_voronoi = 0;
my $mask_size = CV_DIST_MASK_5;
my $dist_type = CV_DIST_L1;
my $edge_thresh = 100;

my $wndname = "Distance transform";
my $win = Cv->NamedWindow( $wndname, 1 )
	->CreateTrackbar( -name => "Threshold", 
					  -value => \$edge_thresh,
					  -count => 255,
					  -callback => \&on_trackbar );

for (;;) {
	# Call to update the view
	&on_trackbar(100);
	
	my $c = Cv->WaitKey;
	$c &= 0x7f if ($c > 0);
	last if ($c == 27);

	my $key = chr($c);
	if( $key eq 'c' || $key eq 'C' ) {
		$dist_type = CV_DIST_C;
	} elsif ( $key eq '1' ) {
		$dist_type = CV_DIST_L1;
	} elsif ( $key eq '2' ) {
		$dist_type = CV_DIST_L2;
	} elsif ( $key eq '3' ) {
		$mask_size = CV_DIST_MASK_3;
	} elsif ( $key eq '5' ) {
		$mask_size = CV_DIST_MASK_5;
	} elsif ( $key eq '0' ) {
		$mask_size = CV_DIST_MASK_PRECISE;
	} elsif ( $key eq 'v' ) {
		$build_voronoi ^= 1;
	} elsif ( $key eq ' ' ) {
		if ( $build_voronoi ) {
			$build_voronoi = 0;
			$mask_size = CV_DIST_MASK_3;
			$dist_type = CV_DIST_C;
		} elsif ( $dist_type == CV_DIST_C ) {
			$dist_type = CV_DIST_L1;
		} elsif ( $dist_type == CV_DIST_L1 ) {
			$dist_type = CV_DIST_L2;
		} elsif ( $mask_size == CV_DIST_MASK_3 ) {
			$mask_size = CV_DIST_MASK_5;
		} elsif ( $mask_size == CV_DIST_MASK_5 ) {
			$mask_size = CV_DIST_MASK_PRECISE;
		} elsif ( $mask_size == CV_DIST_MASK_PRECISE ) {
			$build_voronoi = 1;
		}
	}
}

exit;    

# threshold trackbar callback
sub on_trackbar {
    my $msize = $mask_size;
    my $_dist_type = $build_voronoi ? CV_DIST_L2 : $dist_type;
    my $edge = $gray->Threshold(-threshold => $edge_thresh,
								-max_value => $edge_thresh,
								-threshold_type => CV_THRESH_BINARY);
    $msize = CV_DIST_MASK_5 if ($build_voronoi);
    if ($_dist_type == CV_DIST_L1) {
		$edge->DistTransform(-dst => $dist,
							 -distance_type => $_dist_type,
							 -mask_size => $msize);
    } else {
		$edge->DistTransform(-dst => $dist,
							 -distance_type => $_dist_type,
							 -mask_size => $msize,
							 -labels => $build_voronoi ? $labels : \0);
	}
    unless ($build_voronoi) {
        # begin "painting" the distance transform result
        $dist->ConvertScale(-scale =>  5000, -shift => 0)->Pow(0.5)
			->ConvertScale(-scale => 1.0, -shift => 0.5, -dst => $dist32s);

        $dist32s->AndS(-value => scalar cvScalarAll(255), -dst => $dist32s)
			->ConvertScale(-scale => 1, -shift => 0, -dst => $dist8u1);

		$dist32s->ConvertScale(-scale => -1, -shift => 0, -dst => $dist32s)
			->AddS(-value => scalar cvScalarAll(255), -dst => $dist32s)
			->ConvertScale(-scale => 1, -shift => 0, -dst => $dist8u2);

        $dist8u->Merge(-src0 => $dist8u1, -src1 => $dist8u2, -src2 => $dist8u2);
        # end "painting" the distance transform result
    } else {
		my $use_inline_c = 0;
		my $show_etime = 0;
		my $t0 = gettimeofday;
		if ($use_inline_c) {
			# 0.03s
			&dovoronoi($labels, $dist, $dist8u);
		} else {
			# 18s
			my @colors = ( [   0,   0,   0 ],
						   [ 255,   0,   0 ],
						   [ 255, 128,   0 ],
						   [ 255, 255,   0 ],
						   [   0, 255,   0 ],
						   [   0, 128, 255 ],
						   [   0, 255, 255 ],
						   [   0,   0, 255 ],
						   [ 255,   0, 255 ],
				);
			foreach my $y (0 .. $labels->height - 1) {
				my @ll = $labels->PtrD([$y, 0]);
				my @dd = $dist->PtrD([$y, 0]);
				foreach my $x (0 .. $labels->width - 1) {
					my $idx = $ll[$x] == 0 || $dd[$x] == 0 ?
						0 : ($ll[$x] - 1) % 8 + 1;
					#$dist8u->SetD(-idx => [$y, $x], -value => $colors[$idx]);
					cvSet2D($dist8u, $y, $x, pack("d4", @{$colors[$idx]}));
				}
			}
			my $font = Cv->InitFont(CV_FONT_HERSHEY_PLAIN);
			$font->PutText(
				-img => $dist8u, -org => [ 20, 20 ], -overstrike => 1,
				-text => "Try '\$use_inline_c = 1' if you feel slow.");
		}
		my $t1 = gettimeofday;
		print $t1 - $t0, "\n" if ($show_etime);
    }
    $win->ShowImage($dist8u);
}


use Inline C => Config => CCFLAGS => '-I/usr/local/include';
use Inline C => Config => TYPEMAPS => "$ENV{HOME}/Cv/typemap";
use Inline C => <<'----';
#include <opencv/cv.h>
#include <opencv/highgui.h>

void dovoronoi(IplImage *labels, IplImage *dist, IplImage *dist8u)
{
    static const uchar colors[][3] = {
        {   0,   0,   0 },
        { 255,   0,   0 },
        { 255, 128,   0 },
        { 255, 255,   0 },
        {   0, 255,   0 },
        {   0, 128, 255 },
        {   0, 255, 255 },
        {   0,   0, 255 },
        { 255,   0, 255 }
    };
	int i, j;
	for (i = 0; i < labels->height; i++) {
		int* ll = (int*)(labels->imageData + i*labels->widthStep);
		float* dd = (float*)(dist->imageData + i*dist->widthStep);
		uchar* d = (uchar*)(dist8u->imageData + i*dist8u->widthStep);
		for (j = 0; j < labels->width; j++) {
			int idx = ll[j] == 0 || dd[j] == 0 ? 0 : (ll[j] - 1)%8 + 1;
			int b = cvRound(colors[idx][0]);
			int g = cvRound(colors[idx][1]);
			int r = cvRound(colors[idx][2]);
			d[j*3 + 0] = (uchar)b;
			d[j*3 + 1] = (uchar)g;
			d[j*3 + 2] = (uchar)r;
		}
	}
}
----
