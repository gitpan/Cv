#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;
use Data::Dumper;

my $filename = @ARGV > 0? shift : dirname($0).'/'."fruits.jpg";
my $img0 = Cv->LoadImage(-filename => $filename, -flags => 1)
    or die "$0: can't loadimage $filename\n";

print "Hot keys: \n",
    "\tESC - quit the program\n",
    "\tr - restore the original image\n",
    "\tw or SPACE - run watershed algorithm\n",
    "\t\t(before running it, roughly mark the areas on the image)\n",
    "\t  (before that, roughly outline several markers on the image)\n";

my $image_win = Cv->NamedWindow("image", 1);
my $watershed_win = Cv->NamedWindow("watershed transform", 1);

my $markers = $img0->new(
    -depth => IPL_DEPTH_32S, -channels => 1)->Zero;
my $marker_mask = $markers->new(
    -depth => IPL_DEPTH_8U)->Zero;
my $img = $img0->CloneImage
	->ShowImage($image_win);
my $wshed = $img0->CloneImage->Zero
	->ShowImage($watershed_win);

my $prev_pt = { 'x' => -1, 'y' => -1 };
$image_win->SetMouseCallback(-callback => \&on_mouse);

while (1) {
	my $c = Cv->WaitKey;
	if (($c & 0xffff) == 27 || ($c & 0xffff) == ord('q')) {
		last;
	} elsif (($c & 0xffff) == ord('r')) {
		$marker_mask->Zero;
		$img0->Copy(-dst => $img)
			->ShowImage($image_win);
	} elsif (($c & 0xffff) == ord('w') || ($c & 0xffff) == ord(' ')) {
		my $storage = Cv->CreateMemStorage(0);
		$markers->Zero;
		my $comp_count = 0;
		for (my $contour = Cv->FindContours(
				 -image => $marker_mask, -storage => $storage,
				 -mode => CV_RETR_CCOMP,
				 -method => CV_CHAIN_APPROX_SIMPLE);
			 $contour; $contour = $contour->h_next) {
			my $color = [ $comp_count + 1, $comp_count + 1, $comp_count + 1 ];
			$contour->Draw(-image => $markers,
						   -external_color => $color, -hole_color => $color,
						   -max_level => -1, -thickness => -1, -line_type => 8);
			$comp_count++;
		}
		
		my $color_tab = Cv->CreateMat(1, 256, 16)->Zero;
		$color_tab->SetD([ 0 ], [ 0, 0, 0 ]);
		$color_tab->SetD([ 1 ], [ 255, 255, 255 ]);
		foreach (2 .. $comp_count + 1) {
			$color_tab->SetD([ $_ ], [ 180*rand() + 50, 180*rand() + 50,
									   180*rand() + 50 ]);
		}
		
		my $wshed =
			$img0->Watershed(-markers => $markers)
			->ConvertScale(
				-scale => 1, -shift => 1,
				-dst => $markers->new(-depth => 8));
		$img0->CvtColor(CV_BGR2GRAY)->CvtColor(CV_GRAY2BGR)
			->AddWeighted(-src2 => $wshed->CvtColor(CV_GRAY2BGR)
						  ->LUT(-lut => $color_tab),
						  -alpha => 0.5, -beta => 0.5, -gamma => 0.0)
			->ShowImage($watershed_win);
	}
}


sub on_mouse {
    my ($event, $x, $y, $flags, $param) = @_;
    return unless $img;
    if ($event == CV_EVENT_LBUTTONUP || !($flags & CV_EVENT_FLAG_LBUTTON)) {
        $prev_pt = { 'x' => -1, 'y' => -1 };
    } elsif ($event == CV_EVENT_LBUTTONDOWN) {
        $prev_pt = { 'x' => $x, 'y' => $y };
    } elsif ($event == CV_EVENT_MOUSEMOVE && ($flags & CV_EVENT_FLAG_LBUTTON)) {
        my $pt = { 'x' => $x, 'y' => $y };
        if ($prev_pt->{x} < 0) {
            $prev_pt = $pt;
		}
		# print STDERR Data::Dumper->Dump([$pt], [qw($pt)]);
        $marker_mask->Line(
			-pt1 => $prev_pt, -pt2 => $pt, -color => [ 255, 255, 255 ],
			-thickness => 5, -line_type => 8, -shift => 0);
        $img->Line(
			-pt1 => $prev_pt, -pt2 => $pt, -color => [ 255, 255, 255 ],
			-thickness => 5, -line_type => 8, -shift => 0);
		$img->ShowImage($image_win);
        $prev_pt = $pt;
    }
}
