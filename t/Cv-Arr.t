# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
#use Test::More tests => 8;
use Test::Output;
use Test::File;

use POSIX; 
use File::Basename;
use List::Util qw(min max);
use Data::Dumper;

BEGIN {
	use_ok('Cv');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $lena = dirname($0).'/'."lena.jpg";

sub rand_int {
	int(rand($_[0]));
}

sub cvscalar_is {
	my $p = shift;
	my $q = shift;
	my $text = shift;
	ok($p->[0] == $q->[0] && $p->[1] == $q->[1] && $p->[2] == $q->[2], $text);
}


# ############################################################
#  CXCORE
# ############################################################

# ============================================================
#  Operations on Arrays
# ============================================================

# ------------------------------------------------------------
#   SetZero, Zero - Clears the array
# ------------------------------------------------------------
{
	my $img = Cv->new($size, $depth, 3);
	my $c = int(rand(255));
	$img->Set([$c, $c, $c]);
	$img->Zero;
	my $val = $img->GetD([100, 100]);
	is($val->[0], 0, "Zero(0)");
	is($val->[1], 0, "Zero(1)");
	is($val->[2], 0, "Zero(2)");

	$img->Set([$c, $c, $c]);
	$img->SetZero;
	$val = $img->GetD([100, 100]);
	is($val->[0], 0, "SetZero(0)");
	is($val->[1], 0, "SetZero(1)");
	is($val->[2], 0, "SetZero(2)");
}

# ------------------------------------------------------------
#  Add - Computes per-element sum of two arrays
# ------------------------------------------------------------
{
	my $v1 = int(rand(100));
	my $v2 = int(rand(100));
	my $arr1 = Cv->new($size, $depth, 3)->Set([$v1, $v1, $v1]);
	my $arr2 = Cv->new($size, $depth, 3)->Set([$v2, $v2, $v2]);

	my $dst = $arr1->Add($arr2);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v1 + $v2, "Add(0)");
	is($r->[1], $v1 + $v2, "Add(1)");
	is($r->[2], $v1 + $v2, "Add(2)");

	$v1 = int(rand(100));
	$v2 = int(rand(100));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$dst = $arr1->Add([$arr1, $arr2]);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 + $v2)], "Add(3)");

	$v1 = int(rand(100));
	$v2 = int(rand(100));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$arr1->Add(-src => [$arr1, $arr2], -dst => $dst);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 + $v2)], "Add(4)");

	$v1 = int(rand(100));
	$v2 = int(rand(100));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Add(-src => [$arr1, $arr2], -mask => \0, -dst => $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 + $v2)], "Add(5)");

	$v1 = int(rand(100));
	$v2 = int(rand(100));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Add([$arr1, $arr2], \0, $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 + $v2)], "Add(6)");

	eval { $arr1->Add };
	like($@, qr/usage:/, "Add(usage)");
}

# ------------------------------------------------------------
#  AddS - Computes sum of array and scalar
# ------------------------------------------------------------
{
	my $arr = Cv->new($size, $depth, 3)->Zero;

	my $v = int(rand(100));
	my $dst = $arr->AddS([$v, $v, $v]);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v, "AddS(0)");
	is($r->[1], $v, "AddS(1)");
	is($r->[2], $v, "AddS(2)");

	$v = int(rand(100));
	$arr->AddS(-value => [$v, $v, $v], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [$v, $v, $v], "AddS(3)");

	$v = int(rand(100));
	$arr->Zero->AddS(-src => $arr, -value => [$v, $v, $v], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [$v, $v, $v], "AddS(4)");

	$v = int(rand(100));
	$arr->Zero->AddS(-src => $arr, -value => [$v, $v, $v], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [$v, $v, $v], "AddS(5)");

	$v = int(rand(100));
	$dst = Cv->Zero($arr)->AddS(-src => $arr, -value => [$v, $v, $v]);
	cvscalar_is([ $dst->GetD([100, 100]) ], [$v, $v, $v], "AddS(6)");

	$v = int(rand(100));
	Cv->Zero($arr)->AddS(-src => $arr, -value => [$v, $v, $v], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [$v, $v, $v], "AddS(7)");

	eval { $arr->AddS(-value => undef) };
	like($@, qr/usage:/, "AddS(usage)");
}

# ------------------------------------------------------------
#  AddWeighted - Computes weighted sum of two arrays
# ------------------------------------------------------------
{
	my $v1 = int(rand(100));
	my $v2 = int(rand(100));
	my $alpha = 0.5;
	my $beta = 0.5;
	my $gamma = 10;
	my $arr1 = Cv->new($size, $depth, 3)->Set([$v1, $v1, $v1]);
	my $arr2 = Cv->new($size, $depth, 3)->Set([$v2, $v2, $v2]);

	my $dst = $arr1->AddWeighted(-src2 => $arr2, -alpha => $alpha,
								 -beta => $beta, -gamma => $gamma);
	my $r = $dst->GetD([100, 100]);
	ok(abs($r->[0] - ($v1*$alpha + $v2*$beta + $gamma)) < 1, "AddWeighted(0)");
	ok(abs($r->[1] - ($v1*$alpha + $v2*$beta + $gamma)) < 1, "AddWeighted(1)");
	ok(abs($r->[2] - ($v1*$alpha + $v2*$beta + $gamma)) < 1, "AddWeighted(2)");

	eval { $arr1->AddWeighted };
	like($@, qr/usage:/, "AddWeighted(usage)");
}

# ------------------------------------------------------------
#  Sub - Computes per-element difference between two arrays
# ------------------------------------------------------------
{
	my $v1 = int(rand(100));
	my $v2 = int(rand(100));
	my $arr1 = Cv->new($size, IPL_DEPTH_16S, 3)->Set([$v1, $v1, $v1]);
	my $arr2 = Cv->new($size, IPL_DEPTH_16S, 3)->Set([$v2, $v2, $v2]);

	my $dst = $arr1->Sub($arr2);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v1 - $v2, "Sub(0)");
	is($r->[1], $v1 - $v2, "Sub(1)");
	is($r->[2], $v1 - $v2, "Sub(2)");

	$v1 = int(rand(100));
	$v2 = int(rand(100));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$dst = $arr1->Sub([$arr1, $arr2]);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 - $v2)], "Sub(3)");

	$v1 = int(rand(100));
	$v2 = int(rand(100));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$arr1->Sub(-src => [$arr1, $arr2], -dst => $dst);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 - $v2)], "Sub(4)");

	$v1 = int(rand(100));
	$v2 = int(rand(100));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Sub(-src => [$arr1, $arr2], -mask => \0, -dst => $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 - $v2)], "Sub(5)");

	$v1 = int(rand(100));
	$v2 = int(rand(100));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Sub([$arr1, $arr2], \0, $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 - $v2)], "Sub(6)");

	eval { $arr1->Sub };
	like($@, qr/usage:/, "Sub(usage)");
}

