#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;
use List::Util qw(max min);
use Data::Dumper;

# Load the source image. HighGUI use.
my $file_name = @ARGV > 0 ? shift : dirname($0).'/'."baboon.jpg";
my $src_image = Cv->LoadImage($file_name, CV_LOAD_IMAGE_GRAYSCALE) or 
    die "Image was not loaded.\n";
my $dst_image = $src_image->CloneImage;
my $hist_image = Cv->new([320, 200], 8, 1);

my $hist_size = 64;
my $ranges = [0, 256];
my $hist = Cv->CreateHist(
	-sizes => [$hist_size],
	-ranges => [$ranges],
	-type => CV_HIST_ARRAY,
	);
my $lut = Cv->CreateMat(
	-rows => 1,
	-cols => 256,
	-type => CV_8UC1
	);

my $brightness = 100;
my $contrast = 100;
my $dst_win = Cv->NamedWindow("image")
	->CreateTrackbar(-name => "brightness",
					 -value => \$brightness,
					 -count => 200,
					 -callback => \&update_brightcont,
	)
	->CreateTrackbar(-name => "contrast",
					 -value => \$contrast,
					 -count => 200,
					 -callback => \&update_brightcont,
	);
my $hist_win = Cv->NamedWindow("histogram");

&update_brightcont;
Cv->WaitKey;

# brightness/contrast callback function
sub update_brightcont {
	my $brightness = $brightness - 100;
	my $contrast = $contrast - 100;
	
	# The algorithm is by Werner D. Streidt
	# (http://visca.com/ffactory/archives/5-99/msg00021.html)
	if ($contrast > 0) {
		my $delta = 127 * $contrast / 100;
		my $a = 255 / (255 - $delta*2);
		my $b = $a * ($brightness - $delta);
		for (0..255) {
			my $v = Cv->Round($a*$_ + $b);
			$v = max(0, $v);
			$v = min(255, $v);
			$lut->SetD([$_], [$v]);
		}
	} else {
		my $delta = -128 * $contrast / 100;
		my $a = (256 - $delta*2) / 255.;
		my $b = $a * $brightness + $delta;
		for (0..255) {
			my $v = Cv->Round($a*$_ + $b);
			$v = max(0, $v);
			$v = min(255, $v);
			$lut->SetD([$_], [$v]);
		}
	}
	$dst_image = $src_image->LUT(-lut => $lut);
	
	$hist->CalcHist(-images => [$dst_image]);
	my $mm = $hist->GetMinMaxHistValue;
	if ($mm->{max}{val}) {
		$hist->ScaleHist(-scale => $hist_image->height/$mm->{max}{val});
	}
	# cvNormalizeHist( hist, 1000 );
	
	$hist_image = $hist_image->Zero->Not;
	my $bin_w = Cv->Round($hist_image->width/$hist_size);
	for (0..$hist_size-1) {
		my ($x, $y) = ($_*$bin_w, $hist_image->height);
		my $pt1 = [$x, $y];
		my $pt2 = [$x+$bin_w, $y - Cv->Round($hist->QueryHistValue([$_]))];
		$hist_image->Rectangle( -pt1 => $pt1, -pt2 => $pt2,
								-color => 'black', -thickness => -1,
								-line_type => 8, -shift => 0 );
	}
	$dst_win->ShowImage(-image => $dst_image);
	$hist_win->ShowImage(-image => $hist_image);
	
	$dst_image->Zero;
}
