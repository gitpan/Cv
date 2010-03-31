# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
#use Test::More tests => 16;
use Test::Output;
use Test::File;
BEGIN {
	use_ok('Cv');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $image = Cv->CreateImage(-size => [ 320, 240 ], -depth => 8, -channels => 3);
ok($image, 'CreateImage');
$image->Set(-value => [ 0, 0, 0 ]);

my $text = "hello, world";

# ------------------------------------------------------------
#  InitFont - Initializes font structure
#  GetTextSize - Retrieves width and height of text string
# ------------------------------------------------------------
my $font = Cv->InitFont(-scale => undef, -vscale => undef, -hscale => undef);
ok($font, 'InitFont(scale)');
my $size = $font->GetTextSize(-text => $text);

 SKIP: {
	skip "The size might depend on the platform...", 1 if (1);

	my ($ew, $eh) = map { $_ * 0.1 } $font->GetTextSize(-text => $text);

	my $fn2 = Cv->InitFont(-scale => undef, -vscale => 0.5, -hscale => undef);
	ok($fn2, 'InitFont(scale)2.1');
	my $sz2 = $fn2->GetTextSize(-text => $text);
	ok(abs($sz2->[0] - $size->[0]) < $ew, 'InitFont(scale)2.2');
	ok(abs($sz2->[1] - $size->[1]) < $eh, 'InitFont(scale)2.3');

	my $fn3 = Cv->InitFont(-scale => undef, -vscale => undef, -hscale => 0.5);
	ok($fn3, 'InitFont(scale)3.1');
	my $sz3 = $fn3->GetTextSize(-text => $text);
	ok(abs($sz3->[0] - $size->[0]) < $ew, 'InitFont(scale)3.2');
	ok(abs($sz3->[1] - $size->[1]) < $eh, 'InitFont(scale)3.3');
	
	my $fn4 = Cv->InitFont(-scale => 0.5, -vscale => undef, -hscale => undef);
	ok($fn4, 'InitFont(scale)4.1');
	my $sz4 = $fn4->GetTextSize(-text => $text);
	ok(abs($sz4->[0]*2 - $size->[0]) < $ew + 2, 'InitFont(scale)4.2');
	ok(abs($sz4->[1]*2 - $size->[1]) < $eh + 2, 'InitFont(scale)4.3');
	# print STDERR "sz4 = ($sz4->[0], $sz4->[1]), size = ($size->[0], $size->[1])\n";

	my $fn5 = Cv->InitFont(-scale => undef, -vscale => 0.50, -hscale => 0.25);
	ok($fn5, 'InitFont(scale)5.1');
	my $sz5 = $fn5->GetTextSize(-text => $text);
	ok(abs($sz5->[0]*4 - $size->[0]) < $ew + 4, 'InitFont(scale)5.2');
	ok(abs($sz5->[1]*2 - $size->[1]) < $eh + 2, 'InitFont(scale)5.3');
}

# ------------------------------------------------------------
#  PutText - Draws text string
# ------------------------------------------------------------
my $org = [ ($image->width - $size->[0]) / 2, ($image->height - $size->[1]) / 2 ];
$font->PutText(-img => $image, -text => $text, -org => $org);

# ------------------------------------------------------------
#  GetTextSize with -overstrike (and -ov)
# ------------------------------------------------------------
my $sz1 = $font->GetTextSize(-text => $text, -overstrike => 1);
my $sz2 = $font->GetTextSize(-text => $text, -ov => 1);

# ------------------------------------------------------------
#  PutText with -overstrike (and -ov)
# ------------------------------------------------------------
$org->[1] += $size->[1]*1.5;
$font->PutText(-img => $image, -text => $text, -org => $org,
			   -color => CV_RGB(127, 255, 255), -overstrike => 1);

# ------------------------------------------------------------
#  PutText and SetOrigin (use -image instead of -img)
# ------------------------------------------------------------
$image->SetOrigin(1);
$font->PutText(-image => $image, -text => $text, -org => $org,
			   -color => CV_RGB(127, 255, 255), -ov => 1);

# ------------------------------------------------------------
#  Show results
# ------------------------------------------------------------
my $window = Cv->NamedWindow;
ok($image, 'cvNamedWindow');
$window->ShowImage($image);
$window->WaitKey(1000);
