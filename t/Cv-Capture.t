# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
use Test::Output;
#use Test::More tests => 1;
use File::Basename;
BEGIN {
	use_ok('Cv');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

SKIP: {
	my $flipbook = dirname($0).'/'."flipbook";
	skip "$flipbook: directory does not exist.", 1
		unless (-d $flipbook);
	my $capture = Cv->CreateFileCapture($flipbook);
	foreach (1..33) {
		last unless $capture->GrabFrame;
		$capture->RetrieveFrame->ShowImage;
		Cv->WaitKey(33);
	}
	foreach (1..33) {
		last unless my $frame = $capture->QueryFrame;
		$frame->ShowImage;
		Cv->WaitKey(33);
	}
}
