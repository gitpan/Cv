# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
#use Test::More tests => 17;
use Test::Output;
use File::Basename;
use Time::HiRes qw(gettimeofday);
use Data::Dumper;
BEGIN {
	use_ok('Cv');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $img = Cv->CreateImage(-size => [ 320, 240 ], -depth => 8, -channels => 1);

my $win = Cv->NamedWindow(-name => 'win', -flags => 0);
ok($win, 'NamedWindow 1');

$win->ShowImage($img);
$win->SetMouseCallback(
	-callback => sub {
		print STDERR join(', ', @_), "\n";
	},
	-param => \0);
my $win2 = Cv->NamedWindow(-name => 'win', -flags => 0);
ok($win2, 'NamedWindow 2');
ok($win2 == $win, 'NamedWindow 2.2');
my $win3 = Cv->NamedWindow(-window_name => 'win', -flags => 0);
ok($win3, 'NamedWindow 3');
ok($win3 == $win, 'NamedWindow 3.2');
eval { Cv->NamedWindow(-flags => undef); };
ok($@, 'NamedWindow 5');

my $hnd = $win->GetWindowHandle;
ok($hnd, 'GetWindowHandle');
ok($win->GetWindowHandle(-name => 'win'), 'GetWindowHandle 2');
ok($win->GetWindowHandle(-window_name => 'win'), 'GetWindowHandle 3');
ok(!$win->GetWindowHandle(-name => 'null'), 'GetWindowHandle 4');
eval { $win->GetWindowHandle(-name => undef); };
ok($@, 'GetWindowHandle 6');

eval { Cv->GetWindowName };
ok($@, 'Cv->GetWindowName');
ok($win->GetWindowName eq 'win', 'GetWindowName');
ok($win->GetWindowName($hnd) eq 'win', 'GetWindowName 2');

my $fruits = Cv->LoadImage(
    -filename => dirname($0).'/'."fruits.jpg",
    -flags => CV_LOAD_IMAGE_COLOR);
ok($fruits, 'LoadImage');
$win->ShowImage($fruits);
$win->WaitKey(1000);

#stderr_like(sub { $fruits->ShowImage }, qr/can\'t/, 'ShowImage');
#$fruits->NamedWindow('Cv')->ShowImage;
$fruits->NamedWindow('Cv')->show;
$win->WaitKey(1000);
my $t0 = gettimeofday;
$fruits->WaitKey(1000);
my $t1 = gettimeofday;
$win->WaitKey(1000);
my $t2 = gettimeofday;
Cv->WaitKey(1000);
my $t3 = gettimeofday;
ok(abs(abs($t1 - $t0) - 1) < 0.1, "waitkey1");
ok(abs(abs($t2 - $t1) - 1) < 0.1, "waitkey2");
ok(abs(abs($t3 - $t2) - 1) < 0.1, "waitkey3");
$fruits->DestroyWindow;

my ($x, $y) = (100, 100);
foreach (1..30) {
	$win->MoveWindow(-x => $x, -y => $y);
	$win->WaitKey(100);
	$x++; $x++;
	$y++; $y++;
}

my ($w, $h) = (320, 240);
foreach (1..30) {
	$win->ResizeWindow(-width => $w, -height => $h);
	$win->WaitKey(100);
	$w++; $w++;
	$h++; $h++;
}

$win->DestroyAllWindows;