# ------------------------------------------------------------
#  SubS - Computes difference between array and scalar
# ------------------------------------------------------------
{
	my $v = int(rand(100));
	my $arr = Cv->new($size, IPL_DEPTH_16S, 3)->Zero;

	my $dst = $arr->SubS([$v, $v, $v]);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], -$v, "SubS(0)");
	is($r->[1], -$v, "SubS(1)");
	is($r->[2], -$v, "SubS(2)");

	$v = int(rand(100));
	$arr->SubS(-value => [$v, $v, $v], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [-$v, -$v, -$v], "SubS(3)");

	$v = int(rand(100));
	$arr->Zero->SubS(-src => $arr, -value => [$v, $v, $v], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [-$v, -$v, -$v], "SubS(4)");

	$v = int(rand(100));
	$arr->Zero->SubS(-src => $arr, -value => [$v, $v, $v], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [-$v, -$v, -$v], "SubS(5)");

	$v = int(rand(100));
	$dst = Cv->Zero($arr)->SubS(-src => $arr, -value => [$v, $v, $v]);
	cvscalar_is([ $dst->GetD([100, 100]) ], [-$v, -$v, -$v], "SubS(6)");

	$v = int(rand(100));
	Cv->Zero($arr)->SubS(-src => $arr, -value => [$v, $v, $v], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [-$v, -$v, -$v], "SubS(7)");

	eval { $arr->SubS(-value => undef) };
	like($@, qr/usage:/, "SubS(usage)");
}

# ------------------------------------------------------------
#  SubRS - Computes the difference between a scalar and an array.
# ------------------------------------------------------------
{
	my $v = int(rand(100));
	my $arr = Cv->new($size, IPL_DEPTH_16S, 3)->Zero;

	my $dst = $arr->SubRS([$v, $v, $v]);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v, "SubRS(0)");
	is($r->[1], $v, "SubRS(1)");
	is($r->[2], $v, "SubRS(2)");

	$v = int(rand(100));
	$arr->Zero->SubRS(-value => [$v, $v, $v], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [$v, $v, $v], "SubRS(3)");

	$v = int(rand(100));
	$arr->Zero->SubRS(-src => $arr, -value => [$v, $v, $v], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [$v, $v, $v], "SubRS(4)");

	$v = int(rand(100));
	$arr->Zero->SubRS(-src => $arr, -value => [$v, $v, $v], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [$v, $v, $v], "SubRS(5)");

	$v = int(rand(100));
	$dst = Cv->Zero($arr)->SubRS(-src => $arr, -value => [$v, $v, $v]);
	cvscalar_is([ $dst->GetD([100, 100]) ], [$v, $v, $v], "SubRS(6)");

	$v = int(rand(100));
	Cv->Zero($arr)->SubRS(-src => $arr, -value => [$v, $v, $v], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [$v, $v, $v], "SubRS(7)");

	eval { $arr->SubRS(-value => undef) };
	like($@, qr/usage:/, "SubRS(usage)");
}

# ------------------------------------------------------------
#  Mul - Calculates the per-element product of two arrays.
# ------------------------------------------------------------
{
	my $v1 = 10;
	my $v2 = 20;
	my $arr1 = Cv->new($size, $depth, 3)->Set([$v1, $v1, $v1]);
	my $arr2 = Cv->new($size, $depth, 3)->Set([$v2, $v2, $v2]);

	my $dst = $arr1->Mul($arr2);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v1 * $v2, "Mul(0)");
	is($r->[1], $v1 * $v2, "Mul(1)");
	is($r->[2], $v1 * $v2, "Mul(2)");

	$v1 = int(rand(254) + 1);
	$v2 = int(int(rand(255)) / $v1);
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$dst = $arr1->Mul([$arr1, $arr2]);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 * $v2)], "Mul(3)");

	$v1 = int(rand(254) + 1);
	$v2 = int(int(rand(255)) / $v1);
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$arr1->Mul(-src => [$arr1, $arr2], -dst => $dst);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 * $v2)], "Mul(4)");

	$v1 = int(rand(254) + 1);
	$v2 = int(int(rand(255)) / $v1);
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Mul(-src => [$arr1, $arr2], -scale => 1, -dst => $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 * $v2)], "Mul(5)");

	$v1 = int(rand(254) + 1);
	$v2 = int(int(rand(255)) / $v1);
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Mul([$arr1, $arr2], 1, $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 * $v2)], "Mul(6)");

	eval { $arr1->Mul };
	like($@, qr/usage:/, "Mul(usage)");
}

# ------------------------------------------------------------
#  Div - Performs per-element division of two arrays.
# ------------------------------------------------------------
{
	my $v2 = int(rand(15)) + 1;
	my $v1 = int(rand(15)) * $v2;
	my $arr1 = Cv->new($size, $depth, 3)->Set([$v1, $v1, $v1]);
	my $arr2 = Cv->new($size, $depth, 3)->Set([$v2, $v2, $v2]);

	my $dst = $arr1->Div($arr2);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v1 / $v2, "Div(0)");
	is($r->[1], $v1 / $v2, "Div(1)");
	is($r->[2], $v1 / $v2, "Div(2)");

	$v2 = int(rand(15)) + 1;
	$v1 = int(rand(15)) * $v2;
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$dst = $arr1->Div([$arr1, $arr2]);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 / $v2)], "Div(3)");

	$v2 = int(rand(15)) + 1;
	$v1 = int(rand(15)) * $v2;
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$arr1->Div(-src => [$arr1, $arr2], -dst => $dst);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 / $v2)], "Div(4)");

	$v2 = int(rand(15)) + 1;
	$v1 = int(rand(15)) * $v2;
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Div(-src => [$arr1, $arr2], -dst => $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 / $v2)], "Div(5)");

	$v2 = int(rand(15)) + 1;
	$v1 = int(rand(15)) * $v2;
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Div([$arr1, $arr2], 1, $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 / $v2)], "Div(6)");

	eval { $arr1->Div };
	like($@, qr/usage:/, "Div(usage)");
}

# ------------------------------------------------------------
#  And - Calculates per-element bit-wise conjunction of two arrays
# ------------------------------------------------------------
{
	my $v1 = 0xff;
	my $v2 = 0xf0;
	my $arr1 = Cv->new($size, $depth, 3)->Set([$v1, $v1, $v1]);
	my $arr2 = Cv->new($size, $depth, 3)->Set([$v2, $v2, $v2]);

	my $dst = $arr1->And($arr2);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v1 & $v2, "And(0)");
	is($r->[1], $v1 & $v2, "And(1)");
	is($r->[2], $v1 & $v2, "And(2)");

	$v1 = int(rand(255));
	$v2 = int(rand(255));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$dst = $arr1->And([$arr1, $arr2]);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 & $v2)], "And(3)");

	$v1 = int(rand(255));
	$v2 = int(rand(255));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$arr1->And(-src => [$arr1, $arr2], -dst => $dst);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 & $v2)], "And(4)");

	$v1 = int(rand(255));
	$v2 = int(rand(255));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->And(-src => [$arr1, $arr2], -mask => \0, -dst => $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 & $v2)], "And(5)");

	$v1 = int(rand(255));
	$v2 = int(rand(255));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->And([$arr1, $arr2], \0, $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 & $v2)], "And(6)");

	eval { $arr1->And };
	like($@, qr/usage:/, "And(usage)");
}

