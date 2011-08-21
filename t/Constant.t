# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

#  Before `make install' is performed this script should be runnable with
#  `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

is(CV_8U, 0);
is(CV_8S, 1);
is(CV_16U, 2);
is(CV_16S, 3);
is(CV_32S, 4);
is(CV_32F, 5);
is(CV_64F, 6);

my @def = ();
my @unk = ();

foreach (keys %Cv::Constant::EXPORT_TAGS) {
	if ($_ <= cvVersion()) {
		push(@def, $_);
	} else {
		push(@unk, $_);
	}
}

# print STDERR "def $_\n" for @def;
# print STDERR "unk $_\n" for @unk;

foreach (map { @{ $Cv::Constant::EXPORT_TAGS{$_} } } @def) {
	no strict 'refs';
	eval { &$_ };
	print STDERR "def? $_\n" if ($@);
	ok(!$@);
}

foreach (map { @{ $Cv::Constant::EXPORT_TAGS{$_} } } @unk) {
	no strict 'refs';
	eval { &$_ };
	print STDERR "unk? $_\n" unless ($@);
	like($@, qr/Undefined subroutine/);
}
