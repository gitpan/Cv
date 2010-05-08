#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;
use Data::Dumper;

my $ffill_case = 1;
my $lo_diff = 20;
my $up_diff = 20;
my $connectivity = 4;
my $is_color = 1;
my $is_mask = undef;

my $filename = @ARGV > 0 ? shift : dirname($0).'/'."fruits.jpg";
my $color_img0 = Cv->LoadImage($filename, CV_LOAD_IMAGE_COLOR) or 
	die "Image was not loaded.\n";

print "Hot keys: \n",
	"\tESC - quit the program\n",
	"\tc - switch color/grayscale mode\n",
	"\tm - switch mask mode\n",
	"\tr - restore the original image\n",
	"\ts - use null-range floodfill\n",
	"\tf - use gradient floodfill with fixed(absolute) range\n",
	"\tg - use gradient floodfill with floating(relative) range\n",
	"\t4 - use 4-connectivity mode\n",
	"\t8 - use 8-connectivity mode\n";

my $color_img = $color_img0->CloneImage;
my $gray_img0 = $color_img->CvtColor(CV_BGR2GRAY);
my $gray_img = $gray_img0->CloneImage;
my $mask = Cv->CreateImage( -size => [$color_img->width + 2, $color_img->height + 2],
							-depth => 8,
							-channels => 1 );

Cv->NamedWindow( "image", 0 )
	->CreateTrackbar( -name => "lo_diff", -value => $lo_diff,
					  -count => 255, -callback => sub {$lo_diff = shift;} )
	->CreateTrackbar( -name => "up_diff", -value => $up_diff,
					  -count => 255, -callback => sub {$up_diff = shift} )
	->SetMouseCallback( -callback => \&on_mouse );

while (1) {

	if ( $is_color ) {
		$color_img->ShowImage("image");
	} else {
		$gray_img->ShowImage("image");
	}
	
	my $c = Cv->WaitKey;
	$c &= 0x7f if $c > 0;
	if ($c == 27) {
		print "Exiting ...\n";
		last;
	} elsif ($c == ord('c')) {
		if ( $is_color ) {
			print "Grayscale mode is set\n";
			$gray_img = $color_img->CvtColor(CV_BGR2GRAY);
			$is_color = 0;
		} else {
			print "Color mode is set\n";
			Cv->Copy( -src => $color_img0, -dst => $color_img );
			$mask->Zero;
			$is_color = 1;
		}
	} elsif ($c == ord('m')) {
		if ( $is_mask ) {
			$is_mask->DestroyWindow;
			$is_mask = undef;
		} else {
			$is_mask = Cv->NamedWindow("mask", 0);
			$mask->Zero;
			$mask->ShowImage("mask");
		}
	} elsif ($c == ord('r')) {
		print "Original image is restored\n";
		Cv->Copy( -src => $color_img0, -dst => $color_img );
		Cv->Copy( -src => $gray_img0, -dst => $gray_img );
		$mask->Zero;
	} elsif ($c == ord('s')) {
		print "Simple floodfill mode is set\n";
		$ffill_case = 0;
	} elsif ($c == ord('f')) {
		print "Fixed Range floodfill mode is set\n";
		$ffill_case = 1;
	} elsif ($c == ord('g')) {
		print "Gradient (floating range) floodfill mode is set\n";
		$ffill_case = 2;
	} elsif ($c == ord('4')) {
		print "4-connectivity mode is set\n";
		$connectivity = 4;
	} elsif ($c == ord('8')) {
		print "8-connectivity mode is set\n";
		$connectivity = 8;
	}
}

exit 1;

sub on_mouse {
	my ($event, $x, $y, $flags, $param) = @_;
    return unless ($color_img);

    if ($event == CV_EVENT_LBUTTONDOWN) {
		my $new_mask_val = 255;
		my $seed = [$x, $y];
		my $lo = $ffill_case == 0 ? 0 : $lo_diff;
		my $up = $ffill_case == 0 ? 0 : $up_diff;
		my $flags = $connectivity + ($new_mask_val << 8) +
			($ffill_case == 1 ? CV_FLOODFILL_FIXED_RANGE : 0);
		my ($b, $g, $r) = (rand(2**32)&255, rand(2**32)&255, rand(2**32)&255);

		if ( $is_mask ) {
			$mask->Threshold(-threshold => 1,
							 -max_value => 128,
							 -threshold_type => CV_THRESH_BINARY );
		}

		if ( $is_color ) {
			my $color = CV_RGB( $r, $g, $b );
			$color_img->FloodFill( -seed_point => $seed,
								   -new_val => $color,
								   -lo_diff => CV_RGB( $lo, $lo, $lo ),
								   -up_diff => CV_RGB( $up, $up, $up ),
								   -flags => $flags,
								   -mask => $is_mask ? $mask : \0 );
			$color_img->ShowImage("image");
		} else {
			my $brightness = cvRealScalar(($r*2 + $g*7 + $b + 5)/10);
			$gray_img->FloodFill( -seed_point => $seed,
								  -new_val => $brightness,
								  -lo_diff => scalar cvRealScalar( $lo ),
								  -up_diff => scalar cvRealScalar( $up ),
								  -flags => $flags,
								  -mask => $is_mask ? $mask : \0 );
			$gray_img->ShowImage("image");
		}
		
		#print "$comp.area pixels were repainted\n";
		
		if ( $is_mask ) {
			$mask->ShowImage("mask");
		}
	}
}
