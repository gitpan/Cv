# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

# use Test::More qw(no_plan);
use Test::More tests => 6;
BEGIN {
	use_ok('Cv');
}

#########################

my ($type, $max_iter, $epsilon) = (CV_TERMCRIT_ITER, rand(1), rand(1));

eval { cvTermCriteria(); };
ok($@, "usage: w/o args");

eval { cvTermCriteria(-max_iter => $max_iter, -epsilon => $epsilon); };
ok($@, "usage: w/o -type");

eval { cvTermCriteria(-type => $type, -epsilon => $epsilon); };
ok($@, "usage: w/o -max_iter");

eval { cvTermCriteria(-type => $type, -max_iter => $max_iter); };
ok($@, "usage: w/o -epsilon");

my $p = cvTermCriteria(
	-type => CV_TERMCRIT_ITER,
	-max_iter => $max_iter,
	-epsilon => $epsilon,
	);
ok($p->[0] == $type && $p->[1] == $max_iter && $p->[2] == $epsilon);
