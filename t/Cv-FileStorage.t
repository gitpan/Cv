# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
#use Test::More tests => 16;
use Test::Output;
use Test::File;
use File::Basename;
BEGIN {
	use_ok('Cv');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $filename = dirname($0).'/'."example.xml";

{
	my $fs = Cv->OpenFileStorage(-filename => $filename,
								 -flags => CV_STORAGE_WRITE);
	ok($fs, 'OpenFileStorage');
	
	my $mat = Cv->CreateMat(3, 3, CV_32F);
	$mat->SetIdentity;
	$fs->Write("A", $mat);
	file_exists_ok($filename, "Write");
}

{
	my $fs = Cv->OpenFileStorage(-filename => $filename,
								 -flags => CV_STORAGE_READ);
	my $param = $fs->GetFileNodeByName("A");
	my $a = $fs->Read($param);
	ok($a, 'Read');
}

unlink($filename);
