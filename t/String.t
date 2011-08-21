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


if (1) {
	my $stor = Cv::MemStorage->new();
	ok($stor->isa('Cv::MemStorage'));

	my $hw = "hello, world";
	my $s = $stor->allocString($hw);
	ok($s->isa('Cv::String'), "allocString");
	ok($s->can('ptr'), 'can(ptr)');
	is($s->ptr, $hw, 'ptr');
	ok($s->can('len'), 'can(len)');
	is($s->len, length($hw), "len");
}
