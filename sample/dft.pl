#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;

my $filename = @ARGV > 0 ? shift : dirname($0).'/'."lena.jpg";
my $im = Cv->LoadImage($filename, CV_LOAD_IMAGE_GRAYSCALE) or 
	die "Image was not loaded.\n";

my $realInput      = Cv->CreateImage([$im->GetSize], IPL_DEPTH_64F, 1);
my $imaginaryInput = Cv->CreateImage([$im->GetSize], IPL_DEPTH_64F, 1)->Zero;
my $complexInput   = Cv->CreateImage([$im->GetSize], IPL_DEPTH_64F, 2);

Cv->Scale(-src => $im, -dst => $realInput, -scale => 1.0, -shift => 0.0);
Cv->Merge(-src0 => $realInput, -src1 => $imaginaryInput, -dst => $complexInput);

my $dft_M = Cv->GetOptimalDFTSize($im->height - 1);
my $dft_N = Cv->GetOptimalDFTSize($im->width  - 1);

my $dft_A = Cv->CreateMat(-rows => $dft_M, -cols => $dft_N, -type => CV_64FC2);
my $image_Re = Cv->CreateImage([$dft_N, $dft_M], IPL_DEPTH_64F, 1);
my $image_Im = Cv->CreateImage([$dft_N, $dft_M], IPL_DEPTH_64F, 1);

# copy A to dft_A and pad dft_A with zeros
$complexInput->Copy(
	-dst => $dft_A->GetSubRect(
		 -submat => my $tmp = $im->CloneImage,
		 -rect => [0, 0, $im->width, $im->height]),
	);
if ($dft_A->cols > $im->width) {
	$dft_A->GetSubRect(
		-submat => $tmp,
		-rect => [ $im->width, 0, $dft_A->cols - $im->width, $im->height ])
		->Zero;
}

# no need to pad bottom part of dft_A with zeros because of
# use nonzero_rows parameter in cvDFT() call below

$dft_A = $dft_A->DFT(
	-flags => CV_DXT_FORWARD,
	-nonzero_rows => $complexInput->height);

$im->ShowImage("win");

# Split Fourier in real and imaginary parts
$dft_A->Split($image_Re, $image_Im, undef, undef);

# Compute the magnitude of the spectrum Mag = sqrt(Re^2 + Im^2)
$image_Re = Cv
	->Add(-src1 => $image_Re->Pow(2),
		  -src2 => $image_Im->Pow(2))
	->Pow(0.5)
	
# Compute log(1 + Mag)
	->AddS(-value => scalar cvScalarAll(1.0))
	->Log;

# Rearrange the quadrants of Fourier image so that the origin is at
# the image center
&cvShiftDFT;

$image_Re->MinMaxLoc(-min_val => \(my $min), -max_val => \(my $max));
if (my $d = $max - $min) {
	$image_Re =	$image_Re
		->Scale(-scale => 1 / $d, -shift => -$min / $d);
}
$image_Re->ShowImage("magnitude");

Cv->WaitKey;
exit 0;

# Rearrange the quadrants of Fourier image so that the origin is at
# the image center
# src & dst arrays of equal size & type
sub cvShiftDFT {
	my $src = $image_Re;
	my $dst = $image_Re;

    if ($dst->width  != $src->width ||
		$dst->height != $src->height){
        Cv->Error(-status => CV_StsUnmatchedSizes,
				  -func_name => "cvShiftDFT",
				  -err_msg => "Source and Destination arrays must have equal sizes",
				  -fine_name => __FILE__,
				  -line => __LINE__,
			);
    }

    my $cx = $src->width/2;
    my $cy = $src->height/2; # image center
	my $type = $src->GetElemType;
	
	my $tmp = Cv->CreateMat(-rows => $cy, -cols => $cx, -type => $type);
	my $q1  = Cv->CreateMat(-rows => $cy, -cols => $cx, -type => $type);
	my $q2  = Cv->CreateMat(-rows => $cy, -cols => $cx, -type => $type);
	my $q3  = Cv->CreateMat(-rows => $cy, -cols => $cx, -type => $type);
	my $q4  = Cv->CreateMat(-rows => $cy, -cols => $cx, -type => $type);
	my $d1  = Cv->CreateMat(-rows => $cy, -cols => $cx, -type => $type);
	my $d2  = Cv->CreateMat(-rows => $cy, -cols => $cx, -type => $type);
	my $d3  = Cv->CreateMat(-rows => $cy, -cols => $cx, -type => $type);
	my $d4  = Cv->CreateMat(-rows => $cy, -cols => $cx, -type => $type);

	$src->GetSubRect(-submat => $q1, -rect => [0,     0, $cx, $cy]);
	$src->GetSubRect(-submat => $q2, -rect => [$cx,   0, $cx, $cy]);
	$src->GetSubRect(-submat => $q3, -rect => [$cx, $cy, $cx, $cy]);
	$src->GetSubRect(-submat => $q4, -rect => [0,   $cy, $cx, $cy]);
	$src->GetSubRect(-submat => $d1, -rect => [0,     0, $cx, $cy]);
	$src->GetSubRect(-submat => $d2, -rect => [$cx,   0, $cx, $cy]);
	$src->GetSubRect(-submat => $d3, -rect => [$cx, $cy, $cx, $cy]);
	$src->GetSubRect(-submat => $d4, -rect => [0,   $cy, $cx, $cy]);

    if ($src != $dst) {
        unless (CV_ARE_TYPES_EQ( $q1, $d1 )) {
            Cv->Error(-status => CV_StsUnmatchedFormats,
					  -func_name => "cvShiftDFT",
					  -err_msg => "Source and Destination arrays must have the same format",
					  -file_name => __FILE__,
					  -line => __LINE__
				);
        }
        $q3->Copy(-dst => $d1);
        $q4->Copy(-dst => $d2);
        $q1->Copy(-dst => $d3);
        $q2->Copy(-dst => $d4);
    } else {
        $q3->Copy(-dst => $tmp);
        $q1->Copy(-dst => $q3);
        $tmp->Copy(-dst => $q1);
        $q4->Copy(-dst => $tmp);
        $q2->Copy(-dst => $q4);
        $tmp->Copy(-dst => $q2);
    }
}
