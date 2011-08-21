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

use Scalar::Util qw(blessed);


# ============================================================
#  (1) $src1->cvXXX();
#  (3) $src1->cvXXX($dst);
#  (4) $src1->cvXXX(); # new returns undef
# ============================================================

foreach my $xs (qw(

ConvertScale ConvertScaleAbs DCT DFT Exp Flip Inv Log Normalize Not
Pow Reduce Repeat Transpose CopyMakeBorder Dilate Erode Filter2D
Laplace MorphologyEx PyrDown PyrUp Smooth Sobel LogPolar LinearPolar
Remap Resize WarpAffine WarpPerspective AdaptiveThreshold
DistTransform EqualizeHist Integral PyrMeanShiftFiltering
PyrSegmentation Threshold Canny

)) {

	if (1) {
		my @av;
		no warnings;
		no strict 'refs';
		my $cv = "Cv::Arr::cv${xs}";
		local *{$cv} = sub { @av = ($cv, @_); $_[1]; };
		my $src1 = Cv->CreateImage([ 320, 240 ], 8, 3);
		$src1->${xs}();
		is($av[0], $cv);
		is($av[1], $src1);
	}

	if (3) {
		my @av;
		no warnings;
		no strict 'refs';
		my $cv = "Cv::Arr::cv${xs}";
		local *{$cv} = sub { @av = ($cv, @_); $_[1]; };
		my $src1 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $dst = $src1->new;
		my $ret = $src1->${xs}($dst);
		is($av[0], $cv);
		is($av[1], $src1);
		is($av[2], $dst);
		is($ret, $dst);
	}

	if (4) {
		my @av;
		no warnings;
		no strict 'refs';
		my $cv = "Cv::Arr::cv${xs}";
		local *{$cv} = sub { @av = ($cv, @_); $_[1]; };
		my $src1 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $new = join('::', blessed $src1, 'new');
		local *{$new} = sub { undef; };
		my $ret = $src1->${xs}();
		is($av[0], $cv);
		is($av[1], $src1);
		is($ret, undef);
	}

}



# ============================================================
#  (1) $src1->cvXXX($src2);
#  (2) $src1->cvXXX($val2);
#  (3) $src1->cvXXX($src2, $dst);
#  (4) $src1->cvXXX($src2); # new returns undef
# ============================================================

foreach my $xs (qw(

AbsDiff Add And Cmp Max Min Or Sub Xor

)) {

	if (1) {
		my @av;
		no warnings;
		no strict 'refs';
		my $cv = "Cv::Arr::cv${xs}";
		local *{$cv} = sub { @av = ($cv, @_); $_[2]; };
		my $src1 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $src2 = Cv->CreateImage([ 320, 240 ], 8, 3);
		$src1->${xs}($src2);
		is($av[0], $cv);
		is($av[1], $src1);
		is($av[2], $src2);
	}

	if (2) {
		my @av;
		no warnings;
		no strict 'refs';
		my $cv = "Cv::Arr::cv${xs}S";
		local *{$cv} = sub { @av = ($cv, @_); $_[2]; };
		my $src1 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $src2 = [ 1, 2, 3 ];
		$src1->${xs}($src2);
		is($av[0], $cv);
		is($av[1], $src1);
		is($av[2], $src2);
	}

	if (3) {
		my @av;
		no warnings;
		no strict 'refs';
		my $cv = "Cv::Arr::cv${xs}";
		local *{$cv} = sub { @av = ($cv, @_); $_[2]; };
		my $src1 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $src2 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $dst = $src1->new;
		my $ret = $src1->${xs}($src2, $dst);
		is($av[0], $cv);
		is($av[1], $src1);
		is($av[2], $src2);
		is($av[3], $dst);
		is($ret, $dst);
	}

	if (4) {
		my @av;
		no warnings;
		no strict 'refs';
		my $cv = "Cv::Arr::cv${xs}";
		local *{$cv} = sub { @av = ($cv, @_); $_[2]; };
		my $src1 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $src2 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $new = join('::', blessed $src1, 'new');
		local *{$new} = sub { undef; };
		my $ret = $src1->${xs}($src2);
		is($av[0], $cv);
		is($av[1], $src1);
		is($av[2], $src2);
		is($ret, undef);
	}

}


# ============================================================
#  (1) $src1->cvXXX($src2);
#  (3) $src1->cvXXX($src2, $dst);
#  (4) $src1->cvXXX($src2); # new returns undef
# ============================================================

foreach my $xs (qw(

CrossProduct Div Mul MulSpectrums MulTransposed Solve SubRS
Inpaint

)) {

	if (1) {
		my @av;
		no warnings;
		no strict 'refs';
		my $cv = "Cv::Arr::cv${xs}";
		local *{$cv} = sub { @av = ($cv, @_); $_[2]; };
		my $src1 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $src2 = Cv->CreateImage([ 320, 240 ], 8, 3);
		$src1->${xs}($src2);
		is($av[0], $cv);
		is($av[1], $src1);
		is($av[2], $src2);
	}

	if (3) {
		my @av;
		no warnings;
		no strict 'refs';
		my $cv = "Cv::Arr::cv${xs}";
		local *{$cv} = sub { @av = ($cv, @_); $_[2]; };
		my $src1 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $src2 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $dst = $src1->new;
		my $ret = $src1->${xs}($src2, $dst);
		is($av[0], $cv);
		is($av[1], $src1);
		is($av[2], $src2);
		is($av[3], $dst);
		is($ret, $dst);
	}

	if (4) {
		my @av;
		no warnings;
		no strict 'refs';
		my $cv = "Cv::Arr::cv${xs}";
		local *{$cv} = sub { @av = ($cv, @_); $_[2]; };
		my $src1 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $src2 = Cv->CreateImage([ 320, 240 ], 8, 3);
		my $new = join('::', blessed $src1, 'new');
		local *{$new} = sub { undef; };
		my $ret = $src1->${xs}($src2);
		is($av[0], $cv);
		is($av[1], $src1);
		is($av[2], $src2);
		is($ret, undef);
	}

}
