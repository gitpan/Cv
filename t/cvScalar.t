# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

# use Test::More qw(no_plan);
use Test::More tests => 18;
BEGIN {
	use_ok('Cv');
}

#########################

my @val = (rand(100), rand(100), rand(100), rand(100));
my ($b, $g, $r) = ($val[0], $val[1], $val[2]);
my ($x, $y, $z) = ($val[0], $val[1], $val[2]);

sub check_1scalar {
	my $p = shift;
	$p->[0] == $val[0];
}

sub check_2scalar {
	my $p = shift;
	$p->[0] == $val[0] && $p->[1] == $val[1];
}

sub check_3scalar {
	my $p = shift;
	$p->[0] == $val[0] && $p->[1] == $val[1] && $p->[2] == $val[2];
}

sub check_scalar {
	my $p = shift;
	$p->[0] == $val[0] && $p->[1] == $val[1] && $p->[2] == $val[2] && $p->[3] == $val[3];
}

my $s = cvScalar($val[0]);
ok(check_1scalar($s), 'array 0');

$s = cvScalar($val[0], $val[1]);
ok(check_2scalar($s), 'array 01');

$s = cvScalar($val[0], $val[1], $val[2]);
ok(check_3scalar($s), 'array 012');

$s = cvScalar($val[0], $val[1], $val[2], $val[3]);
ok(check_scalar($s), 'array 0123');

$s = cvScalar([ $val[0], $val[1], $val[2], $val[3] ]);
ok(check_scalar($s), 'ref array 0123');

$s = cvScalar(-val0 => $val[0], -val1 => $val[1], -val2 => $val[2], -val3 => $val[3]);
ok(check_scalar($s), 'hash val');

$s = cvScalar(-r => $r, -g => $g, -b => $b);
ok(check_3scalar($s), 'hash');

$s = cvScalar({ 'r' => $r, 'g' => $g, 'b' => $b });
ok(check_3scalar($s), 'ref hash');

$s = cvScalar(-x => $x, -y => $y);
ok(check_2scalar($s), 'hash');

$s = cvScalar(-x => $x, -y => $y, -z => $z);
ok(check_3scalar($s), 'hash');

my @bgr = cvScalar(-r => $r, -g => $g, -b => $b);
ok(check_3scalar(\@bgr), 'list context');

$s = cvScalarAll($val[0]);
@val = ($val[0], $val[0], $val[0], $val[0]);
ok(check_scalar($s), 'cvScalarAll');

$s = cvRealScalar($val[0]);
@val = ($val[0], 0, 0, 0);
ok(check_scalar($s), 'cvRealScalar');

$s = cvScalar('black');
@val = (0, 0, 0);
ok(check_3scalar($s), 'black');

$s = cvScalar('blue');
#print STDERR Data::Dumper->Dump([$s], [qw($s)]);
@val = (255, 0, 0);
ok(check_3scalar($s), 'blue');

$s = cvScalar('green');
@val = (0, 255, 0);
ok(check_3scalar($s), 'green');

$s = cvScalar('red');
@val = (0, 0, 255);
ok(check_3scalar($s), 'red');
