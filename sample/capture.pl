#!/usr/bin/perl

use strict;
use lib qw(blib/lib blib/arch);
use lib qw(../blib/lib ../blib/arch);
use Cv;
use Data::Dumper;

my $capture;
if (@ARGV == 0) {
    $capture = Cv->CreateCameraCapture(0);
} elsif (@ARGV == 1 && $ARGV[0] =~ /^\d$/) {
    $capture = Cv->CreateCameraCapture($ARGV[0]);
} else {
    $capture = Cv->CreateFileCapture($ARGV[0]);
}
$capture or die "can't create capture";

my $font = Cv->InitFont(-scale => 0.85);
my $win = Cv->NamedWindow;
while (1) {
    last unless my $frame = $capture->QueryFrame;

    chop(my $date = `date`);
    my ($wday, $mon, $day, $time, $year) = split(/\s+/, $date);
    my ($hh, $mm, $ss) = split(/:/, $time);
    my $title = "$wday $mon " . sprintf("%02d:%02d", $hh, $mm) . " $day $year";
    my $clone = $frame->CloneImage or die "$0: can't clone";
    $font->PutText(-img => $clone, -text => $title,
		   -org => scalar cvPoint(-x => 5, -y => 20),
		   -color => CV_RGB(200, 255, 200), -overstrike => 1,
	);
    #$clone->SaveImage("capture/$day-$hh$mm$ss.png") or die "$0: can't save";
    $win->ShowImage($clone);

    my $c = $win->WaitKey(33);
    $c &= 0x7f if ($c >= 0);
    last if ($c == 27);
}