# ------------------------------------------------------------
#  AndS - Calculates per-element bit-wise conjunction of array and scalar
# ------------------------------------------------------------
{
	my $v1 = 0xff;
	my $v2 = 0x0f;
	my $arr = Cv->new($size, $depth, 3)->Set([$v1, $v1, $v1]);

	my $dst = $arr->AndS([$v2, $v2, $v2]);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v1 & $v2, "AndS(0)");
	is($r->[1], $v1 & $v2, "AndS(1)");
	is($r->[2], $v1 & $v2, "AndS(2)");

	$arr->Set([$v1, $v1, $v1]);
	$arr->AndS(-value => [$v2, $v2, $v2], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [cvScalarAll($v1 & $v2)], "AndS(3)");

	$arr->Set([$v1, $v1, $v1]);
	$arr->AndS(-src => $arr, -value => [$v2, $v2, $v2], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [cvScalarAll($v1 & $v2)], "AndS(4)");

	$arr->Set([$v1, $v1, $v1]);
	$arr->AndS(-src => $arr, -value => [$v2, $v2, $v2], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [cvScalarAll($v1 & $v2)], "AndS(5)");

	$arr->Set([$v1, $v1, $v1]);
	$dst = Cv->AndS(-src => $arr, -value => [$v2, $v2, $v2]);
	cvscalar_is([ $dst->GetD([100, 100]) ], [cvScalarAll($v1 & $v2)], "AndS(6)");

	$arr->Set([$v1, $v1, $v1]);
	Cv->AndS(-src => $arr, -value => [$v2, $v2, $v2], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [cvScalarAll($v1 & $v2)], "AndS(7)");

	eval { $arr->AndS(-value => undef) };
	like($@, qr/usage:/, "AndS(usage)");
}

# ------------------------------------------------------------
#  Or - Calculates per-element bit-wise disjunction of two arrays
# ------------------------------------------------------------
{
	my $v1 = 0x0f;
	my $v2 = 0xf0;
	my $arr1 = Cv->new($size, $depth, 3)->Set([$v1, $v1, $v1]);
	my $arr2 = Cv->new($size, $depth, 3)->Set([$v2, $v2, $v2]);

	my $dst = $arr1->Or($arr2);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v1 | $v2, "Or(0)");
	is($r->[1], $v1 | $v2, "Or(1)");
	is($r->[2], $v1 | $v2, "Or(2)");

	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$dst = $arr1->Or([$arr1, $arr2]);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 | $v2)], "Or(3)");

	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$arr1->Or(-src => [$arr1, $arr2], -dst => $dst);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 | $v2)], "Or(4)");

	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Or(-src => [$arr1, $arr2], -mask => \0, -dst => $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 | $v2)], "Or(5)");

	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Or([$arr1, $arr2], \0, $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 | $v2)], "Or(6)");

	eval { $arr1->Or };
	like($@, qr/usage:/, "Or(usage)");
}

# ------------------------------------------------------------
#  OrS - Calculates per-element bit-wise disjunction of array and scalar
# ------------------------------------------------------------
{
	my $v1 = 0xff;
	my $v2 = 0x0f;
	my $arr = Cv->new($size, $depth, 3)->Set([$v1, $v1, $v1]);

	my $dst = $arr->OrS([$v2, $v2, $v2]);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v1 | $v2, "OrS(0)");
	is($r->[1], $v1 | $v2, "OrS(1)");
	is($r->[2], $v1 | $v2, "OrS(2)");

	$arr->Set([$v1, $v1, $v1]);
	$arr->OrS(-value => [$v2, $v2, $v2], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [cvScalarAll($v1 | $v2)], "OrS(3)");

	$arr->Set([$v1, $v1, $v1]);
	$arr->OrS(-src => $arr, -value => [$v2, $v2, $v2], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [cvScalarAll($v1 | $v2)], "OrS(4)");

	$arr->Set([$v1, $v1, $v1]);
	$arr->OrS(-src => $arr, -value => [$v2, $v2, $v2], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [cvScalarAll($v1 | $v2)], "OrS(5)");

	$arr->Set([$v1, $v1, $v1]);
	$dst = Cv->OrS(-src => $arr, -value => [$v2, $v2, $v2]);
	cvscalar_is([ $dst->GetD([100, 100]) ], [cvScalarAll($v1 | $v2)], "OrS(6)");

	$arr->Set([$v1, $v1, $v1]);
	Cv->OrS(-src => $arr, -value => [$v2, $v2, $v2], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [cvScalarAll($v1 | $v2)], "OrS(7)");

	eval { $arr->OrS(-value => undef) };
	like($@, qr/usage:/, "OrS(usage)");
}

# ------------------------------------------------------------
#  Xor - Performs per-element bit-wise "exclusive or" operation on two
#        arrays
# ------------------------------------------------------------
{
	my $v1 = 0x0f;
	my $v2 = 0xf0;
	my $arr1 = Cv->new($size, $depth, 3)->Set([$v1, $v1, $v1]);
	my $arr2 = Cv->new($size, $depth, 3)->Set([$v2, $v2, $v2]);

	my $dst = $arr1->Xor($arr2);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v1 ^ $v2, "Xor(0)");
	is($r->[1], $v1 ^ $v2, "Xor(1)");
	is($r->[2], $v1 ^ $v2, "Xor(2)");

	$v1 = int(rand(255));
	$v2 = int(rand(255));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$dst = $arr1->Xor([$arr1, $arr2]);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 ^ $v2)], "Xor(3)");

	$v1 = int(rand(255));
	$v2 = int(rand(255));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	$arr1->Xor(-src => [$arr1, $arr2], -dst => $dst);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll($v1 ^ $v2)], "Xor(4)");

	$v1 = int(rand(255));
	$v2 = int(rand(255));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Xor(-src => [$arr1, $arr2], -dst => $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 ^ $v2)], "Xor(5)");

	$v1 = int(rand(255));
	$v2 = int(rand(255));
	$arr1->Set([$v1, $v1, $v1]);
	$arr2->Set([$v2, $v2, $v2]);
	Cv->Xor([$arr1, $arr2], \0, $arr1);
	cvscalar_is([$arr1->GetD([100, 100])], [cvScalarAll($v1 ^ $v2)], "Xor(6)");

	eval { $arr1->Xor };
	like($@, qr/usage:/, "Xor(usage)");
}

# ------------------------------------------------------------
#  XorS - Performs per-element bit-wise "exclusive or" operation on
#         array and scalar
# ------------------------------------------------------------
{
	my $v1 = 0xff;
	my $v2 = 0x0f;
	my $arr = Cv->new($size, $depth, 3)->Set([$v1, $v1, $v1]);

	my $dst = $arr->XorS([$v2, $v2, $v2]);
	my $r = $dst->GetD([100, 100]);
	is($r->[0], $v1 ^ $v2, "XorS(0)");
	is($r->[1], $v1 ^ $v2, "XorS(1)");
	is($r->[2], $v1 ^ $v2, "XorS(2)");

	$arr->Set([$v1, $v1, $v1]);
	$arr->XorS(-value => [$v2, $v2, $v2], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [cvScalarAll($v1 ^ $v2)], "XorS(3)");

	$arr->Set([$v1, $v1, $v1]);
	$arr->XorS(-src => $arr, -value => [$v2, $v2, $v2], -dst => $arr);
	cvscalar_is([ $arr->GetD([100, 100]) ], [cvScalarAll($v1 ^ $v2)], "XorS(4)");

	$arr->Set([$v1, $v1, $v1]);
	$arr->XorS(-src => $arr, -value => [$v2, $v2, $v2], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [cvScalarAll($v1 ^ $v2)], "XorS(5)");

	$arr->Set([$v1, $v1, $v1]);
	$dst = Cv->XorS(-src => $arr, -value => [$v2, $v2, $v2]);
	cvscalar_is([ $dst->GetD([100, 100]) ], [cvScalarAll($v1 ^ $v2)], "XorS(6)");

	$arr->Set([$v1, $v1, $v1]);
	Cv->XorS(-src => $arr, -value => [$v2, $v2, $v2], -dst => $dst);
	cvscalar_is([ $dst->GetD([100, 100]) ], [cvScalarAll($v1 ^ $v2)], "XorS(7)");

	eval { $arr->XorS(-value => undef) };
	like($@, qr/usage:/, "XorS(usage)");
}

