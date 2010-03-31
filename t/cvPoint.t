# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

# use Test::More qw(no_plan);
use Test::More tests => 15;
BEGIN {
	use_ok('Cv');
}

#########################

my ($x, $y, $z) = (rand(100), rand(100), rand(100));

eval { cvPoint(); };
ok($@, "usage: w/o args");

eval { cvPoint(-x => $x); };
ok($@, "usage: w/o y");

eval { cvPoint(-y => $y, -z => $z); };
ok($@, "usage: w/o x");

sub check_point_xy {
	my $r = shift;
	$r->[0] == $x && $r->[1] == $y;
}

sub check_point_xyz {
	my $r = shift;
	$r->[0] == $x && $r->[1] == $y && $r->[2] == $z;
}

my $pt = cvPoint($x, $y);
ok(check_point_xy($pt), 'array xy');

$pt = cvPoint($x, $y, $z);
ok(check_point_xy($pt), 'array xyz');

$pt = cvPoint([ $x, $y ]);
ok(check_point_xy($pt), 'ref array xy');

$pt = cvPoint([ $x, $y, $z ]);
ok(check_point_xyz($pt), 'ref array xyz');

$pt = cvPoint(-x => $x, -y => $y);
ok(check_point_xy($pt), 'hash xy');

$pt = cvPoint(-x => $x, -y => $y, -z => $z);
ok(check_point_xyz($pt), 'hash xyz');

$pt = cvPoint({ -x => $x, -y => $y });
ok(check_point_xy($pt), 'ref hash xy');

$pt = cvPoint({ -x => $x, -y => $y, -z => $z });
ok(check_point_xyz($pt), 'ref hash xyz');

$pt = cvPoint({ 'x' => $x, 'y' => $y });
ok(check_point_xy($pt), 'ref hash xy, w/o -');

$pt = cvPoint({ 'x' => $x, 'y' => $y, 'z' => $z });
ok(check_point_xyz($pt), 'ref hash xyz, w/o -');

my @list = cvPoint($x, $y);
ok(check_point_xy(\@list), 'list context');
