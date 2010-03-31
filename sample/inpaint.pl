#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use File::Basename;

my $inpaint_mask = undef;
my $img0 = undef;
my $img = undef;
my $inpainted = undef;
my $prev_pt = cvPoint(-x => -1, -y => -1);

sub on_mouse {
	my ($event, $x, $y, $flags, $param) = @_;
    return unless $img;
    if ($event == CV_EVENT_LBUTTONUP || !($flags & CV_EVENT_FLAG_LBUTTON)) {
        $prev_pt = cvPoint(-x => -1, -y => -1);
	} elsif ($event == CV_EVENT_LBUTTONDOWN) {
        $prev_pt = cvPoint(-x => $x, -y => $y);
	} elsif ($event == CV_EVENT_MOUSEMOVE && ($flags & CV_EVENT_FLAG_LBUTTON)) {
        my $pt = cvPoint(-x => $x, -y => $y);
        if ($prev_pt->[0] < 0) {
            $prev_pt = $pt;
		}
		$inpaint_mask->Line(
			-pt1 => $prev_pt, -pt2 => $pt,
			-color => scalar cvScalarAll(255),
			-thickness => 5, -line_type => 8,
			-shift => 0,
			);
		$img->Line(
			-pt1 => $prev_pt, -pt2 => $pt,
			-color => scalar cvScalarAll(255),
			-thickness => 5, -line_type => 8,
			-shift => 0,
			);
        $prev_pt = $pt;
        $img->ShowImage(-window_name => "image");
    }
}


my $filename = @ARGV > 0? shift : dirname($0).'/'."fruits.jpg";
my $img0 = Cv->LoadImage(-filename => $filename, -flags => -1)
    or die "$0: can't loadimage $filename\n";

print "Hot keys: \n",
	"\tESC - quit the program\n",
	"\tr - restore the original image\n",
	"\ti or SPACE - run inpainting algorithm\n",
	"\t\t(before running it, paint something on the image)\n";
    
Cv->NamedWindow(-window_name => "image", -flags => 1)
	->SetMouseCallback(-callback => \&on_mouse);

$img = $img0->CloneImage;
$inpainted = $img0->CloneImage->Zero;
$inpaint_mask = $img->new(-channels => 1)->Zero;
$img->ShowImage(-window_name => "image");

while (1) {
	my $c = Cv->WaitKey;
	$c &= 0x7f if ($c >= 0);
	if ($c == 27) {
		last;
	}
	if ($c == ord('r')) {
		$inpaint_mask->Zero;
		#Cv->Copy(-src => $img0, -dst => $img);
		$img0->Copy(-dst => $img);
		$img->ShowImage("image");
	}
	if ($c == ord('i') || $c == ord(' ')) {
		Cv->NamedWindow(-window_name => "inpainted image", -flags => 1);
		$inpainted = $img->Inpaint(
			-mask => $inpaint_mask,	-inpaintRadius => 3,
			-flags => CV_INPAINT_TELEA);
		$inpainted->ShowImage(-window_name => "inpainted image");
	}
}