# ------------------------------------------------------------
#  Not -  Performs per-element bit-wise inversion of array elements
# ------------------------------------------------------------
{
	my $v = 0x0f;
	my $arr = Cv->new($size, $depth, 3)->Set([$v, $v, $v]);

	my $dst = $arr->Not;
	my $r = $dst->GetD([100, 100]);
	is($r->[0], ~$v & 0x000000ff, "Not(0)");
	is($r->[1], ~$v & 0x000000ff, "Not(1)");
	is($r->[2], ~$v & 0x000000ff, "Not(2)");

	$arr->Set([$v, $v, $v]);
	$dst = $arr->Not(-src => $arr);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll(~$v & 0x000000ff)], "Not(3)");

	$arr->Set([$v, $v, $v]);
	$arr->Not(-src => $arr, -dst => $dst);
	cvscalar_is([$dst->GetD([100, 100])], [cvScalarAll(~$v & 0x000000ff)], "Not(4)");

	$arr->Set([$v, $v, $v]);
	$arr->Not(-src => $arr, -dst => $arr);
	cvscalar_is([$arr->GetD([100, 100])], [cvScalarAll(~$v & 0x000000ff)], "Not(5)");

	$arr->Set([$v, $v, $v]);
	$arr->Not($arr, $arr);
	cvscalar_is([$arr->GetD([100, 100])], [cvScalarAll(~$v & 0x000000ff)], "Not(6)");

	eval { $arr->Not(-src => undef) };
	like($@, qr/usage:/, "Not(usage)");
}

# ------------------------------------------------------------
#  Cmp - Performs per-element comparison of two arrays
# ------------------------------------------------------------
{
	my $pos1 = [0, 0];
	my $pos2 = [100, 100];
	my $pos3 = [200, 200];
	my ($v1, $v2) = (10, 20);
	my $arr1 = Cv->new($size, $depth, 1);
	my $arr2 = Cv->new($size, $depth, 1);

	# dst(I) = src1(I) < src2(I)
	$arr1->SetD($pos1, $v1);
	$arr2->SetD($pos1, $v2);
	# dst(I) = src1(I) == src2(I)
	$arr1->SetD($pos2, $v1);
	$arr2->SetD($pos2, $v1);
	# dst(I) = src1(I) > src2(I)
	$arr1->SetD($pos3, $v2);
	$arr2->SetD($pos3, $v1);

	my $true = 0xff;
	my $false = 0x00;
	my $dst = $arr1->Cmp(-src2 => $arr2, -cmp_op => CV_CMP_EQ);
	is($dst->GetD($pos1)->[0], $false, "Cmp(CV_CMP_EQ)");
	is($dst->GetD($pos2)->[0], $true, "Cmp(CV_CMP_EQ)");
	is($dst->GetD($pos3)->[0], $false, "Cmp(CV_CMP_EQ)");

	$dst = $arr1->Cmp(-src2 => $arr2, -cmp_op => CV_CMP_GT);
	is($dst->GetD($pos1)->[0], $false, "Cmp(CV_CMP_GT)");
	is($dst->GetD($pos2)->[0], $false, "Cmp(CV_CMP_GT)");
	is($dst->GetD($pos3)->[0], $true, "Cmp(CV_CMP_GT)");

	$dst = $arr1->Cmp(-src2 => $arr2, -cmp_op => CV_CMP_GE);
	is($dst->GetD($pos1)->[0], $false, "Cmp(CV_CMP_GE)");
	is($dst->GetD($pos2)->[0], $true, "Cmp(CV_CMP_GE)");
	is($dst->GetD($pos3)->[0], $true, "Cmp(CV_CMP_GE)");

	$dst = $arr1->Cmp(-src2 => $arr2, -cmp_op => CV_CMP_LT);
	is($dst->GetD($pos1)->[0], $true, "Cmp(CV_CMP_LT)");
	is($dst->GetD($pos2)->[0], $false, "Cmp(CV_CMP_LT)");
	is($dst->GetD($pos3)->[0], $false, "Cmp(CV_CMP_LT)");

	$dst = $arr1->Cmp(-src2 => $arr2, -cmp_op => CV_CMP_LE);
	is($dst->GetD($pos1)->[0], $true, "Cmp(CV_CMP_LE)");
	is($dst->GetD($pos2)->[0], $true, "Cmp(CV_CMP_LE)");
	is($dst->GetD($pos3)->[0], $false, "Cmp(CV_CMP_LE)");

	$dst = $arr1->Cmp(-src2 => $arr2, -cmp_op => CV_CMP_NE);
	is($dst->GetD($pos1)->[0], $true, "Cmp(CV_CMP_NE)");
	is($dst->GetD($pos2)->[0], $false, "Cmp(CV_CMP_NE)");
	is($dst->GetD($pos3)->[0], $true, "Cmp(CV_CMP_NE)");

	eval { $arr1->Cmp };
	like($@, qr/usage:/, "Cmp(usage)");
}

# ------------------------------------------------------------
#  CmpS - Performs per-element comparison of array and scalar
# ------------------------------------------------------------
{
	my $pos1 = [0, 0];
	my $pos2 = [100, 100];
	my $pos3 = [200, 200];
	my ($v1, $v2, $v3) = (10, 20, 30);
	my $arr = Cv->new($size, $depth, 1);
	$arr->SetD($pos1, $v1);
	$arr->SetD($pos2, $v2);
	$arr->SetD($pos3, $v3);

	my $true = 0xff;
	my $false = 0x00;
	my $dst = $arr->CmpS(-value => $v2, -cmp_op => CV_CMP_EQ);
	is($dst->GetD($pos1)->[0], $false, "CmpS(CV_CMP_EQ)");
	is($dst->GetD($pos2)->[0], $true, "CmpS(CV_CMP_EQ)");
	is($dst->GetD($pos3)->[0], $false, "CmpS(CV_CMP_EQ)");

	$dst = $arr->CmpS(-value => $v2, -cmp_op => CV_CMP_GT);
	is($dst->GetD($pos1)->[0], $false, "CmpS(CV_CMP_GT)");
	is($dst->GetD($pos2)->[0], $false, "CmpS(CV_CMP_GT)");
	is($dst->GetD($pos3)->[0], $true, "CmpS(CV_CMP_GT)");

	$dst = $arr->CmpS(-value => $v2, -cmp_op => CV_CMP_GE);
	is($dst->GetD($pos1)->[0], $false, "CmpS(CV_CMP_GE)");
	is($dst->GetD($pos2)->[0], $true, "CmpS(CV_CMP_GE)");
	is($dst->GetD($pos3)->[0], $true, "CmpS(CV_CMP_GE)");

	$dst = $arr->CmpS(-value => $v2, -cmp_op => CV_CMP_LT);
	is($dst->GetD($pos1)->[0], $true, "CmpS(CV_CMP_LT)");
	is($dst->GetD($pos2)->[0], $false, "CmpS(CV_CMP_LT)");
	is($dst->GetD($pos3)->[0], $false, "CmpS(CV_CMP_LT)");

	$dst = $arr->CmpS(-value => $v2, -cmp_op => CV_CMP_LE);
	is($dst->GetD($pos1)->[0], $true, "CmpS(CV_CMP_LE)");
	is($dst->GetD($pos2)->[0], $true, "CmpS(CV_CMP_LE)");
	is($dst->GetD($pos3)->[0], $false, "CmpS(CV_CMP_LE)");

	$dst = $arr->CmpS(-value => $v2, -cmp_op => CV_CMP_NE);
	is($dst->GetD($pos1)->[0], $true, "CmpS(CV_CMP_NE)");
	is($dst->GetD($pos2)->[0], $false, "CmpS(CV_CMP_NE)");
	is($dst->GetD($pos3)->[0], $true, "CmpS(CV_CMP_NE)");

	eval { $arr->CmpS };
	like($@, qr/usage:/, "CmpS(usage)");
}


