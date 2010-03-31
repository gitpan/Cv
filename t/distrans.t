# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use Test::More qw(no_plan);
#use Test::More tests => 2;
BEGIN {
	use_ok('Cv');
}
use File::Basename;
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
my $dist8u1 = $gray->CloneImage;
my $dist8u2 = $gray->CloneImage;
my $dist8u = Cv->CreateImage( scalar $gray->GetSize, IPL_DEPTH_8U, 3 );
my $dist32s = Cv->CreateImage( scalar $gray->GetSize, IPL_DEPTH_32S, 1 );
#my $edge = $gray->CloneImage;
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

for (0..5) {
	# Call to update the view
	&on_trackbar(100);
	
	my $c = Cv->WaitKey(1000);
	my $key = ' ';

	last if ($c > 0 && ($c & 0x7f) == 27);
	
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

ok(1);

# threshold trackbar callback
sub on_trackbar {
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
    
    my $msize = $mask_size;
    my $_dist_type = $build_voronoi ? CV_DIST_L2 : $dist_type;
    my $edge = $gray->Threshold(-threshold => $edge_thresh,
								-max_value => $edge_thresh,
								-threshold_type => CV_THRESH_BINARY);

    $msize = CV_DIST_MASK_5 if ( $build_voronoi );

    if ( $_dist_type == CV_DIST_L1 ) {
		$edge->DistTransform(-dst => $edge,
							 -distance_type => $_dist_type,
							 -mask_size => $msize);
        $edge->Convert(-dst => $dist);
    } else {
		$edge->DistTransform(-dst => $dist,
							 -distance_type => $_dist_type,
							 -mask_size => $msize,
							 -mask => \0,
							 -labels => $build_voronoi ? $labels : \0);
	}
    unless ( $build_voronoi ) {

        # begin "painting" the distance transform result
        $dist->ConvertScale(-scale =>  5000, -shift => 0)->Pow(0.5)
			->ConvertScale(-scale => 1.0, -shift => 0.5, -dst => $dist32s);

        $dist32s->AndS(-value => scalar cvScalarAll(255), -dst => $dist32s)
			->ConvertScale(-scale => 1, -shift => 0, -dst => $dist8u1);

		$dist32s->ConvertScale(-scale => -1, -shift => 0, -dst => $dist32s)
			->AddS(-value => scalar cvScalarAll(255), -dst => $dist32s)
			->ConvertScale(-scale => 1, -shift => 0, -dst => $dist8u2);

        $dist8u->Merge(-src0 => $dist8u1, -src1 => $dist8u2, -src2 => $dist8u2);

        #$dist->ConvertScale(-dst => $dist, -scale =>  5000, -shift => 0);
        #$dist->Pow(0.5);
    
        #$dist->ConvertScale(-dst => $dist32s, -scale => 1.0, -shift => 0.5);
        #$dist32s->AndS(scalar cvScalarAll(255));
        #$dist32s->ConvertScale(-dst => $dist8u1, -scale =>  1, -shift => 0);
		#$dist32s->ConvertScale(-dst => $dist32s, -scale => -1, -shift => 0);
        #$dist32s->AddS(scalar cvScalarAll(255));
		#$dist32s->ConvertScale(-dst => $dist8u2, -scale => 1, -shift => 0);
        #$dist8u->Merge(-src0 => $dist8u1, -src1 => $dist8u2, -src2 => $dist8u2);

        # end "painting" the distance transform result

    } else {

		my @ll = unpack("L*", $labels->GetImageData);
		my @dd = unpack("L*", $dist->GetImageData);
		my $d;
		for my $i (0 .. $#ll) {
			my $idx = $ll[$i] == 0 || $dd[$i] == 0 ? 0 : ($ll[$i] - 1) % 8 + 1;
			$d .= chr($colors[$idx][0]).
				chr($colors[$idx][1]).
				chr($colors[$idx][2]);
		}
		$dist8u->SetImageData($d);
    }
    
    $win->ShowImage($dist8u);
}
