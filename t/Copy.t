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

my $src = Cv->createImage([ 320, 240 ], 8, 3);
my $rng = Cv::RNG->new;
$rng->randArr($src, CV_RAND_NORMAL, cvScalarAll(0), cvScalarAll(255));
my @channels = (0 .. $src->channels - 1);

if (1) {
	my $dst2 = Cv::Arr::cvCopy($src, my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is($s->[$_], $d1->[$_]) for @channels;
	is($s->[$_], $d2->[$_]) for @channels;
}

if (2) {
	my $dst2 = $src->Copy(my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is($s->[$_], $d1->[$_]) for @channels;
	is($s->[$_], $d2->[$_]) for @channels;
}

if (3) {
	my $dst2 = $src->copy(my $dst = $src->new);
	my ($s, $d1, $d2) = ($src->sum, $dst->sum, $dst2->sum);
	is($s->[$_], $d1->[$_]) for @channels;
	is($s->[$_], $d2->[$_]) for @channels;
}
