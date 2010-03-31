# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

# use Test::More qw(no_plan);
use Test::More tests => 10;
BEGIN {
	use_ok('Cv');
}

#########################

my ($width, $height) = (rand(100), rand(100));

eval { cvSize(); };
ok($@, "usage: w/o args");

eval { cvSize(-width => $width); };
ok($@, "usage: w/o -height");

eval { cvSize(-height => $height); };
ok($@, "usage: w/o -width");

sub check_size {
	my $r = shift;
	$r->[0] == $width && $r->[1] == $height;
}

my $sz = cvSize($width, $height);
ok(check_size($sz), 'array');

$sz = cvSize([ $width, $height ]);
ok(check_size($sz), 'ref array');

$sz = cvSize(-width => $width, -height => $height);
ok(check_size($sz), 'hash');

$sz = cvSize({ -width => $width, -height => $height });
ok(check_size($sz), 'ref hash');

$sz = cvSize({ 'width' => $width, 'height' => $height });
ok(check_size($sz), 'ref hash w/o -');

my @list = cvSize($width, $height);
ok(check_size(\@list), 'list context');
