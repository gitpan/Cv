# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

# use Test::More qw(no_plan);
use Test::More tests => 12;
BEGIN {
	use_ok('Cv');
}

#########################

my ($x, $y, $width, $height) = (rand(100), rand(100), rand(100), rand(100));

eval { cvRect(); };
ok($@, "usage: w/o args");

eval { cvRect(-y => $y, -width => $width, -height => $height); };
ok($@, "usage: w/o -x");

eval { cvRect(-x => $x, -width => $width, -height => $height); };
ok($@, "usage: w/o -y");

eval { cvRect(-x => $x, -y => $y, -height => $height); };
ok($@, "usage: w/o -width");

eval { cvRect(-x => $x, -y => $y, -width => $width); };
ok($@, "usage: w/o -height");

sub check_rect {
	my $r = shift;
	$r->[0] == $x && $r->[1] == $y && $r->[2] == $width && $r->[3] == $height;
}

my $rt = cvRect($x, $y, $width, $height);
ok(check_rect($rt), 'array');

$rt = cvRect([ $x, $y, $width, $height ]);
ok(check_rect($rt), 'ref array');

$rt = cvRect(-x => $x, -y => $y, -width => $width, -height => $height);
ok(check_rect($rt), 'hash');

$rt = cvRect({ -x => $x, -y => $y, -width => $width, -height => $height });
ok(check_rect($rt), 'ref hash');

$rt = cvRect({ 'x' => $x, 'y' => $y, 'width' => $width, 'height' => $height });
ok(check_rect($rt), 'ref hash w/o -');

my @list = cvRect($x, $y, $width, $height);
ok(check_rect($rt), 'list context');
