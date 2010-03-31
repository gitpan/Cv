# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
#use Test::More tests => 35;
use Test::Output;
BEGIN {
	use_ok('Cv');
}

use File::Basename;
use List::Util qw(max min);
use Data::Dumper;

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $img = Cv->LoadImage(dirname($0).'/'."baboon.jpg");
my $gray = $img->CvtColor(CV_RGB2GRAY);
my $dst = Cv->CreateImage([320, 240], 8, 3)->SetZero;

my $hist = Cv::Histogram->new(-sizes => [256], -type => CV_HIST_ARRAY);
ok($hist, 'Cv::Histogram->new');

# ------------------------------------------------------------
#  CreateHist - Creates histogram
# ------------------------------------------------------------
{
	ok(Cv->CreateHist(-sizes => [256], -type => CV_HIST_ARRAY),
	   'CreateHist(Cv->CreateHist)');
	
	eval { Cv::Histogram->new };
	like($@, qr/usage:/, 'Cv::Histogram->new(usage)');
	eval { Cv::Histogram->new(-type => CV_HIST_ARRAY) };
	like($@, qr/usage:/, 'Cv::Histogram->new(usage)');
}

# ------------------------------------------------------------
#  CalcHist - Calculates histogram of image(s)
# ------------------------------------------------------------
{
	$hist->CalcHist(-images => [$gray]);
	ok($hist, 'CalcHist');
	eval { $hist->CalcHist };
	like($@, qr/usage:/, 'CalcHist(usage)');
}

# ------------------------------------------------------------
#  GetMinMaxHistValue - Finds minimum and maximum histogram bins
# ------------------------------------------------------------
{
	my $mm = $hist->GetMinMaxHistValue;
	ok($mm, 'GetMinMaxHistValue');
	ok(defined $mm->{max}, 'GetMinMaxHistValue {max}');
	ok(defined $mm->{max}{val}, 'GetMinMaxHistValue {max}{val}');
	ok(defined $mm->{min}, 'GetMinMaxHistValue {min}');
	ok(defined $mm->{min}{val}, 'GetMinMaxHistValue {min}{val}');
	
	if ($mm->{max}{val}) {
		eval { $hist->ScaleHist(-src => undef) };
		like($@, qr/usage:/, 'ScaleHist(usage)');
		$hist = $hist->ScaleHist(-scale => $dst->GetSize->[1]/$mm->{max}{val});
		$hist->Scale(-scale => $dst->GetSize->[1]/$mm->{max}{val});
	}
}

