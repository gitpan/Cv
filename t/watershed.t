# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use Test::More qw(no_plan);
#use Test::More tests => 2;
BEGIN {
	use_ok('Cv');
}
use File::Basename;
use Data::Dumper;
use List::Util qw(min);

my $filename = @ARGV > 0? shift : dirname($0).'/'."fruits.jpg";
my $img0 = Cv->LoadImage(-filename => $filename, -flags => 1)
    or die "$0: can't loadimage $filename\n";

my $img = $img0->CloneImage;
my $markers = $img0->new(-depth => IPL_DEPTH_32S, -channels => 1)->Zero;
my $marker_mask = $img0->new(-depth => IPL_DEPTH_8U, -channels => 1)->Zero;

$img->ShowImage("image");
Cv->WaitKey(1000);

for (0..2) {
	my @center = (rand($img0->width), rand($img0->height));
	$img->Circle(
		-center => \@center,
		-radius => 20,
		-color => [ 255, 255, 255 ],
		-thickness => 5
		);
	$marker_mask->Circle(
		-center => \@center,
		-radius => 20,
		-color => [ 255, 255, 255 ],
		-thickness => 5
		);
	$img->ShowImage("image");
	Cv->WaitKey(1000);
}

my $storage = Cv->CreateMemStorage(0);
my $comp_count = 0;
for (my $contour = Cv->FindContours(
						-image => $marker_mask,
						-storage => $storage,
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
	$color_tab->SetD([ $_ ],
					 [ 180*rand() + 50, 180*rand() + 50, 180*rand() + 50 ]);
}

my $wshed =
	$img0->Watershed(-markers => $markers)
	->ConvertScale(-scale => 1, -shift => 1,
				   -dst => $markers->new(-depth => 8));
$img0->CvtColor(CV_BGR2GRAY)->CvtColor(CV_GRAY2BGR)
	->AddWeighted(-src2 => $wshed->CvtColor(CV_GRAY2BGR)
				  ->LUT(-lut => $color_tab),
				  -alpha => 0.5, -beta => 0.5, -gamma => 0.0)
	->ShowImage("watershed transform");
Cv->WaitKey(3000);
