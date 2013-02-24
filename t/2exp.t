# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 10;
BEGIN { use_ok('Cv', -nomore) }
BEGIN { use_ok('Cv::Test') }

# ------------------------------------------------------------
#  void cvExp(const CvArr* src, CvArr* dst)
# ------------------------------------------------------------

my $src = Cv::Mat->new([3], CV_32FC1);
$src->set([0], [rand 3]);
$src->set([1], [rand 3]);
$src->set([2], [rand 3]);

if (1) {
	my $dst = $src->exp;
	is_({ round => "%.4g" }, $dst->getReal([0]), exp($src->getReal([0])));
	is_({ round => "%.4g" }, $dst->getReal([1]), exp($src->getReal([1])));
	is_({ round => "%.4g" }, $dst->getReal([2]), exp($src->getReal([2])));
}

if (2) {
	$src->exp(my $dst = $src->new);
	is_({ round => "%.4g" }, $dst->getReal([0]), exp($src->getReal([0])));
	is_({ round => "%.4g" }, $dst->getReal([1]), exp($src->getReal([1])));
	is_({ round => "%.4g" }, $dst->getReal([2]), exp($src->getReal([2])));
}

if (10) {
	e { $src->exp(0, 0) };
	err_is("Usage: Cv::Arr::cvExp(src, dst)");
}

if (11) {
	e { $src->exp($src->new(CV_8UC1)) };
	err_like("OpenCV Error");
}