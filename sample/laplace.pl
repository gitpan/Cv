#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use Data::Dumper;

my $capture = undef;
if (@ARGV == 0) {
	$capture = Cv->CreateCameraCapture(0);
} elsif (@ARGV == 1 && $ARGV[0] =~ /^\d$/) {
	$capture = Cv->CreateCameraCapture($ARGV[0]);
} else {
	$capture = Cv->CreateFileCapture($ARGV[0]);
}
$capture or die "Could not initialize capturing...\n";

#my $capture = Cv->CreateCameraCapture(0);
my $size = [$capture->QueryFrame->CloneImage->GetSize];
my $laplace = Cv->CreateImage( $size, IPL_DEPTH_16S, 1 );

my $sigma = 3;
my $smoothType = &CV_GAUSSIAN;
my $colorlaplace = Cv->CreateImage( $size, 8, 3 );
my $window = Cv->NamedWindow("Laplacian", 0)
	->CreateTrackbar( -name => "Sigma", -value => \$sigma, -count => 15 );

for (;;) {
	my $frame = $capture->QueryFrame->CloneImage;
	last unless ($frame);

	my $ksize = ($sigma * 5) | 1;
	$colorlaplace = $frame->Smooth( -smoothtype => $smoothType,
									-size1 => $ksize, -size2 => $ksize,
									-sigma1 => $sigma, -sigma2 => $sigma );
	my @planes = (
		$colorlaplace->new(-channels => 1),
		$colorlaplace->new(-channels => 1),
		$colorlaplace->new(-channels => 1),
		);
	$colorlaplace->Split(-dst => \@planes);
	for (0..2) {
		$planes[$_]->Laplace( -dst => $laplace, -aperture_size => 5 );
		$laplace->ConvertScaleAbs( -dst => $planes[$_],
								   -scale => ($sigma+1)*0.25,
								   -shift => 0 );
	}
	$colorlaplace->Merge( -src => \@planes );

	$window->ShowImage($colorlaplace);

	my $c = Cv->WaitKey(30);
	if (chr($c) eq ' ') {
		$smoothType = $smoothType == &CV_GAUSSIAN
			? &CV_BLUR : $smoothType == &CV_BLUR
			? &CV_MEDIAN : &CV_GAUSSIAN;
	}
	last if (chr($c) eq 'q' || chr($c) eq 'Q' || ($c & 255) == 27);
}

exit;
