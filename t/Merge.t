# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

#  Before `make install' is performed this script should be runnable with
#  `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
# use Test::More tests => 13;
use Scalar::Util qw(blessed);

BEGIN {
	use_ok('Cv');
}

if (1) {
	my $b = Cv::Image->new([3, 3], CV_8UC1);
	isa_ok($b, 'Cv::Image');
	$b->fill([1]);
	my $g = $b->new;
	isa_ok($g, 'Cv::Image');
	$g->fill([2]);
	my $r = $b->new;
	isa_ok($r, 'Cv::Image');
	$r->fill([3]);
	foreach my $row (0 .. $b->rows - 1) {
		foreach my $col (0 .. $b->cols - 1) {
			is(${$b->Get([$row, $col])}[0], 1);
			is(${$g->Get([$row, $col])}[0], 2);
			is(${$r->Get([$row, $col])}[0], 3);
		}
	}

	my $bgr = Cv->Merge($b, $g, $r);
	foreach my $row (0 .. $bgr->rows - 1) {
		foreach my $col (0 .. $bgr->cols - 1) {
			my $x = $bgr->Get([$row, $col]);
			is($x->[0], 1);
			is($x->[1], 2);
			is($x->[2], 3);
		}
	}

	my $bgr2 = Cv->Merge([$b, $g, $r]);
	foreach my $row (0 .. $bgr2->rows - 1) {
		foreach my $col (0 .. $bgr2->cols - 1) {
			my $x = $bgr2->Get([$row, $col]);
			is($x->[0], 1);
			is($x->[1], 2);
			is($x->[2], 3);
		}
	}

	Cv->Merge([$b, $g, $r], my $bgr3 = Cv::Image->new($b->sizes, CV_8UC3));
	foreach my $row (0 .. $bgr3->rows - 1) {
		foreach my $col (0 .. $bgr3->cols - 1) {
			my $x = $bgr3->Get([$row, $col]);
			is($x->[0], 1);
			is($x->[1], 2);
			is($x->[2], 3);
		}
	}

}

if (1) {
	eval { Cv->Merge; };
	like($@, qr/usage:/);
}
