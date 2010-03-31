# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

#use Test::More qw(no_plan);
use Test::More tests => 13;
use Test::Output;
use Test::File;
BEGIN {
	use_ok('Cv');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $rng = Cv->RNG(-1);
my $n = 1000;
my $rndmax = 0xffffffff + 1;
my $i = 0;
my $r = 0;
my $p = 0;
foreach (1 .. $n) {
	$i += $rng->RandInt / $rndmax;
	$r += $rng->RandReal;
	$p += rand;
}
$i /= $n;
$r /= $n;
$p /= $n;
ok(abs($i - $p) < 0.1, 'RandInt');
ok(abs($r - $p) < 0.1, 'RandReal');

# ------------------------------------------------------------
#  RandInt - Returns 32-bit unsigned integer and updates RNG
# ------------------------------------------------------------
{
	eval { $rng->RandInt(-rng => undef) };
	like($@, qr/usage:|rng is not a reference/, "RandInt(usage)");
	eval { $rng->RandInt(-rng => \0) };
	like($@, qr/usage:|rng is not a reference/, "RandInt(usage)");
}

# ------------------------------------------------------------
#  RandReal - Returns floating-point random number and updates RNG
# ------------------------------------------------------------
{
	eval { $rng->RandReal(-rng => undef) };
	like($@, qr/usage:|rng is not a reference/, "RandReal(usage)");
	eval { $rng->RandReal(-rng => \0) };
	like($@, qr/usage:|rng is not a reference/, "RandReal(usage)");
}

# ------------------------------------------------------------
#  RandArr - Fills array with random numbers and updates the RNG state
# ------------------------------------------------------------
{
	my $img = Cv->CreateImage(
		-size => [ 320, 240 ], -depth => 8, -channels => 3);
	$rng->RandArr(
		-arr => $img,
		-dist_type => CV_RAND_NORMAL,
		-param1 => scalar cvScalarAll(0),
		-param2 => scalar cvScalarAll(255),
		);
	$img->NamedWindow->show;
	Cv->WaitKey(1000);

	my @a = (-arr => $img,
			 -dist_type => CV_RAND_NORMAL,
			 -param1 => scalar cvScalarAll(0),
			 -param2 => scalar cvScalarAll(255),
		);
	eval { $rng->RandArr(@a, -arr => undef) };
	like($@, qr/usage:/, "RandArr(usage)");
	eval { $rng->RandArr(@a, -dist_type => undef) };
	like($@, qr/usage:/, "RandArr(usage)");
	eval { $rng->RandArr(@a, -param1 =>undef) };
	like($@, qr/usage:/, "RandArr(usage)");
	eval { $rng->RandArr(@a, -param2 =>undef) };
	like($@, qr/usage:/, "RandArr(usage)");
	eval { $rng->RandArr(@a, -rng =>undef) };
	like($@, qr/usage:|rng is not a reference/, "RandArr(usage)");
	eval { $rng->RandArr(@a, -rng =>\0) };
	like($@, qr/usage:|rng is not a reference/, "RandArr(usage)");
}

