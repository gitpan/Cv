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

# (1) Cv->Func is calling cvFunc
# (2) Cv->func is calling cvFunc
# (3) Cv->func is calling Cv::Func

if (1) {
	my @av;
	no warnings;
	local *{Cv::cvTest} = sub { @av = ('cvTest', @_); };
	Cv->Test(my $x = rand, my $y = rand);
	is(scalar @av - 1, 2, "ac");
	is($av[0], "cvTest", "callee");
	is($av[1], $x, "x");
	is($av[2], $y, "y");
}

if (2) {
	my @av;
	no warnings;
	local *{Cv::cvTest} = sub { @av = ('cvTest', @_); };
	Cv->test(my $x = rand, my $y = rand);
	is(scalar @av - 1, 2, "ac");
	is($av[0], "cvTest", "callee");
	is($av[1], $x, "x");
	is($av[2], $y, "y");
}
