# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

use strict;
use warnings;
# use Test::More qw(no_plan);
use Test::More tests => 25;
BEGIN { use_ok('Cv') }

if (1) {
	my $points = Cv::Mat->new([3, 1], CV_32FC2);
	$points->set([0], [1, 1]);
	$points->set([1], [2, 2]);
	$points->set([2], [3, 3]);
	$points->FitLine(CV_DIST_L2, 0, 0.01, 0.01, my $line);
	my ($vx, $vy, $x0, $y0) = @$line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1e-6);
}

if (2) {
	my $points = Cv::Mat->new([3, 1], CV_32FC2);
	$points->set([0], [1, 1]);
	$points->set([1], [2, 2]);
	$points->set([2], [3, 3]);
	$points->FitLine(CV_DIST_L2, 0, 0.01, 0.01, \my @line);
	my ($vx, $vy, $x0, $y0) = @line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1e-6);
}

if (3) {
	Cv->FitLine([[1, 2], [2, 3], [3, 4]], CV_DIST_L2, 0, 0.01, 0.01, \my @line);
	my ($vx, $vy, $x0, $y0) = @line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1 + 1e-6);
}

if (4) {
	Cv->FitLine([[1, 2, 1], [2, 3, 1.5], [3, 4, 2]], CV_DIST_L2, my $line);
	my ($vx, $vy, $vz, $x0, $y0, $z0) = @$line;
	cmp_ok(abs(1.0 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs(0.5 - ($vz / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1 + 1e-6);
	cmp_ok(abs($z0 - ($vz / $vx) * $x0), '<', 1 + 1e-6);
}


# Cv-0.16
Cv::More->import(qw(cs));

if (11) {
	my $points = Cv::Mat->new([3, 1], CV_32FC2);
	$points->set([0], [1, 1]);
	$points->set([1], [2, 2]);
	$points->set([2], [3, 3]);
	my $line = $points->FitLine(CV_DIST_L2, 0, 0.01, 0.01);
	my ($vx, $vy, $x0, $y0) = @$line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1e-6);
}

if (12) {
	my $points = Cv::Mat->new([3, 1], CV_32FC2);
	$points->set([0], [1, 1]);
	$points->set([1], [2, 2]);
	$points->set([2], [3, 3]);
	my @line = $points->FitLine(CV_DIST_L2, 0, 0.01, 0.01);
	my ($vx, $vy, $x0, $y0) = @line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1e-6);
}

if (13) {
	my @line = Cv->FitLine([[1, 2], [2, 3], [3, 4]], CV_DIST_L2, 0, 0.01, 0.01);
	my ($vx, $vy, $x0, $y0) = @line;
	cmp_ok(abs(1 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1 + 1e-6);
}

if (14) {
	my $line = Cv->FitLine([[1, 2, 1], [2, 3, 1.5], [3, 4, 2]], CV_DIST_L2);
	my ($vx, $vy, $vz, $x0, $y0, $z0) = @$line;
	cmp_ok(abs(1.0 - ($vy / $vx)), '<', 1e-6);
	cmp_ok(abs(0.5 - ($vz / $vx)), '<', 1e-6);
	cmp_ok(abs($y0 - ($vy / $vx) * $x0), '<', 1 + 1e-6);
	cmp_ok(abs($z0 - ($vz / $vx) * $x0), '<', 1 + 1e-6);
}


# Cv-0.19
our $line;
sub err_is {
	our $line;
	chop(my $a = $@);
	my $b = shift(@_) . " at $0 line $line";
	$b .= '.' if $a =~ m/\.$/;
	unshift(@_, "$a\n", "$b\n");
	goto &is;
}

$line = __LINE__ + 1;
eval { my @line = Cv->FitLine };
err_is('Usage: Cv->FitLine(points ...)');

$line = __LINE__ + 1;
eval { my @line = Cv->FitLine([]) };
err_is('Cv->FitLine: points is not [ pt1, pt2, ... ]');

$line = __LINE__ + 1;
eval { my @line = Cv->FitLine([[1, 2], [2, 3], [3, 4]], -1) };
err_is('OpenCV Error: Bad argument (User-defined distance is not allowed) in cvFitLine');

Cv::More->unimport(qw(cs cs-warn));
Cv::More->import(qw(cs-warn));
{
	no warnings 'redefine';
	local *Carp::carp = \&Carp::croak;
	$line = __LINE__ + 1;
	eval { my @line = Cv->FitLine([[1, 2], [2, 3], [3, 4]]) };
	err_is("called in list context, but returning scaler");
}