# ------------------------------------------------------------
#  QueryHistValue_*D - Queries value of histogram bin
# ------------------------------------------------------------
{
	sub rand_int { int(rand($_[0])); }

	my ($w, $h) = (320, 240);
	my @bin_size = (256, 256, 256);
	my @planes = map { Cv->new([$w, $h], 8, 1) } (0..2);
	my @values = (rand_int(255), rand_int(255), rand_int(255)); 
	$planes[0]->Set([ $values[0] ]);
	$planes[1]->Set([ $values[1] ]);
	$planes[2]->Set([ $values[2] ]);

	my $h1 = Cv::Histogram->new(1, [ $bin_size[0] ], CV_HIST_ARRAY)
		->CalcHist(-images => [ $planes[0] ]);
	is($h1->QueryHistValue([ $values[0] ]), $w*$h, 'QueryHistValue(1D)');

	my $h2 = Cv::Histogram->new(2, [ @bin_size[0..1] ], CV_HIST_ARRAY)
		->CalcHist(-images => [ @planes[0..1] ]);
	is($h2->QueryHistValue([ @values[0..1] ]), $w*$h, 'QueryHistValue(2D)');

	my $h3 = Cv::Histogram->new(3, [ @bin_size[0..2] ], CV_HIST_ARRAY)
		->CalcHist(-images => [ @planes[0..2] ]);
	is($h3->QueryHistValue([ @values[0..2] ]), $w*$h, 'QueryHistValue(3D)');

	eval { $v1 = $h1->QueryHistValue };
	ok($@, 'QueryHistValue(usage)');
	eval { $v1 = $h1->QueryHistValue([1, 1, 1, 1]) };
	ok($@, 'QueryHistValue(usage)');
}

 SKIP: {
	 skip "CopyHist has bugs...", 1
		 if (&CV_MAJOR_VERSION == 2);
# ------------------------------------------------------------
#  CopyHist - Copies histogram
# ------------------------------------------------------------
{
	my $copy = $hist->CopyHist;
	is(blessed $copy, "Cv::Histogram", 'CopyHist');
	ok($copy->CalcHist(-images => [ $gray ]), 'CopyHist');
	$copy = $hist->Copy;
	is(blessed $copy, "Cv::Histogram", 'CopyHist');
	eval { $copy->CopyHist(-dst => undef) };
	like($@, qr/usage:/, 'CopyHist(usage)');
}


# ------------------------------------------------------------
#  ThreshHist - Thresholds histogram
# ------------------------------------------------------------
{
	my $copy = $hist->CopyHist->CalcHist(-images => [ $gray ]);
	$copy->ThreshHist(1);
	ok($copy, 'ThreshHist');
	ok($copy->Thresh(0.5), 'Thresh');
	eval { $copy->ThreshHist };
	like($@, qr/usage:/, 'ThreshHist(usage)');
}

# ------------------------------------------------------------
#  NormalizeHist - Normalizes histogram
# ------------------------------------------------------------
{
	my $copy = $hist->CopyHist->CalcHist(-images => [ $gray ]);
	$copy->NormalizeHist(1);
	ok($copy, 'NormalizeHist');
	ok($copy->Normalize(0.5), 'Normalize');
	eval { $copy->NormalizeHist };
	like($@, qr/usage:/, 'NormalizeHist(usage)');
}

# ------------------------------------------------------------
#  CompareHist - Compares two dense histograms
# ------------------------------------------------------------
{
	my $copy1 = $hist->CopyHist->CalcHist(-images => [ $gray ]);
	my $copy2 = $hist->CopyHist->CalcHist(-images => [ $gray->PyrDown ]);
	my $d = $copy1->CompareHist($copy2, CV_COMP_CORREL);
	ok($d, 'CompareHist');
	ok($copy1->Compare($copy2, CV_COMP_CORREL), 'Compare');
	eval { $copy1->CompareHist };
	like($@, qr/usage:/, 'CompareHist(usage)');
}

# ------------------------------------------------------------
#  ClearHist - Clears histogram
# ------------------------------------------------------------
{
	my $copy = $hist->CopyHist->CalcHist(-images => [ $gray ]);
	my $b = $copy->QueryHistValue([ 100 ]);
	$copy->ClearHist;
	my $a = $copy->QueryHistValue([ 100 ]);
	ok($b > 0 && $a == 0, 'ClearHist');

	$copy->CalcHist(-images => [ $gray ]);
	$b = $copy->QueryHistValue([ 100 ]);
	$copy->Clear;
	$a = $copy->QueryHistValue([ 100 ]);
	ok($b > 0 && $a == 0, 'Clear');
}

# ------------------------------------------------------------
#  CalcBackProject - Calculates back projection
# ------------------------------------------------------------
{
	my $copy = $hist->CopyHist->CalcHist(-images => [ $gray ]);
	my $backproject = $copy->CalcBackProject([$gray]);
	is(blessed $backproject, "Cv::Image", "CalcBackProject");

	eval { $copy->CalcBackProject; };
	like($@, qr/usage:/, "CalcBackProject)usage)");
}
}								# SKIP END


my @planes = map { Cv->new(scalar $img->GetSize, $img->depth, 1) } (0..2);
$img->Split(-dst => \@planes);

my @hists = map {
	Cv->CreateHist(-sizes => [256], -type => CV_HIST_ARRAY)
		->Calc(-images => [$_])
	} @planes;

my ($width, $height) = (256, 200);
my @himages = map { Cv->new([$width, $height], 8, 3)->Zero->Not } (0..2);
my @mm = map { $_->GetMinMaxHistValue } @hists;

map {
	$hists[$_]->ScaleHist(-scale => $height/$mm[$_]->{max}{val})
		if $mm[$_]->{max}{val};
} (0..2);

my $bin = Cv->Round($width/256);
for my $i (0..255) {
	my ($x, $y) = ($i*$bin, $height);
	my $pt1 = [$x, $y];
	my @pt2 = map { [$x+$bin, $y - $hists[$_]->QueryHistValue([$i])] } (0..2);
	$himages[0]->Rectangle($pt1, $pt2[0], [$i, 0, 0] );
	$himages[1]->Rectangle($pt1, $pt2[1], [0, $i, 0] );
	$himages[2]->Rectangle($pt1, $pt2[2], [0, 0, $i] );
}

$dst = Cv->new([$width, $height*3], 8, 3);
for (0..2) {
	my $roi = [0, $height*$_, $width, $height];
	$himages[$_]->Copy($dst->SetImageROI($roi));
}
$dst->ResetImageROI;
$dst->ShowImage('Histogram');
$img->ShowImage('Image');
Cv->WaitKey(1000);

