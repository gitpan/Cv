# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

#use Test::More qw(no_plan);
use Test::More tests => 13;
BEGIN {
	use_ok('Cv');
}

#########################

my @idx = (rand(100), rand(100), rand(100));
my ($y, $x) = ($idx[0], $idx[1]);
my ($row, $col) = ($idx[0], $idx[1]);

eval { cvIndex(); };
ok($@, "usage: w/o args");

eval { cvIndex(-idx1 => $idx[1]); };
ok($@, "usage: w/o -idx0");

sub check_1index {
	my $p = shift;
	$p->[0] == $idx[0];
}

sub check_2index {
	my $p = shift;
	$p->[0] == $idx[0] && $p->[1] == $idx[1];
}

sub check_index {
	my $p = shift;
	$p->[0] == $idx[0] && $p->[1] == $idx[1] && $p->[2] == $idx[2];
}


my $s = cvIndex($idx[0]);
ok(check_1index($s), 'array 0');

$s = cvIndex($idx[0], $idx[1]);
ok(check_2index($s), 'array 01');

$s = cvIndex($idx[0], $idx[1], $idx[2]);
ok(check_index($s), 'array 012');

$s = cvIndex([ $idx[0], $idx[1], $idx[2] ]);
ok(check_index($s), 'ref array');

$s = cvIndex(-idx0 => $idx[0], -idx1 => $idx[1], -idx2 => $idx[2]);
ok(check_index($s), 'hash idx');

$s = cvIndex(-row => $row, -col => $col);
ok(check_2index($s), 'hash row, col');

$s = cvIndex(-x => $x, -y => $y);
ok(check_2index($s), 'hash x, y');

$s = cvIndex({ -x => $x, -y => $y });
ok(check_2index($s), 'ref hash');

$s = cvIndex({ 'x' => $x, 'y' => $y });
ok(check_2index($s), 'ref hash w/o -');

my @list = cvIndex({ 'x' => $x, 'y' => $y });
ok(check_2index(\@list), 'list context');
