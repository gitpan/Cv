#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use Data::Dumper;
use List::Util qw(max min);

my $cap = undef;
if (@ARGV == 0) {
	$cap = Cv->CreateCameraCapture(0);
} elsif (@ARGV == 1 && $ARGV[0] =~ /^\d$/) {
	$cap = Cv->CreateCameraCapture($ARGV[0]);
} else {
	$cap = Cv->CreateFileCapture($ARGV[0]);
}
$cap or die "$0: Could not initialize capturing...\n";

print "Hot keys: \n",
	"\tESC - quit the program\n",
	"\tc - stop the tracking\n",
	"\tb - switch to/from backprojection view\n",
	"\th - show/hide object histogram\n",
	"To initialize tracking, select the object with mouse\n";

my ($vmin, $vmax, $smin) = (10, 256, 30);
my $image = $cap->QueryFrame->CloneImage;
my $win = Cv->NamedWindow("CamShiftDemo")
	->SetMouseCallback(-callback => \&on_mouse, -param => \0)
	->CreateTrackbar(-name => "Vmin", -value => $vmin, -count => 256)
	->CreateTrackbar(-name => "Vmax", -value => $vmax, -count => 256)
	->CreateTrackbar(-name => "Smin", -value => $smin, -count => 256)
	;

my $histimg = Cv->CreateImage([320, 200], 8, 3)->Zero;
my $hdims = 16;
my $hranges_arr = [0, 180];
my $hist = Cv::Histogram->new(-sizes => [$hdims],
							  -ranges => [$hranges_arr],
							  -type => CV_HIST_ARRAY,
							  );

my %selection;
my %origin;
my $select_object;
my $track_object;
my $track_window;

my $backproject_mode = 0;
my $show_hist = 1;

while (1) {
	$image = $cap->QueryFrame->CloneImage;
	my $hsv = $image->CvtColor(CV_BGR2HSV);

	if ( $track_object ) {
		my $mask = Cv->CreateImage([$image->GetSize], 8, 1);
		$hsv->InRangeS(-lower => [0, $smin, min($vmin,$vmax), 0],
					   -upper => [180, 256, max($vmin,$vmax), 0],
					   -dst => $mask);
		my $c = $hsv->GetChannels;
		my $d = $hsv->GetDepth;
		my $hue = Cv->CreateImage( [$image->GetSize], 8, 1 );
		$hsv->Split($hue, undef, undef, undef);

		 if ( $track_object < 0 ) {
			 $hue->SetImageROI( {%selection} );
			 $mask->SetImageROI( {%selection} );
			 $hist->Calc( -images => [$hue], -mask => $mask );
			 $hue->ResetImageROI;
			 $mask->ResetImageROI;
			 %$track_window = %selection;
			 $track_object = 1;

			 my $bin_w = $histimg->GetSize->[0] / $hdims;
			 for my $i (0..$hdims-1) {
				 my $val = Cv->Round($hist->QueryHistValue([$i]) * $histimg->GetSize->[1]/255 );
#				 my $val = Cv->Round($hist->GetRealD($i) * $histimg->GetSize->[1]/255 );
				 my $color = &hsv2rgb($i*180.0 / $hdims);
				 $histimg->Rectangle(
					-pt1 => [$i*$bin_w, $histimg->GetSize->[1]],
					-pt2 => [($i+1)*$bin_w, $histimg->GetSize->[1] - $val],
					-color => $color,
					-thickness => -1,
					-line_type => 8,
					-shift => 0);
			 }
		 }
		 
		 my $backproject = $hist->CalcBackProject([$hue])->And($mask);
		 my $cam = $backproject->CamShift( -window => $track_window );
		 %$track_window = %{$cam->{comp}{rect}};

		 $image = $backproject->CvtColor(CV_GRAY2BGR) if( $backproject_mode );
		 $cam->{box}{angle} = -$cam->{box}{angle} unless ($image->GetOrigin);
		 $image->EllipseBox( -box => $cam->{box}, -color => 'red', -thickness => 3 );
	}

	if ( $select_object && $selection{width} > 0 && $selection{height} > 0 ) {
		$image->SetImageROI( {%selection} );
		$image->XorS(-value => [255, 255, 255], -dst => $image);
		$image->ResetImageROI;
	}

	$win->ShowImage($image);
	$histimg->ShowImage("Histogram") if ($show_hist);

	my $c = Cv->WaitKey(30);
	$c &= 0x7f if ($c > 0);
	if ($c == 27) {
		last;
	} elsif (chr($c) eq 'b') {
		$backproject_mode ^= 1;
	} elsif (chr($c) eq 'c') {
		$track_object = 0;
		$histimg->Zero;
	} elsif (chr($c) eq 'h') {
		$show_hist ^= 1;
		unless ($show_hist) {
			$histimg->DestroyWindow;
		}
	}
}

exit;

sub hsv2rgb {
	my $hue = shift;
    my @sector_data = ( [0,2,1], [1,2,0], [1,0,2],
						[2,0,1], [2,1,0], [0,1,2] );
    $hue *= 0.033333333333333333333333333333333;
    my $sector = Cv->Floor($hue);
    my $p = Cv->Round(255*($hue - $sector));
    $p ^= $sector & 1 ? 255 : 0;
	
    my @rgb;
    $rgb[$sector_data[$sector][0]] = 255;
    $rgb[$sector_data[$sector][1]] = 0;
    $rgb[$sector_data[$sector][2]] = $p;
	
    return [$rgb[2], $rgb[1], $rgb[0]];
}


sub on_mouse {
	
    return unless $image;
	
	my ($event, $x, $y, $flags, $param) = @_;
	
    if( $image->GetOrigin ) {
        $y = $image->GetSize->[1] - $y;
	}
	
    if ( $select_object == 1 ) {
        $selection{x} = min($x, $origin{x});
        $selection{y} = min($y, $origin{y});
        $selection{width} = $selection{x} + abs($x - $origin{x});
        $selection{height} = $selection{y} + abs($y - $origin{y});
        
        $selection{x} = max( $selection{x}, 0 );
        $selection{y} = max( $selection{y}, 0 );
        $selection{width} = min( $selection{width}, $image->GetSize->[0] );
        $selection{height} = min( $selection{height}, $image->GetSize->[1] );
        $selection{width} -= $selection{x};
        $selection{height} -= $selection{y};
    }

    if ( $event == CV_EVENT_LBUTTONDOWN ) {
        $origin{x} = $x;
        $origin{y} = $y;
        $selection{x} = $x;
        $selection{y} = $y;
        $selection{width} = 0;
        $selection{height} = 0;
        $select_object = 1;
	} elsif ( $event == CV_EVENT_LBUTTONUP ) {
        $select_object = 0;
        if ( $selection{width} > 0 && $selection{height} > 0 ) {
            $track_object = -1;
		}
	} elsif ( $event == CV_EVENT_RBUTTONDOWN ) {
		$select_object = 0;
		$track_object = 0;
    }
}