# ------------------------------------------------------------
#  InRange - Checks that array elements lie between elements of two
#            other arrays
# ------------------------------------------------------------
{
	my $pos0 = [0, 0];
	my $pos1 = [50, 50];
	my $pos2 = [100, 100];
	my $pos3 = [150, 150];
	my $pos4 = [200, 200];
	my $v1 = 10;
	my $v2 = 20;
	my $v3 = 30;
	my $array = Cv->new($size, $depth, 1);
	my $lower = Cv->new($size, $depth, 1);
	my $upper = Cv->new($size, $depth, 1);

	# array(I) < lower(I)
	$array->SetD($pos0, $v1);
	$lower->SetD($pos0, $v2);
	$upper->SetD($pos0, $v3);

	# array(I) = lower(I)
	$array->SetD($pos1, $v1);
	$lower->SetD($pos1, $v1);
	$upper->SetD($pos1, $v3);

	# array(I) < upper(I)
	$array->SetD($pos2, $v2);
	$lower->SetD($pos2, $v1);
	$upper->SetD($pos2, $v3);

	# array(I) = upper(I)
	$array->SetD($pos3, $v3);
	$lower->SetD($pos3, $v1);
	$upper->SetD($pos3, $v3);

	# array(I) > upper(I)
	$array->SetD($pos4, $v3);
	$lower->SetD($pos4, $v1);
	$upper->SetD($pos4, $v2);

	my $true = 0xff;
	my $false = 0x00;
	my $dst = $array->InRange(-lower => $lower, -upper => $upper);
	is($dst->GetD($pos0)->[0], $false, "InRange");
	is($dst->GetD($pos1)->[0], $true,  "InRange");
	is($dst->GetD($pos2)->[0], $true,  "InRange");
	is($dst->GetD($pos3)->[0], $false, "InRange");
	is($dst->GetD($pos4)->[0], $false, "InRange");

	eval { $array->InRange };
	like($@, qr/usage:/, "InRange(usage)");
}

# ------------------------------------------------------------
#  InRangeS - Checks that array elements lie between two scalars
# ------------------------------------------------------------
{
	my $pos0 = [0, 0];
	my $pos1 = [50, 50];
	my $pos2 = [100, 100];
	my $pos3 = [150, 150];
	my $pos4 = [200, 200];
	my $v0 = 0;
	my $v1 = 10;
	my $v2 = 20;
	my $v3 = 30;
	my $v4 = 40;
	my $array = Cv->new($size, $depth, 1);
	my $lower = cvScalar($v1);
	my $upper = cvScalar($v3);
	
	$array->SetD($pos0, $v0);# array(I) < lower(I)
	$array->SetD($pos1, $v1);# array(I) = lower(I)
	$array->SetD($pos2, $v2);# array(I) < upper(I)
	$array->SetD($pos3, $v3);# array(I) = upper(I)
	$array->SetD($pos4, $v4);# array(I) > upper(I)

	my $true = 0xff;
	my $false = 0x00;
	my $dst = $array->InRangeS(-lower => $lower, -upper => $upper);
	is($dst->GetD($pos0)->[0], $false, "InRangeS");
	is($dst->GetD($pos1)->[0], $true,  "InRangeS");
	is($dst->GetD($pos2)->[0], $true,  "InRangeS");
	is($dst->GetD($pos3)->[0], $false, "InRangeS");
	is($dst->GetD($pos4)->[0], $false, "InRangeS");

	eval { $array->InRangeS(-lower => undef, -upper => undef) };
	like($@, qr/usage:/, "InRangeS(usage)");
}

# ------------------------------------------------------------
#  AbsDiff - Calculates absolute difference between two arrays
# ------------------------------------------------------------
{
	my @v1 = (rand_int(100), rand_int(100), rand_int(100));
	my @v2 = (rand_int(100), rand_int(100), rand_int(100));
	my $arr1 = Cv->new($size, $depth, 3)->Set(\@v1);
	my $arr2 = Cv->new($size, $depth, 3)->Set(\@v2);

	my $dst = $arr1->AbsDiff($arr2);
	my @pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], abs($v1[0] - $v2[0]), "AbsDiff(0)");
	is($dst->GetD(\@pos)->[1], abs($v1[1] - $v2[1]), "AbsDiff(1)");
	is($dst->GetD(\@pos)->[2], abs($v1[2] - $v2[2]), "AbsDiff(2)");

	@v1 = (rand_int(100), rand_int(100), rand_int(100));
	@v2 = (rand_int(100), rand_int(100), rand_int(100));
	$arr1->Set(\@v1);
	$arr2->Set(\@v2);
	$dst->Zero;
	$dst = $arr1->AbsDiff([$arr1, $arr2]);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], abs($v1[0] - $v2[0]), "AbsDiff(3)");
	is($dst->GetD(\@pos)->[1], abs($v1[1] - $v2[1]), "AbsDiff(4)");
	is($dst->GetD(\@pos)->[2], abs($v1[2] - $v2[2]), "AbsDiff(5)");

	@v1 = (rand_int(100), rand_int(100), rand_int(100));
	@v2 = (rand_int(100), rand_int(100), rand_int(100));
	$arr1->Set(\@v1);
	$arr2->Set(\@v2);
	$dst->Zero;
	$arr1->AbsDiff(-src => [$arr1, $arr2], -dst => $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], abs($v1[0] - $v2[0]), "AbsDiff(6)");
	is($dst->GetD(\@pos)->[1], abs($v1[1] - $v2[1]), "AbsDiff(7)");
	is($dst->GetD(\@pos)->[2], abs($v1[2] - $v2[2]), "AbsDiff(8)");

	@v1 = (rand_int(100), rand_int(100), rand_int(100));
	@v2 = (rand_int(100), rand_int(100), rand_int(100));
	$arr1->Set(\@v1);
	$arr2->Set(\@v2);
	$dst->Zero;
	Cv->AbsDiff(-src => [$arr1, $arr2], -dst => $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], abs($v1[0] - $v2[0]), "AbsDiff(9)");
	is($dst->GetD(\@pos)->[1], abs($v1[1] - $v2[1]), "AbsDiff(10)");
	is($dst->GetD(\@pos)->[2], abs($v1[2] - $v2[2]), "AbsDiff(11)");

	@v1 = (rand_int(100), rand_int(100), rand_int(100));
	@v2 = (rand_int(100), rand_int(100), rand_int(100));
	$arr1->Set(\@v1);
	$arr2->Set(\@v2);
	$dst->Zero;
	Cv->AbsDiff([$arr1, $arr2], $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], abs($v1[0] - $v2[0]), "AbsDiff(9)");
	is($dst->GetD(\@pos)->[1], abs($v1[1] - $v2[1]), "AbsDiff(10)");
	is($dst->GetD(\@pos)->[2], abs($v1[2] - $v2[2]), "AbsDiff(11)");

	eval { $arr1->AbsDiff };
	like($@, qr/usage:/, "AbsDiff(usage)");
}

