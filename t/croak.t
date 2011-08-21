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

my $at;
eval {
	$at = sprintf("at %s line %d.", __FILE__, __LINE__ + 1);
	Cv->CreateImage({ not_an_array => 1 }, 8, 3);
};
# warn $@;
like($@, qr/$at/);
