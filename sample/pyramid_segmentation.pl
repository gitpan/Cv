#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;
use Data::Dumper;

my $level = 4;
my $src = undef;
my $seg = undef;

my $filename = @ARGV > 0? shift : dirname($0).'/'."fruits.jpg";
my $image = Cv->LoadImage(-filename => $filename, -flags => 1)
    or die "$0: can't loadimage $filename\n";

$image->SetImageROI([ 0, 0,
					  $image->width  & -(1 << $level),
					  $image->height & -(1 << $level),
					]);

Cv->NamedWindow("Source", 0);
$src = $image->CloneImage
    ->ShowImage("Source");
$seg = $image->CloneImage;

# segmentation of the color image
my ($threshold1, $threshold2) = (255, 30);

sub on_segment {
    my $block_size = 1000;
    $seg = $src->PyrSegmentation(
		-level => $level,
		-threshold1 => $threshold1 + 1,
		-threshold2 => $threshold2 + 1,
	);
    $seg->ShowImage("Segmentation");
}

Cv->NamedWindow("Segmentation", 0)
	->CreateTrackbar(-name => "Threshold1", -value => \$threshold1,
					 -count => 255, -callback => \&on_segment)
	->CreateTrackbar(-name => "Threshold2", -value => \$threshold2,
					 -count => 255, -callback => \&on_segment);
$seg->ShowImage("Segmentation");

&on_segment;
Cv->WaitKey(0);