# ------------------------------------------------------------
#  AbsDiffS - Calculates absolute difference between an array and a scalar.
# ------------------------------------------------------------
{
	my @v1 = (rand_int(100), rand_int(100), rand_int(100));
	my @v2 = (rand_int(100), rand_int(100), rand_int(100));
	my $src = Cv->new($size, $depth, 3)->Set(\@v1);

	my $dst = $src->AbsDiffS(\@v2);
	my @pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], abs($v1[0] - $v2[0]), "AbsDiffS(0)");
	is($dst->GetD(\@pos)->[1], abs($v1[1] - $v2[1]), "AbsDiffS(1)");
	is($dst->GetD(\@pos)->[2], abs($v1[2] - $v2[2]), "AbsDiffS(2)");

	$dst = $src->AbsDiffS(-value => \@v2, -src => $src);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], abs($v1[0] - $v2[0]), "AbsDiffS(6)");
	is($dst->GetD(\@pos)->[1], abs($v1[1] - $v2[1]), "AbsDiffS(7)");
	is($dst->GetD(\@pos)->[2], abs($v1[2] - $v2[2]), "AbsDiffS(8)");

	$src->AbsDiffS(-value => \@v2, -dst => $dst, -src => $src);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], abs($v1[0] - $v2[0]), "AbsDiffS(9)");
	is($dst->GetD(\@pos)->[1], abs($v1[1] - $v2[1]), "AbsDiffS(10)");
	is($dst->GetD(\@pos)->[2], abs($v1[2] - $v2[2]), "AbsDiffS(11)");

	Cv->AbsDiffS(-src => $src, -value => \@v2, -dst => $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], abs($v1[0] - $v2[0]), "AbsDiffS(9)");
	is($dst->GetD(\@pos)->[1], abs($v1[1] - $v2[1]), "AbsDiffS(10)");
	is($dst->GetD(\@pos)->[2], abs($v1[2] - $v2[2]), "AbsDiffS(11)");

	Cv->AbsDiffS(\@v2, $dst, $src);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], abs($v1[0] - $v2[0]), "AbsDiffS(12)");
	is($dst->GetD(\@pos)->[1], abs($v1[1] - $v2[1]), "AbsDiffS(13)");
	is($dst->GetD(\@pos)->[2], abs($v1[2] - $v2[2]), "AbsDiffS(14)");

	eval { $src->AbsDiffS };
	like($@, qr/usage:/, "AbsDiffS(usage)");
}


# ------------------------------------------------------------
#  Max - Finds per-element maximum of two arrays.
# ------------------------------------------------------------
{
	my $v1 = rand_int(100);
	my $v2 = rand_int(100);
	my $arr1 = Cv->new($size, $depth, 1)->Set($v1);
	my $arr2 = Cv->new($size, $depth, 1)->Set($v2);

	my $dst = $arr1->Max($arr2);
	my @pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], max($v1, $v2), "Max(0)");

	$dst = $arr1->Max([$arr1, $arr2]);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], max($v1, $v2), "Max(1)");

	$arr1->Max([$arr1, $arr2], $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], max($v1, $v2), "Max(2)");

	Cv->Max(-src => [$arr1, $arr2], -dst => $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], max($v1, $v2), "Max(3)");

	eval { $arr1->Max };
	like($@, qr/usage:/, "Max(usage)");
}


# ------------------------------------------------------------
#  MaxS - Finds per-element maximum of array and scalar.
# ------------------------------------------------------------
{
	my $value = rand_int(100);
	my $src = Cv->new($size, $depth, 1)->Zero;

	Cv->RNG(-1)->RandArr(
		-arr => $src,
		-dist_type => CV_RAND_NORMAL,
		-param1 => [0],
		-param2 => [255],
		);

	my $dst = $src->MaxS($value);
	my @pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], max($dst->GetD(\@pos)->[0], $value), "MaxS(0)");

	$src->MaxS($value, $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], max($dst->GetD(\@pos)->[0], $value), "MaxS(1)");

	$src->MaxS($value, $dst, $src);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], max($dst->GetD(\@pos)->[0], $value), "MaxS(2)");

	$src->MaxS(-value => $value, -dst => $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], max($dst->GetD(\@pos)->[0], $value), "MaxS(3)");

	Cv->MaxS(-value => $value, -dst => $dst, -src => $src);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], max($src->GetD(\@pos)->[0], $value), "MaxS(4)");

	Cv->MaxS($value, $dst, $src);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], max($src->GetD(\@pos)->[0], $value), "MaxS(5)");

	eval { $src->MaxS };
	like($@, qr/usage:/, "MaxS(usage)");
}


# ------------------------------------------------------------
#  Min - Finds per-element minimum of two arrays.
# ------------------------------------------------------------
{
	my $v1 = rand_int(100);
	my $v2 = rand_int(100);
	my $arr1 = Cv->new($size, $depth, 1)->Set($v1);
	my $arr2 = Cv->new($size, $depth, 1)->Set($v2);

	my $dst = $arr1->Min($arr2);
	my @pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], min($v1, $v2), "Min(0)");

	$dst = $arr1->Min([$arr1, $arr2]);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], min($v1, $v2), "Min(1)");

	$arr1->Min([$arr1, $arr2], $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], min($v1, $v2), "Min(2)");

	Cv->Min(-src => [$arr1, $arr2], -dst => $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], min($v1, $v2), "Min(3)");

	eval { Cv->Min(-src1 => $arr1, -dst => $dst) };
	like($@, qr/usage:/, "Min(usage)");
}

# ------------------------------------------------------------
#  MinS - Finds per-element minimum of an array and a scalar.
# ------------------------------------------------------------
{
	my $value = rand_int(100);
	my $src = Cv->new($size, $depth, 1)->Zero;

	Cv->RNG(-1)->RandArr(
		-arr => $src,
		-dist_type => CV_RAND_NORMAL,
		-param1 => [0],
		-param2 => [255],
		);

	my $dst = $src->MinS($value);
	my @pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], min($dst->GetD(\@pos)->[0], $value), "MinS(0)");

	$src->MinS($value, $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], min($dst->GetD(\@pos)->[0], $value), "MinS(1)");

	$src->MinS($value, $dst, $src);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], min($dst->GetD(\@pos)->[0], $value), "MinS(2)");

	$src->MinS(-value => $value, -dst => $dst);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], min($dst->GetD(\@pos)->[0], $value), "MinS(3)");

	Cv->MinS(-value => $value, -dst => $dst, -src => $src);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], min($src->GetD(\@pos)->[0], $value), "MinS(4)");

	Cv->MinS($value, $dst, $src);
	@pos = (rand_int($dst->height), rand_int($dst->width));
	is($dst->GetD(\@pos)->[0], min($src->GetD(\@pos)->[0], $value), "MinS(5)");

	eval { $src->MinS };
	like($@, qr/usage:/, "MinS(usage)");
}

