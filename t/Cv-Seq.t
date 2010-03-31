# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
#use Test::More tests => 8;
use Test::Output;
use Test::File;

use POSIX; 
use File::Basename;
use Data::Dumper;

BEGIN {
	use_ok('Cv');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $image = Cv->LoadImage(dirname($0).'/'."pic3.png");
ok($image, 'LoadImage');
my $storage = Cv->CreateMemStorage;
my $gray = $image->CvtColor(CV_RGB2GRAY);
my $canny = $gray->Canny(-dst => $gray->new);
my $contour_tree = $canny->FindContours(
    -mode => CV_RETR_CCOMP, -storage => $storage);
$contour_tree->Draw(-image => $image->clone, -max_level => 1, -thickness => -1,
		    -external_color => [ rand(255), rand(255), rand(255) ],
		    -hole_color => [ rand(255), rand(255), rand(255) ],)
    ->ShowImage("CV_RETR_CCOMP");

my $i = 0;
for (my $contour = $canny->FindContours(-storage => $storage);
     $contour; $contour = $contour->h_next) {
    $contour->Draw(-image => $image, -max_level => 0, -thickness => 3,
		   -external_color => [ rand(255), rand(255), rand(255) ],
		   -hole_color => CV_RGB(255, 255, 255));
    $image->ShowImage("CV_RETR_LIST");
    last if Cv->WaitKey(100) >= 0;

    $i++;
}

eval { Cv::Seq->h_next(undef) };
like($@, qr/usage/, "h_next(usage)");
eval { Cv::Seq->h_prev(undef) };
like($@, qr/usage/, "h_prev(usage)");
eval { Cv::Seq->v_next(undef) };
like($@, qr/usage/, "v_next(usage)");
eval { Cv::Seq->v_prev(undef) };
like($@, qr/usage/, "v_prev(usage)");

eval { Cv::Seq->header_size(undef) };
like($@, qr/usage/, "header_size(usage)");
eval { Cv::Seq->elem_size(undef) };
like($@, qr/usage/, "elem_size(usage)");
eval { Cv::Seq->total(undef) };
like($@, qr/usage/, "total(usage)");

eval { Cv::Seq->Push(undef, undef) };
like($@, qr/usage/, "Push(usage)");
eval { Cv::Seq->Pop(undef) };
like($@, qr/usage/, "Pop(usage)");
eval { Cv::Seq->Unshift(undef, undef) };
like($@, qr/usage/, "Unshift(usage)");
eval { Cv::Seq->Shift(undef) };
like($@, qr/usage/, "Shift(usage)");


my $seq = Cv::Seq::Point->new(-storage => $storage);
$seq->Push([1, 2]);
$seq->Push([2, 3]);
my $p = $seq->Pop;
ok($p->[0] == 2, 'pop');
$seq->Unshift([3, 4]);
my $r = $seq->Shift;
ok($r->[0] == 3, 'shift');

ok(1);
