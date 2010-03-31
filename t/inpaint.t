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
my $img = Cv->LoadImage(-filename => $filename, -flags => -1)
    or die "$0: can't loadimage $filename\n";
my $inpainted = $img->CloneImage->Zero;
my $inpaint_mask = $img->new(-channels => 1)->Zero;

my $font = Cv->InitFont(-hscale => 5, -vscale => 5,
						-shear => 0.0, -thickness => 3,
						);
my ($x, $y) = (100, 200);
for (qw(H e l l o)) {
	my $size = $font->GetTextSize(-text => $_);
	$font->PutText(-img => $img, -text => $_, -org => [$x, $y]);
	$font->PutText(-img => $inpaint_mask, -text => $_, -org => [$x, $y]);
	$x += $size->[0];
	$img->ShowImage("image");
	Cv->WaitKey(100);
}

($x, $y) = (100, 300);
for (qw(O p e n C V)) {
	my $size = $font->GetTextSize(-text => $_);
	$font->PutText(-img => $img, -text => $_, -org => [$x, $y]);
	$font->PutText(-img => $inpaint_mask, -text => $_, -org => [$x, $y]);
	$x += $size->[0];
	$img->ShowImage("image");
	Cv->WaitKey(100);
}

$inpainted = $img->Inpaint(-mask => $inpaint_mask,
						   -inpaintRadius => 3,
						   -flags => CV_INPAINT_TELEA);
$inpainted->ShowImage("image");
Cv->WaitKey(1000);

