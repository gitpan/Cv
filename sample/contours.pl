#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use lib qw(../blib/lib ../blib/arch);
use Cv;
use Data::Dumper;

my $levels = 3;
my $w = 500;
my $img = Cv->CreateImage([$w, $w], 8, 1)->Zero;

my $storage = Cv->CreateMemStorage(0);

for (my $i = 0; $i < 6; $i++) {

	my $dx = ($i%2)*250 - 30;
	my $dy = Cv->Floor($i/2)*150;

	if ($i == 0) {
		for (my $j = 0; $j <= 10; $j++) {
			my $angle = ($j+5)*CV_PI/21;
			$img->Line(-pt1 => [ Cv->Round($dx+100+$j*10-80*cos($angle)),
								 Cv->Round($dy+100-90*sin($angle)) ],
					   -pt2 => [ Cv->Round($dx+100+$j*10-30*cos($angle)),
								 Cv->Round($dy+100-30*sin($angle)) ],
					   -color => 'white');
		}
	}

	$img->Ellipse(-center => [$dx+150, $dy+100], -axes => [100, 70],
				   -color => 'white', -thickness => -1);
	$img->Ellipse(-center => [$dx+115, $dy+70], -axes => [30, 20],
				   -color => 'black', -thickness => -1);
	$img->Ellipse(-center => [$dx+185, $dy+70], -axes => [30, 20],
				   -color => 'black', -thickness => -1);
	$img->Ellipse(-center => [$dx+115, $dy+70], -axes => [15, 15],
				   -color => 'white', -thickness => -1);
	$img->Ellipse(-center => [$dx+185, $dy+70], -axes => [15, 15],
				   -color => 'white', -thickness => -1);
	$img->Ellipse(-center => [$dx+115, $dy+70], -axes => [5, 5],
				   -color => 'black', -thickness => -1);
	$img->Ellipse(-center => [$dx+185, $dy+70], -axes => [5, 5],
				   -color => 'black', -thickness => -1);
	$img->Ellipse(-center => [$dx+150, $dy+100], -axes => [10, 5],
				   -color => 'black', -thickness => -1);
	$img->Ellipse(-center => [$dx+150, $dy+150], -axes => [40, 10],
				   -color => 'black', -thickness => -1);
	$img->Ellipse(-center => [$dx+27, $dy+100], -axes => [20, 35],
				   -color => 'white', -thickness => -1);
	$img->Ellipse(-center => [$dx+273, $dy+100], -axes => [20, 35],
				   -color => 'white', -thickness => -1);
}

$img->ShowImage("image");

# comment this out if you do not want approximation
my $cont = Cv->FindContours(-image => $img, -mode => CV_RETR_TREE,
							-storage => $storage,
							-method => CV_CHAIN_APPROX_SIMPLE);
my $contours = $cont->ApproxPoly(-method => CV_POLY_APPROX_DP,
								 -parameter => 3, -parameter2 => 1);

my $win = Cv->NamedWindow("contours", 1)
	->CreateTrackbar(-name => 'levels+3', -value => \$levels, -count => 7,
					 -callback => \&on_trackbar);

&on_trackbar(0);
while (1) {
	my $c = Cv->WaitKey;
	$c &= 0x7f if ($c >= 0);
	last if $c == 27 || $c == ord('q');
}
exit 0;

sub on_trackbar {
	my $cnt_img = Cv->CreateImage([$w, $w], 8, 3)->Zero;
    my $_contours = $contours;
	my $_levels = $levels - 3;
    if ($_levels <= 0) { # get to the nearest face to make it look more funny
        $_contours = $_contours->h_next->h_next->h_next;
	}
    $_contours->Draw(-image => $cnt_img,
					 -external_color => [255, 0, 0],
					 -hole_color => [0, 255, 0],
					 -max_level => $_levels,
					 -thickness => 3,
					 -line_type => CV_AA);
    $cnt_img->ShowImage("contours");
}