#------------------------------------------------------------
# GetRow, GetRows
#------------------------------------------------------------
{
	my $arr = Cv->LoadImage($lena);
	my $submat = $arr->new(-size => [$arr->width, $arr->height/2]);

	$arr->GetRows(-start => 0, -end => $arr->height/2, -submat => $submat);
	my @pos = (rand_int($submat->height), rand_int($submat->width));
	is($submat->GetD(\@pos)->[0], $arr->GetD(\@pos)->[0], "GetRows(0)");
	is($submat->GetD(\@pos)->[1], $arr->GetD(\@pos)->[1], "GetRows(1)");
	is($submat->GetD(\@pos)->[2], $arr->GetD(\@pos)->[2], "GetRows(2)");

	my $row = rand_int($submat->width);
	my $col = rand_int($submat->width);
	$submat = $arr->GetRow(-row => $row);
	is($submat->GetD($col)->[0], $arr->GetD([$row, $col])->[0], "GetRow(0)");
	is($submat->GetD($col)->[1], $arr->GetD([$row, $col])->[1], "GetRow(1)");
	is($submat->GetD($col)->[2], $arr->GetD([$row, $col])->[2], "GetRow(2)");

#	eval { $arr->GetRows };
#	like($@, qr/usage:/, "GetRows(usage)");
#	eval { $arr->GetRow };
#	like($@, qr/usage:/, "GetRow(usage)");
}

#------------------------------------------------------------
#  GetCol, GetCols - Returns array column or column span
#------------------------------------------------------------
{
	my $arr = Cv->LoadImage($lena);
	my $submat = $arr->new(-size => [$arr->width/2, $arr->height]);

	$arr->GetCols(-start => 0, -end => $arr->width/2, -submat => $submat);
	my @pos = (rand_int($submat->height), rand_int($submat->width));
	is($submat->GetD(\@pos)->[0], $arr->GetD(\@pos)->[0], "GetCols(0)");
	is($submat->GetD(\@pos)->[1], $arr->GetD(\@pos)->[1], "GetCols(1)");
	is($submat->GetD(\@pos)->[2], $arr->GetD(\@pos)->[2], "GetCols(2)");

	my $row = rand_int($submat->width);
	my $col = rand_int($submat->width);
	$submat = $arr->GetCol(-col => $col);
	is($submat->GetD($row)->[0], $arr->GetD([$row, $col])->[0], "GetCol(0)");
	is($submat->GetD($row)->[1], $arr->GetD([$row, $col])->[1], "GetCol(1)");
	is($submat->GetD($row)->[2], $arr->GetD([$row, $col])->[2], "GetCol(2)");

#	eval { $arr->GetCols };
#	like($@, qr/usage:/, "GetCols(usage)");
#	eval { $arr->GetCol };
#	like($@, qr/usage:/, "GetCol(usage)");
}

# ------------------------------------------------------------
#  GetSubRect - Returns matrix header corresponding to the rectangular
#          sub-array of input image or matrix
# ------------------------------------------------------------
{
	my $arr = Cv->LoadImage($lena);
	my $submat = $arr->new(-size => [$arr->width/2, $arr->height/2]);
	my @rect = ($arr->width/4, $arr->height/4, $arr->width/2, $arr->height/2);

	$arr->GetSubRect(-rect => \@rect, -submat => $submat);
	my @pos1 = (rand_int($submat->height), rand_int($submat->width));
	my @pos2 = ($pos1[0] + $arr->height/4, $pos1[1] + $arr->width/4);
	is($submat->GetD(\@pos1)->[0], $arr->GetD(\@pos2)->[0], "GetSubRect(0)");
	is($submat->GetD(\@pos1)->[1], $arr->GetD(\@pos2)->[1], "GetSubRect(1)");
	is($submat->GetD(\@pos1)->[2], $arr->GetD(\@pos2)->[2], "GetSubRect(2)");

	eval { $arr->GetSubRect };
	like($@, qr/usage:/, "GetSubRect(usage)");
}

# ------------------------------------------------------------ 
#  GetElemType - Returns type of array elements
# ------------------------------------------------------------
{
	my @size = (320, 240);
	is(Cv->new(\@size, IPL_DEPTH_16S, 1)->GetElemType, CV_16SC1, "CV_16SC1");
	is(Cv->new(\@size, IPL_DEPTH_16S, 3)->GetElemType, CV_16SC3, "CV_16SC3");
	is(Cv->new(\@size, IPL_DEPTH_16U, 1)->GetElemType, CV_16UC1, "CV_16UC1");
	is(Cv->new(\@size, IPL_DEPTH_16U, 3)->GetElemType, CV_16UC3, "CV_16UC3");
	is(Cv->new(\@size, IPL_DEPTH_32F, 1)->GetElemType, CV_32FC1, "CV_32FC1");
	is(Cv->new(\@size, IPL_DEPTH_32F, 3)->GetElemType, CV_32FC3, "CV_32FC3");
	is(Cv->new(\@size, IPL_DEPTH_32S, 1)->GetElemType, CV_32SC1, "CV_32SC1");
	is(Cv->new(\@size, IPL_DEPTH_32S, 3)->GetElemType, CV_32SC3, "CV_32SC3");
	is(Cv->new(\@size, IPL_DEPTH_64F, 1)->GetElemType, CV_64FC1, "CV_64FC1");
	is(Cv->new(\@size, IPL_DEPTH_64F, 3)->GetElemType, CV_64FC3, "CV_64FC3");
	is(Cv->new(\@size, IPL_DEPTH_8S, 1)->GetElemType,  CV_8SC1,  "CV_8SC1");
	is(Cv->new(\@size, IPL_DEPTH_8S, 3)->GetElemType,  CV_8SC3,  "CV_8SC3");
	is(Cv->new(\@size, IPL_DEPTH_8U, 1)->GetElemType,  CV_8UC1,  "CV_8UC1");
	is(Cv->new(\@size, IPL_DEPTH_8U, 3)->GetElemType,  CV_8UC3,  "CV_8UC3");
}

# ------------------------------------------------------------ 
#  GetDims, GetDimSize - Return number of array dimensions and their sizes
# ------------------------------------------------------------
{
	my @size = (my $col = 320, my $row = 240);
	my $image = Cv->new(\@size, IPL_DEPTH_8U, 1);
	my @dims = $image->GetDims;
	is(scalar @dims,  2,  "GetDims");
	is($dims[0],  $row,  "GetDims(row)");
	is($dims[1],  $col,  "GetDims(col)");
	is($image->GetDimSize(0),  $row,  "GetDimSize(row)");
	is($image->GetDimSize(1),  $col,  "GetDimSize(col)");
}

# ------------------------------------------------------------
# Sobel - Calculates first, second, third or mixed image derivatives
# using extended Sobel operator
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena, CV_LOAD_IMAGE_GRAYSCALE);
	my @size = $img->GetSize;
	my $sobel = $img->Sobel->ConvertScaleAbs;
	#$sobel->ShowImage->WaitKey;
	eval { Cv->Sobel };
	ok($@, "Sobel(usage)");
}

# ------------------------------------------------------------
#  Laplace - Calculates Laplacian of the image
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena, CV_LOAD_IMAGE_COLOR);
	my @size = $img->GetSize;
	my $laplace = $img->Laplace->ConvertScaleAbs;
	#$laplace->ShowImage->WaitKey;
	eval { Cv->Laplace };
	ok($@, "Laplace(usage)");
}

# ------------------------------------------------------------
# Canny - Implements Canny algorithm for edge detection
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena, CV_LOAD_IMAGE_GRAYSCALE);
	my $canny = $img->Canny;
	#$canny->ShowImage->WaitKey;
	eval { Cv->Canny };
	ok($@, "Canny(usage)");
}

