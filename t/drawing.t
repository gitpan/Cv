#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-


use Test::More qw(no_plan);
#use Test::More tests => 18;
use Test::Output;
use File::Basename;
BEGIN {
	use_ok('Cv');
}
use Data::Dumper;

my$scale = 1/4;
my $NUMBER = 100;
my $DELAY = 5;

my ($width, $height) = (1000*$scale, 700*$scale);
my ($width3, $height3) = ($width*3, $height*3);

# Load the source image
my $image = Cv->CreateImage( [$width, $height], IPL_DEPTH_8U, 3 )->Zero;

# Create a window
my $wndname = "Drawing Demo";
$image->NamedWindow($wndname, 1);
$image->ShowImage($wndname);
$image->WaitKey($DELAY);
my $rng = Cv->RNG;

my $line_type = CV_AA; # change it to 8 to see non-antialiased graphics

for (0 .. $NUMBER-1) {
	my $pt1 = [ $rng->RandInt % $width3  - $width,
			    $rng->RandInt % $height3 - $height ];
	my $pt2 = [ $rng->RandInt % $width3  - $width,
				$rng->RandInt % $height3 - $height ];

	$image->Line(-pt1 => $pt1, -pt2 => $pt2,
				 -color => &random_color($rng),
				 -thickness => $rng->RandInt % 10,
				 -line_type => $line_type, );
	$image->ShowImage($wndname);
	exit if (Cv->WaitKey($DELAY) >= 0);
}

for (0 .. $NUMBER-1) {
	my $pt1 = [ $rng->RandInt % $width3  - $width,
			    $rng->RandInt % $height3 - $height ];
	my $pt2 = [ $rng->RandInt % $width3  - $width,
				$rng->RandInt % $height3 - $height ];
	
	$image->Rectangle(-pt1 => $pt1, -pt2 => $pt2,
					  -color => &random_color($rng),
					  -thickness => $rng->RandInt % 10 - 1,
					  -line_type => $line_type, );
	$image->ShowImage($wndname);
	exit if (Cv->WaitKey($DELAY) >= 0);
}

for (0 .. $NUMBER-1) {
	my $pt1 = [ $rng->RandInt % $width3  - $width, 
				$rng->RandInt % $height3 - $height ];
	my $sz = [ $rng->RandInt % 200, $rng->RandInt % 200 ];
	my $angle = ($rng->RandInt % 1000) * 0.180;

	$image->Ellipse(-center => $pt1, -axes => $sz, -angle => $angle,
					-start_angle => $angle - 100, -end_angle => $angle + 200,
					-color => &random_color($rng),
					-thickness => $rng->RandInt % 10 - 1,
					-line_type => $line_type);
	$image->ShowImage($wndname);
	exit if (Cv->WaitKey($DELAY) >= 0);
}

for (0 .. $NUMBER-1) {	
	my $pts = [];
	foreach (0 .. 1) {
		my $pt;
		foreach (0 .. 2) {
			my $x = $rng->RandInt % $width3 - $width;
			my $y = $rng->RandInt % $height3 - $height;
			push(@$pt, [$x, $y]);
		}
		push(@$pts, $pt);
	}

	$image->PolyLine( -pts => $pts,
					  -is_closed => 1,
					  -color => &random_color($rng),
					  -thickness => $rng->RandInt % 10,
					  -line_type => $line_type,
					  );
	$image->ShowImage($wndname);
	exit if (Cv->WaitKey($DELAY) >= 0);
}

for (0 .. $NUMBER-1) {
	my $pts;
	foreach (0 .. 1) {
		my $pt;
		foreach (0 .. 2) {
			my $x = $rng->RandInt % $width3 - $width;
			my $y = $rng->RandInt % $height3 - $height;
			push(@$pt, [$x, $y]);
		}
		push(@$pts, $pt);
	}
	
	$image->FillPoly( -pts => $pts,
					  -color => &random_color($rng),
					  -line_type => $line_type,
					  );
	$image->ShowImage($wndname);
	exit if (Cv->WaitKey($DELAY) >= 0);
}

for (0 .. $NUMBER-1) {
	my $pt = [ $rng->RandInt % $width3 - $width,
			   $rng->RandInt % $height3 - $height];
	
	$image->Circle( -center => $pt,
					-radius => $rng->RandInt % 300,
					-color => &random_color($rng),
					-thickness => $rng->RandInt % 10 - 1,
					-line_type => $line_type
					);
	$image->ShowImage($wndname);
	exit if (Cv->WaitKey($DELAY) >= 0);
}

for (0 .. $NUMBER-1) {
	my $pt = [ $rng->RandInt % $width3 - $width,
			   $rng->RandInt % $height3 - $height];

	my $font = Cv->InitFont(-font_face => $rng->RandInt % 8,
							-hscale => $scale * ($rng->RandInt % 100) * 0.05 + 0.1,
							-vscale => $scale * ($rng->RandInt % 100) * 0.05 + 0.1,
							-shear =>  $scale * ($rng->RandInt % 5) * 0.1,
							-thickness => $scale * Cv->Round($rng->RandInt % 10),
							-line_type => $line_type
							);
	
	$font->PutText(-image => $image,
				   -text => "Testing text rendering!",
				   -org => $pt,
				   -color => &random_color($rng)
				   );
	$image->ShowImage($wndname);
	exit if (Cv->WaitKey($DELAY) >= 0);
}

my $font = Cv->InitFont(-font_face => CV_FONT_HERSHEY_COMPLEX,
						-hscale => 3*$scale, -vscale => 3*$scale,
						-shear => 0.0, -thickness => 5*$scale,
						-line_type => $line_type
						);
my ($w, $h, $b) = $font->GetTextSize(-text => "OpenCV forever!");
my $pt = [($width - $w) / 2, ($height + $h)/2];
my $image2 = $image->CloneImage;

for (0 .. 255-1) {
	$image2->SubS(-dst => $image, -value => scalar cvScalarAll($_));
	$font->PutText(-image => $image,
				   -text => "OpenCV forever!",
				   -org => $pt,
				   -color => CV_RGB(255, $_, $_)
					);
	$image->ShowImage($wndname);
	exit if (Cv->WaitKey($DELAY) >= 0);
}

# Wait for a key stroke; the same function arranges events processing
Cv->WaitKey(1000);
ok(1000);
exit;

sub random_color {
	my $rng = shift;
    my $icolor = $rng->RandInt;
	return CV_RGB($icolor&255, ($icolor>>8)&255, ($icolor>>16)&255);
}

