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

# ------------------------------------------------------------
# void cvAbsDiff(const CvArr* src1, const CvArr* src2, CvArr* dst)
# void cvAbsDiffS(const CvArr* src, CvScalar value, CvArr* dst)
# ------------------------------------------------------------

my $src = Cv::Mat->new([ 3, 3 ], CV_8UC3);

if (11) {
	my $src2 = $src->new;
	$src->fill([ 21, 22, 23, 24 ]);
	$src2->fill([ 11, 12, 13, 14 ]);
	$src->absDiff($src2, my $dst = $src->new);
	is(${$dst->get([0, 0])}[0], 10);
	is(${$dst->get([0, 0])}[1], 10);
	is(${$dst->get([0, 0])}[2], 10);
}

if (12) {
	my $src2 = $src->new;
	$src->fill([ 21, 22, 23, 24 ]);
	$src2->fill([ 11, 12, 13, 14 ]);
	my $dst = $src->absDiff($src2);
	is(${$dst->get([0, 0])}[0], 10);
	is(${$dst->get([0, 0])}[1], 10);
	is(${$dst->get([0, 0])}[2], 10);
}

if (21) {
	$src->fill([ 21, 22, 23, 24 ]);
	my $value = [ 11, 12, 13, 14 ];
	$src->absDiff($value, my $dst = $src->new);
	is(${$dst->get([0, 0])}[0], 10);
	is(${$dst->get([0, 0])}[1], 10);
	is(${$dst->get([0, 0])}[2], 10);
}

if (22) {
	$src->fill([ 21, 22, 23, 24 ]);
	my $value = [ 11, 12, 13, 14 ];
	my $dst = $src->absDiff($value);
	is(${$dst->get([0, 0])}[0], 10);
	is(${$dst->get([0, 0])}[1], 10);
	is(${$dst->get([0, 0])}[2], 10);
}
