# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
#use Test::More tests => 2;
use Test::Output;
use Test::File;
use File::Basename;
use Data::Dumper;
BEGIN {
	use_ok('Cv');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $img = Cv->CreateImage(-size => [ 320, 240 ], -depth => 8, -channels => 1);

my $win = Cv->NamedWindow(-name => 'win', -flags => 0);
ok($win, 'NamedWindow');


# ------------------------------------------------------------
#  cvCreateTrackbar
# ------------------------------------------------------------
my $value1 = 0;
my $value2 = 0;
my $value3 = 100;
$win->CreateTrackbar(
	-name => "Trackbar1", -on_change => \&on_trackbar1, -value => $value1,
	);
$win->CreateTrackbar(
	-name => "Trackbar2", -callback => sub {
		$win->SetTrackbarPos(-name => "Trackbar1", -pos => 100 - $_[0]);
		#print STDERR "[on_trackbar 2]: pos = $_[0]\n";
	}, -value => $value2,
	);
$win->CreateTrackbar(
	-trackbar_name => "Trackbar3", -value => \$value3, -count => 1000,
	-on_change => undef, -callback => undef,
	);

eval { $win->SetTrackbarPos(-trackbar_name => 'unknown', -pos => 50) };
ok(1, 'undefined trackbar');

my @av = (-trackbar_name => 'Trackbar', -window_name => $win,
		  -value => 5, -count => 10, -on_change => sub { });
use Cv::Window;
eval { Cv::Window->CreateTrackbar(@av, -trackbar_name => undef) };
like($@, qr/usage:/, "CreateTrackbar(usage)");
eval { Cv::Window->CreateTrackbar(@av, -window_name => undef) };
like($@, qr/usage:/, "CreateTrackbar(usage)");
eval { Cv::Window->CreateTrackbar(@av, -value => undef) };
like($@, qr/usage:/, "CreateTrackbar(usage)");
eval { Cv::Window->CreateTrackbar(@av, -count => undef) };
like($@, qr/usage:/, "CreateTrackbar(usage)");
$win->ShowImage($img);
$win->WaitKey(1000);


# ------------------------------------------------------------
#  cvGetTrackbarPos
# ------------------------------------------------------------

my $pos1 = $win->GetTrackbarPos(-trackbar_name => "Trackbar");
my $pos2 = $win->GetTrackbarPos(-name => "Trackbar");
my $pos3 = $win->GetTrackbarPos(-trackbar_name => "Trackbar", -name => "Trackbar");
ok($pos1 == $pos2, 'GetTrackbarPos');
ok($pos2 == $pos3, 'GetTrackbarPos');

eval { Cv::Window->GetTrackbarPos(-name => undef, -window_name => undef) };
like($@, qr/usage:/, "GetTrackbarPos(usage)");
eval { $win->GetTrackbarPos(-trackbar_name => undef) };
like($@, qr/usage:/, "GetTrackbarPos(usage)");

# ------------------------------------------------------------
#  cvSetTrackbarPos
# ------------------------------------------------------------

eval { Cv::Window->SetTrackbarPos(-name => undef, -window_name => undef) };
like($@, qr/usage:/, "SetTrackbarPos(usage)");
eval { Cv::Window->SetTrackbarPos(-name => "Trackbar", -window_name => undef) };
like($@, qr/usage:/, "SetTrackbarPos(usage)");
eval { Cv::Window->SetTrackbarPos(-trackbar_name => "Trackbar", -window_name => undef) };
like($@, qr/usage:/, "SetTrackbarPos(usage)");
eval { $win->SetTrackbarPos(-trackbar_name => undef) };
like($@, qr/usage:/, "SetTrackbarPos(usage)");
eval { $win->SetTrackbarPos(-trackbar_name => "Trackbar") };
like($@, qr/usage:/, "SetTrackbarPos(usage)");

while (1) {
	my $pos = $win->GetTrackbarPos(-name => "Trackbar1");
	last if ($pos >= 100);
	$win->SetTrackbarPos(-name => "Trackbar1", -pos => $pos + 1);
	$win->ShowImage($img);
	my $c = $win->WaitKey($value3);
	last if ($c & 0x7f) == 27;
	last if ($c & 0x7f) == ord('q');
}

sub on_trackbar1 {
	$win->SetTrackbarPos(-name => "Trackbar2", -pos => 100 - $_[0]);
	#print STDERR "[on_trackbar 1]: pos = $_[0]\n";
}

sub on_trackbar2 {
	$win->SetTrackbarPos(-name => "Trackbar1", -pos => 100 - $_[0]);
	#print STDERR "[on_trackbar 2]: pos = $_[0]\n";
}