# ------------------------------------------------------------
#   Resize - Resizes image
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $resize = $img->Resize($img->new([$img->width/2, $img->height/2]));
	#$resize->ShowImage->WaitKey;
	eval { Cv->Resize };
	ok($@, "Resize(usage)");
}

# ------------------------------------------------------------
#  Reduce - Reduces matrix to a vector
# ------------------------------------------------------------
{
	my $s = (chr(255) x 1 . (chr(0) x (320 - 1))) x 16;
	my $gray = Cv->CreateImage([320, 16], 8, 1)->SetImageData($s);
	#$gray->ShowImage->WaitKey;
	my $reduce = $gray->Reduce(Cv->CreateImage([1, 16], IPL_DEPTH_32F, 1));
	my ($w, $h) = $reduce->GetSize;
	#print STDERR "($w, $h)\n";
	my $t = $reduce->GetImageData;
	my @data = unpack("f*", $t);
	my $n = @data;
	ok($n == 16, "Reduce");
	ok($data[0] == 255 && $data[1] == 255, "Reduce");
}

# ------------------------------------------------------------
#  FillConvexPoly - Fills convex polygon XXXXX
# ------------------------------------------------------------
{
	my $image = Cv->CreateImage([320, 240], 8, 3)->Zero;
	$image->FillConvexPoly([ [  50,  50 ], [ 200,  50 ],
							 [ 200, 200 ], [  50, 200 ] ]);
	$image->ShowImage;
	#$image->WaitKey(1000);
}

# ------------------------------------------------------------
#  GetRectSubPix - Retrieves pixel rectangle from image with
#  sub-pixel accuracy XXXXX
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $subpix = $img->GetRectSubPix( [$img->width-1, $img->height-1] );
	ok($subpix);
	#$subpix->ShowImage->WaitKey(1000);
}

# ------------------------------------------------------------
#  Threshold - Applies fixed-level threshold to array elements
# ------------------------------------------------------------
{
	my $gray = Cv->LoadImage($lena, CV_LOAD_IMAGE_GRAYSCALE)
		->Smooth(-smoothtype => CV_GAUSSIAN, -size1 => 5);
	
	my $bin  = $gray->Threshold(-threshold => 90);
	my $otsu = $gray->Threshold(-threshold => 0, -max_value => 255,
								  -threshold_type => CV_THRESH_BINARY |
								  CV_THRESH_OTSU);
	#$bin->ShowImage("Threshold");
	#$otsu->ShowImage("Threshold Otsu");
	#Cv->WaitKey(1000); Cv::Window->DestroyAllWindows;
}

# ------------------------------------------------------------
#  AdaptiveThreshold -  Applies adaptive threshold to array
# ------------------------------------------------------------
{
	my $gray = Cv->LoadImage($lena, CV_LOAD_IMAGE_GRAYSCALE)
		->Smooth(-smoothtype => CV_GAUSSIAN, -size1 => 5);
	my $bin = $gray->AdaptiveThreshold(-threshold_type => CV_THRESH_BINARY_INV,
									   -block_size => 11, -param1 => 10 );
	#$bin->ShowImage("AdaptiveThreshold")->WaitKey(1000);
}

# ======================================================================
#  1.3. Morphological Operations
#  - Erode - Erodes image by using arbitrary structuring element
#  - Dilate - Dilates image by using arbitrary structuring element
#  - MorphologyEx - Performs advanced morphological transformations
# ======================================================================
{
	my $img = Cv->LoadImage($lena);
	my $element = Cv->CreateStructuringElementEx(
						-cols => 11, -rows => 11,
						-anchor_x => 5, -anchor_y => 5,
						-shape => CV_SHAPE_ELLIPSE,
						-values => \0,
						);
	my @at = ([ 20, 20 ], [ 255, 200, 200 ], 1.0);
	my %imgs = (
		"Dilate 3x3" => $img->Dilate,
		"Erode  3x3" => $img->Erode,
		"Dilate 11x11" => $img->Dilate(-element => $element),
		"Erode  11x11" => $img->Erode(-element => $element),
		"CV_MOP_OPEN"  => $img->MorphologyEx(CV_MOP_OPEN),
		"CV_MOP_CLOSE" => $img->MorphologyEx(CV_MOP_CLOSE),
		"CV_MOP_GRADIENT" => $img->MorphologyEx(CV_MOP_GRADIENT),
		"CV_MOP_TOPHAT" => $img->MorphologyEx(CV_MOP_TOPHAT),
		"CV_MOP_BLACKHAT" => $img->MorphologyEx(CV_MOP_BLACKHAT),
		);
	while (my ($name, $image) = each(%imgs)) {
		#$image->ShowImage($name)->WaitKey(1000);
	}
	eval { Cv->Dilate };
	ok($@, "Dilate(usage)");
	eval { Cv->Erode };
	ok($@, "Erode(usage)");
	eval { Cv->MorphologyEx };
	ok($@, "MorphologyEx(usage)");
}

# ------------------------------------------------------------
#  EqualizeHist - Equalizes histogram of grayscale image
# ------------------------------------------------------------
{
	my $image = Cv->LoadImage($lena, CV_LOAD_IMAGE_GRAYSCALE);
	my $equalize = $image->EqualizeHist;
	is(blessed $equalize, "Cv::Image", "EqualizeHist");
	eval { $image->EqualizeHist(-src => undef) };
	like($@, qr/usage:/, "EqualizeHist(usage)");
}


# ------------------------------------------------------------
#  MinMaxLoc - Finds global minimum and maximum in array or subarray
# ------------------------------------------------------------
{
	my $image = Cv->new([ 320, 240 ], 8, 1);
	$image->Set([ 100 ]);
	$image->Set1D([ 10, 20 ], [ 0 ]);
	$image->Set1D([ 100, 200 ], [ 255 ]);


	my $mm = $image->MinMaxLoc;

	ok($mm->{min}{val} == 0, "{min}{val}");
	ok($mm->{min}{loc}{x} == 20, "{min}{loc}{x}");
	ok($mm->{min}{loc}{y} == 10, "{min}{loc}{y}");

	ok($mm->{max}{val} == 255, "{max}{val}");
	ok($mm->{max}{loc}{x} == 200, "{max}{loc}{x}");
	ok($mm->{max}{loc}{y} == 100, "{max}{loc}{y}");

	my $min_val;
	my $max_val;

	my @min_loc;
	my @max_loc;

	$image->MinMaxLoc(-min_val => \$min_val, -max_val => \$max_val,
					  -min_loc => \@min_loc, -max_loc => \@max_loc,
					  );

	ok($min_val == 0, "min_val");
	ok($min_loc[0] == 20, "min_loc[0]");
	ok($min_loc[1] == 10, "min_loc[1]");

	ok($max_val == 255, "max_val");
	ok($max_loc[0] == 200, "max_loc[0]");
	ok($max_loc[1] == 100, "max_loc[1]");

	my %min_loc;
	my %max_loc;

	$image->MinMaxLoc(-min_val => \$min_val, -max_val => \$max_val,
					  -min_loc => \%min_loc, -max_loc => \%max_loc,
					  );

	ok($min_val == 0, "min_val");
	ok($min_loc{x} == 20, "min_loc{x}");
	ok($min_loc{y} == 10, "min_loc{y}");
	
	ok($max_val == 255, "max_val");
	ok($max_loc{x} == 200, "max_loc{x}");
	ok($max_loc{y} == 100, "max_loc{y}");

}
