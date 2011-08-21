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

my $src = Cv::Mat->new([ 3, 3 ], CV_8UC4);
$src->fill([0, 1, 2, 3]);
my $dst = $src->sum;
is($dst->[0], 0 * 9);
is($dst->[1], 1 * 9);
is($dst->[2], 2 * 9);
is($dst->[3], 3 * 9);
