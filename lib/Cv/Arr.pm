# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Arr;

use 5.008008;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);

BEGIN {
	Cv::aliases(
		[ 'cvArcLength', 'ContourPerimeter' ],
		[ 'cvGetDims' ],
		[ 'cvMinAreaRect', ],
		[ 'cvSaveImage', 'Save', ],
		[ 'cvShowImage', 'Show', ],

		[ 'AbsDiff', 'AbsDiffS' ],
		[ 'Add', 'AddS' ],
		[ 'And', 'AndS' ],
		[ 'Cmp', 'CmpS' ],
		[ 'ConvertScale', 'Scale', 'Convert', 'CvtScale' ],
		[ 'ConvertScaleAbs', 'CvtScaleAbs' ],
		[ 'Flip', 'Mirror' ],
		[ 'Get' ],
		[ 'GetReal' ],
		[ 'InRange', 'InRangeS' ],
		[ 'Inv', 'Invert' ],
		[ 'Max', 'MaxS' ],
		[ 'Min', 'MinS' ],
		[ 'Not', 'NotS' ],
		[ 'Or', 'OrS' ],
		[ 'Set' ],
		[ 'Split', 'CvtPixToPlane' ],
		[ 'Sub', 'SubS' ],
		[ 'Xor', 'XorS' ],
		);
}

sub AUTOLOAD {
    our $AUTOLOAD;
    (my $short = $AUTOLOAD) =~ s/.*:://;
	if (my $real = Cv::assoc(__PACKAGE__, $short)) {
		no strict "refs";
		*$AUTOLOAD = \&$real;
		goto &$AUTOLOAD;
	}
    croak "Can't assocate $AUTOLOAD";
}

sub DESTROY {
	# ignore
}

# ============================================================
#  core. The Core Functionality: Operations on Arrays
# ============================================================

sub is_null {
	ref $_[0] eq 'SCALAR' && ${$_[0]} == 0;
}

sub is_arr {
	blessed $_[0] && $_[0]->isa(__PACKAGE__);
}

sub dst (\@) {
	my ($ref) = @_;
	my $dst = undef;
	my @tmp = ();
	my $first = 1;
	foreach (@{$ref}) {
		if ($dst) {
			push(@tmp, $_);
		} elsif (is_arr($_) || $first && is_null($_)) {
			$dst = $_;
		} else {
			push(@tmp, $_);
		}
		$first = 0;
	}
	@$ref = @tmp if ($dst);
	$dst;
}

sub matrix {
    my $matrix = (@_ <= 1)? $_[0] : \@_;
	my ($rows, $cols); my @m = ();
    if (ref $matrix->[0] eq 'ARRAY') {
		$rows = @$matrix;
		$cols = @{$matrix->[0]};
		@m = map @$_, @$matrix;
    } else {
		$rows = 1;
		$cols = @$matrix;
		@m = @$matrix;
    }
	($rows, $cols, @m);
}

sub AbsDiff {
	# AbsDiff(src1, src2, [dst])
	# AbsDiffS(src, value, [dst])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvAbsDiffS;
	} else {
		goto &cvAbsDiff;
	}
}

sub Add {
	# Add(src1, src2, [dst], [mask])
	# AddS(src, value, [dst], [mask])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvAddS;
	} else {
		goto &cvAdd;
	}
}

sub AddWeighted {
	# AddWeighted(src1, alpha, src2, beta, gamma, [dst])
	my ($src, $alpha, $src2, $beta, $gamma) = splice(@_, 0, 5);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $alpha, $src2, $beta, $gamma, $dst);
	goto &cvAddWeighted;
}

sub And {
	# And(src1, src2, [dst], [mask])
	# AndS(src, value, [dst], [mask])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvAndS;
	} else {
		goto &cvAnd;
	}
}

sub Cmp {
	# Cmp(src, src2, [dst], cmpOp)
	# CmpS(src, value, [dst], cmpOp)
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new(
		$src->sizes, Cv::MAKETYPE(&Cv::CV_8U, Cv::MAT_CN($src->type)));
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvCmpS;
	} else {
		goto &cvCmp;
	}
}

sub ConvertScale {
	# ConvertScale(src, [dst], [scale], [shift])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvConvertScale;
}

sub ConvertScaleAbs {
	# ConvertScaleAbs(src, [dst], [scale], [shift])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvConvertScaleAbs;
}

sub CrossProduct {
	# CrossProduct(src1, src2, [dst])
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvCrossProduct;
}


# CvtPixToPlane: Synonym for Split.

sub DCT {
	# DCT(src, [dst], flags)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvDCT;
}

sub DFT {
	# DFT(src, [dst], flags, [nonzeroRows])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvDFT;
}

sub Div {
	# Div(src1, src2, [dst], [scale]);
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvDiv;
}

sub Exp {
	# Exp(src, [dst]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvExp;
}

sub Flip {
	# Flip(src, [dst], flipMode)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvFlip;
}

sub GEMM {
	# GEMM($src, $src2, $alpha, $src3, $beta, [$dst], [$tABC]);
	my ($src, $src2, $alpha, $src3, $beta) = splice(@_, 0, 5);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $alpha, $src3, $beta, $dst);
	goto &cvGEMM;
}

sub MatMulAdd {
	# MatMulAdd($src1, $src2, $src3, [$dst]);
	my ($src, $src2, $src3) = splice(@_, 0, 3);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, 1, $src3, 1, $dst, 0);
	goto &GEMM;
}

sub MatMul {
	# MatMulAdd($src1, $src2, [$dst]);
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, \0, $dst);
	goto &MatMulAdd;
}

sub Get {
	# Get($src, $idx0);
	# Get($src, $idx0, $idx1);
	# Get($src, $idx0, $idx1, $idx2);
	# Get($src, $idx0, $idx1, $idx2, $idx3);
	# Get($src, [$idx0, $idx1, $idx2, $idx3]);
	my $src = shift;
	if (ref $_[0] eq 'ARRAY') {
		# cvGetND($src, @_);
		unshift(@_, $src);
		goto &cvGetND;
	} elsif (@_ == 1) {
		# cvGet1D($src, @_);
		unshift(@_, $src);
		goto &cvGet1D;
	} elsif (@_ == 2) {
		# cvGet2D($src, @_);
		unshift(@_, $src);
		goto &cvGet2D;
	} elsif (@_ == 3) {
		# cvGet3D($src, @_);
		unshift(@_, $src);
		goto &cvGet3D;
	} else {
		# cvGetND($src, \@_);
		@_ = ($src, \@_);
		goto &cvGetND;
	}
}

sub GetCols {
	# GetCol($src, [$submat], $col);
	# GetCols($src, [$submat], $startCol, $endCol);
	my $arr = shift;
	my $submat = dst(@_);
	if (@_ == 1) {
		push(@_, $_[-1]);
	}
	if (@_ >= 2) {
		my $startCol = shift;
		my $endCol  = shift;
		my $sizes = [$arr->rows, $endCol - $startCol];
		$submat ||= $arr->new($sizes, $arr->type, \0);
		unshift(@_, $arr, $submat, $startCol, $endCol);
		goto &cvGetCols;
	}
}

sub GetReal {
	# GetReal($src, $idx0);
	# GetReal($src, $idx0, $idx1);
	# GetReal($src, $idx0, $idx1, $idx2);
	# GetReal($src, $idx0, $idx1, $idx2, $idx3);
	# GetReal($src, [$idx0, $idx1, $idx2, $idx3]);
	my $src = shift;
	if (ref $_[0] eq 'ARRAY') {
		# cvGetRealND($src, @_);
		unshift(@_, $src);
		goto &cvGetRealND;
	} elsif (@_ == 1) {
		# cvGetReal1D($src, @_);
		unshift(@_, $src);
		goto &cvGetReal1D;
	} elsif (@_ == 2) {
		# cvGetReal2D($src, @_);
		unshift(@_, $src);
		goto &cvGetReal2D;
	} elsif (@_ == 3) {
		# cvGetReal3D($src, @_);
		unshift(@_, $src);
		goto &cvGetReal3D;
	} else {
		# cvGetRealND($src, \@_);
		@_ = ($src, \@_);
		goto &cvGetRealND;
	}
}

sub GetRows {
	# GetRows($src, [$submat], $row);
	# GetRows($src, [$submat], $startRow, $endRow, [$deltaRow]);
	my $arr = shift;
	my $submat = dst(@_);
	if (@_ == 1) {
		push(@_, $_[-1]);
	}
	if (@_ >= 2) {
		my $startRow = shift;
		my $endRow = shift;
		my $deltaRow = shift || 1;
		my $rows = 0;
		for (my $row = $startRow; $row < $endRow; $row += $deltaRow) {
			$rows++;
		}
		my $sizes = [$rows || 1, $arr->cols];
		$submat ||= $arr->new($sizes, $arr->type, \0);
		unshift(@_, $arr, $submat, $startRow, $endRow, $deltaRow);
		goto &cvGetRows;
	}
}

sub GetSubRect {
	# GetSubRect($src, [$submat], $rect);
	my $arr = shift;
	my $submat = dst(@_);
	my $rect = shift;
	my $sizes = [ $rect->[3], $rect->[2] ];
	$submat ||= $arr->new($sizes, $arr->type, \0);
	unshift(@_, $arr, $submat, $rect);
	goto &cvGetSubRect;
}

sub InRange {
	# InRange($src, $upper, $lower, [$dst]);
	# InRangeS($src, $upper, $lower, [$dst]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	my ($upper, $lower) = splice(@_, 0, 2);
	unshift(@_, $src, $upper, $lower, $dst);
	if (ref $upper eq 'ARRAY') {
		goto &cvInRangeS;
	} else {
		goto &cvInRange;
	}
}

sub Inv {
	# Inv(src, [dst], [$method]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvInv;
}

sub LUT {
	# LUT(src, [dst], $lut);
	my $src = shift;
	my $lut = pop;
	my $dst = dst(@_);
	if (Cv::MAT_CN($lut->type) > 1) {
		my @lut = $lut->split;
		$dst ||= $src->new($src->sizes, $lut->type);
		my @dsts = $dst->split;
		cvLUT($src, $dsts[$_], $lut[$_]) for 0 .. $#lut;
		Cv->Merge(\@dsts, $dst); # XXXXX
	} else {
		$dst ||= $src->new(
			$src->sizes, Cv::MAKETYPE(Cv::MAT_DEPTH($lut->type), 1));
		unshift(@_, $src, $dst, $lut);
		goto &cvLUT;
	}
}

sub Log {
	# Log(src, [dst]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvLog;
}

sub Max {
	# Max(src1, src2, [dst]);
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvMaxS;
	} else {
		goto &cvMax;
	}
}

sub Merge {
	# Merge([src1, src2, ...], [dst]);
	my $srcs = shift;
	my $dst = shift;
	unless ($dst) {
		my $src0 = $srcs->[0];
		my $type = Cv::MAKETYPE(Cv::MAT_DEPTH($src0->type), scalar @$srcs);
		$dst = $src0->new($src0->sizes, $type);
	}
	unshift(@_, $srcs, $dst);
	goto &Cv::cvMerge;
}

sub Min {
	# Min(src1, src2, [dst]);
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvMinS;
	} else {
		goto &cvMin;
	}
}

sub Mul {
	# Mul(src1, src2, [dst], [scale])
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvMul;
}

sub MulSpectrums {
	# MulSpectrums(src1, src2, [dst], flags);
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvMulSpectrums;
}

sub MulTransposed {
	# MulTransposed(src1, src2, [dst], order, [delta], [scale]);
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvMulTransposed;
}

sub Normalize {
	# Normalize(src, dst, [a], [b], [norm_type], [mask])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvNormalize;
}

sub Not {
	# Not(src, [dst])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvNot;
}

sub Or {
	# Or(src1, src2, [dst], [mask])
	# OrS(src, value, [dst], [mask])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvOrS;
	} else {
		goto &cvOr;
	}
}

sub Pow {
	# Pow(src, [dst], power)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvPow;
}

sub Reduce {
	# Reduce(src, [dst], [dim], [op]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvReduce;
}

# void cvReleaseData(CvArr* arr)

sub Repeat {
	# Repeat(src, dst);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvRepeat;
}

# CvMat* cvReshape(const CvArr* arr, CvMat* header, int newCn, int newRows=0)


sub ScaleAdd {
	# ScaleAdd(src, scale, src2, [dst]);
	my ($src, $scale, $src2) = splice(@_, 0, 3);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $scale, $src2, $dst);
	goto &cvScaleAdd;
}


sub Set {
	# Set($src, $idx0, $value);
	# Set($src, $idx0, $idx1, $value);
	# Set($src, $idx0, $idx1, $idx2, $value);
	# Set($src, $idx0, $idx1, $idx2, $idx3, $value);
	# Set($src, [$idx0, $idx1, $idx2, $idx3], $value);
	my $src = shift;
	my $value = pop;
	if (ref $_[0] eq 'ARRAY') {
		# cvSetND($src, @_, $value);
		push(@_, $value);
		unshift(@_, $src);
		goto &cvSetND;
	} elsif (@_ == 1) {
		# cvSet1D($src, @_, $value);
		push(@_, $value);
		unshift(@_, $src);
		goto &cvSet1D;
	} elsif (@_ == 2) {
		# cvSet2D($src, @_, $value);
		push(@_, $value);
		unshift(@_, $src);
		goto &cvSet2D;
	} elsif (@_ == 3) {
		# cvSet3D($src, @_, $value);
		push(@_, $value);
		unshift(@_, $src);
		goto &cvSet3D;
	} else {
		# cvSetND($src, \@_, $value);
		@_ = ($src, \@_, $value);
		goto &cvSetND;
	}
}


# void cvSetData(CvArr* arr, void* data, int step)


sub SetReal {
	# SetReal($src, $idx0, $value);
	# SetReal($src, $idx0, $idx1, $value);
	# SetReal($src, $idx0, $idx1, $idx2, $value);
	# SetReal($src, $idx0, $idx1, $idx2, $idx3, $value);
	# SetReal($src, [$idx0, $idx1, $idx2, $idx3], $value);
	my $src = shift;
	my $value = pop;
	if (ref $_[0] eq 'ARRAY') {
		# cvSetRealND($src, @_, $value);
		unshift(@_, $src); push(@_, $value);
		goto &cvSetRealND;
	} elsif (@_ == 1) {
		# cvSetReal1D($src, @_, $value);
		unshift(@_, $src); push(@_, $value);
		goto &cvSetReal1D;
	} elsif (@_ == 2) {
		# cvSetReal2D($src, @_, $value);
		unshift(@_, $src); push(@_, $value);
		goto &cvSetReal2D;
	} elsif (@_ == 3) {
		# cvSetReal3D($src, @_, $value);
		unshift(@_, $src); push(@_, $value);
		goto &cvSetReal3D;
	} else {
		# cvSetRealND($src, \@_, $value);
		@_ = ($src, \@_, $value);
		goto &cvSetRealND;
	}
}

sub Solve {
	# Solve(src1, src2, [dst], [method]);
	my ($src, $src2) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2, $dst);
	goto &cvSolve;
}

sub Split {
	# Split(src, $dst0, $dst1, ...);
	my $src = shift;
	unless (@_) {
		for (1 .. $src->channels) {
			my $type = Cv::MAKETYPE(Cv::MAT_DEPTH($src->type), 1);
			my $dst = $src->new($src->sizes, $type);
			push(@_, $dst);
		}
	}
	cvSplit($src, @_);
	wantarray ? @_ : \@_;	# XXXXX
}

sub Sub {
	# Sub(src1, src2, [dst], [mask])
	# SubS(src, value, [dst], [mask])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvSubS;
	} else {
		goto &cvSub;
	}
}

sub SubRS {
	# SubRS(src, value, [dst], [mask])
	my ($src, $value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $value, $dst);
	goto &cvSubRS;
}

sub Transpose {
	# Transpose(src, [dst])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvTranspose;
}

sub Xor {
	# Xor(src1, src2, [dst], [mask])
	# XorS(src, value, [dst], [mask])
	my ($src, $src2_value) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $src2_value, $dst);
	if (ref $src2_value eq 'ARRAY') {
		goto &cvXorS;
	} else {
		goto &cvXor;
	}
}


# ============================================================
#  core. The Core Functionality: Dynamic Structures
# ============================================================

# ============================================================
#  core. The Core Functionality: Drawing Functions
# ============================================================

# ============================================================
#  core. The Core Functionality: XML/YAML Persistence
# ============================================================

# ============================================================
#  core. The Core Functionality: Clustering
# ============================================================

# ============================================================
#  core. The Core Functionality: Utility and System Functions and Macros
# ============================================================

# ============================================================
#  imgproc. Image Processing: Histograms
# ============================================================

# ============================================================
#  imgproc. Image Processing: Image Filtering
# ============================================================

sub CopyMakeBorder {
	# CopyMakeBorder(src, dst, offset, bordertype, [value]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvCopyMakeBorder;
}

sub Dilate {
	# Dilate(src, dst, [element], [iterations])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvDilate;
}

sub Erode {
	# Erode(src, dst, [element], [iterations])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvErode;
}

sub Filter2D {
	# Filter2D(src, dst, [kernel], [anchor])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvFilter2D;
}

sub Laplace {
	# Laplace(src, dst, [apertureSize])
	my $src = shift;
	my $dst = dst(@_) || $src->new(
		$src->sizes, Cv::MAKETYPE(&Cv::CV_16S, Cv::MAT_CN($src->type)));
	unshift(@_, $src, $dst);
	goto &cvLaplace;
}

sub MorphologyEx {
	# MorphologyEx(src, dst, temp, element, operation, [iterations])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvMorphologyEx;
}

sub PyrDown {
	# PyrDown(src, dst, [filter]);
	my $src = shift;
	my $dst = dst(@_) || $src->new([map { int($_ / 2) } @{$src->sizes}]);
	unshift(@_, $src, $dst);
	goto &cvPyrDown;
}

sub PyrUp {
	# PyrUp(src, dst, [filter]);
	my $src = shift;
	my $dst = dst(@_) || $src->new([map { int($_ * 2) } @{$src->sizes}]);
	unshift(@_, $src, $dst);
	goto &cvPyrUp;
}

sub Smooth {
	# Smooth(src, dst, [smoothtype], [param1], [param2], [param3], [param4])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvSmooth;
}

sub Sobel {
	# Sobel(src, dst, xorder, yorder, [apertureSize])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvSobel;
}

# ============================================================
#  imgproc. Image Processing: Geometric Image Transformations
# ============================================================

sub Affine {
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	my $mat = shift;
	my ($rows, $cols, @m) = &matrix($mat);
	my $matrix = Cv->CreateMat($rows, $cols, &Cv::CV_32FC1);
	foreach my $r (0 .. $rows - 1) {
		foreach my $c (0 .. $cols - 1) {
			$matrix->Set([$r, $c], [ shift(@m) ]);
		}
	}
	unshift(@_, $src, $dst, $matrix);
	goto &cvGetQuadrangleSubPix;
}

sub LogPolar {
	# LogPolar(src, dst, center, M, [flags]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvLogPolar;
}


sub LinearPolar {
	# LinearPolar(src, dst, center, maxRadius, [flags]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvLinearPolar;
}

sub Remap {
	# Remap(src, dst, mapx, mapy, [flags], [fillval])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvRemap;
}

sub Resize {
	# Resize(src, dst, [interpolation])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvResize;
}

sub WarpAffine {
	# WarpAffine(src, dst, mapMatrix, [flags], [fillval])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvWarpAffine;
}

sub WarpPerspective {
	# WarpPerspective(src, dst, mapMatrix, [flags], [fillval])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvWarpPerspective;
}


# ============================================================
#  imgproc. Image Processing: Miscellaneous Image Transformations
# ============================================================

sub AdaptiveThreshold {
	# AdaptiveThreshold(src, dst, maxValue, [adaptive_method], [thresholdType], [blockSize], [param1])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvAdaptiveThreshold;
}

sub CvtColor {
	# cvtColor(src, [dst], code)
	# cvtColor(src, code, [dst])
	my $src = shift;
	my $dst = dst(@_);
	my $code = shift;
	unless ($dst) {
		if ($code == &Cv::CV_BGR2GRAY ||
			$code == &Cv::CV_RGB2GRAY) {
			my $type = Cv::MAKETYPE(Cv::MAT_DEPTH($src->type), 1);
			$dst = $src->new($src->sizes, $type);
		} elsif ($code == &Cv::CV_GRAY2BGR  ||
				 $code == &Cv::CV_GRAY2BGR  ||
				 $code == &Cv::CV_GRAY2RGB  ||
				 $code == &Cv::CV_BGR2HSV   ||
				 $code == &Cv::CV_RGB2HSV   ||
				 $code == &Cv::CV_BGR2YCrCb ||
				 $code == &Cv::CV_RGB2YCrCb ||
				 $code == &Cv::CV_YCrCb2BGR ||
				 $code == &Cv::CV_YCrCb2RGB) {
			my $type = Cv::MAKETYPE(Cv::MAT_DEPTH($src->type), 3);
			$dst = $src->new($src->sizes, $type);
		}
	}
	unshift(@_, $src, $dst, $code);
	goto &cvCvtColor;
}

sub DistTransform {
	# DistTransform(src, dst, [distance_type], [mask_size], [mask], [labels]);
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvDistTransform;
}

sub EqualizeHist {
	# EqualizeHist(src, dst)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvEqualizeHist;
}

sub Inpaint {
	# Inpaint(src, mask, dst, inpaintRadius, flags)
	my ($src, $mask) = splice(@_, 0, 2);
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $mask, $dst);
	goto &cvInpaint;
}

sub Integral {
	# Integral(image, sum, [sqsum], [tiltedSum])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvIntegral;
}

sub PyrMeanShiftFiltering {
	# PyrMeanShiftFiltering(src, dst, sp, sr, [max_level], [termcrit])
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvPyrMeanShiftFiltering;
}

sub PyrSegmentation {
	# PyrSegmentation(src, dst, storage, comp, level, threshold1, threshold2)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvPyrSegmentation;
}

sub Threshold {
	# Threshold(src, dst, threshold, maxValue, thresholdType)
	my $src = shift;
	my $dst = dst(@_) || $src->new($src->sizes, Cv::MAKETYPE(Cv::MAT_DEPTH($src->type), 1));
	unshift(@_, $src, $dst);
	goto &cvThreshold;
}

# ============================================================
#  imgproc. Image Processing: Structural Analysis and Shape Descriptors
# ============================================================

# ============================================================
#  imgproc. Image Processing: Planar Subdivisions
# ============================================================

# ============================================================
#  imgproc. Image Processing: Motion Analysis and Object Tracking
# ============================================================

# ============================================================
#  imgproc. Image Processing: Feature Detection
# ============================================================

sub Canny {
	# Canny(image, edges, threshold1, threshold2, aperture_size=3)
	my $src = shift;
	my $dst = dst(@_) || $src->new;
	unshift(@_, $src, $dst);
	goto &cvCanny;
}

# ============================================================
#  imgproc. Image Processing: Object Detection
# ============================================================

# ============================================================
#  features2d. Feature Detection and Descriptor Extraction:
#    Feature detection and description
# ============================================================

# ============================================================
#  flann. Clustering and Search in Multi-Dimensional Spaces:
#    Fast Approximate Nearest Neighbor Search
# ============================================================

# ============================================================
#  objdetect. Object Detection: Cascade Classification
# ============================================================

# ============================================================
#  video. Video Analysis: Motion Analysis and Object Tracking
# ============================================================

# ============================================================
#  highgui. High-level GUI and Media I/O: User Interface
# ============================================================

# ============================================================
#  highgui. High-level GUI and Media I/O: Reading and Writing Images and Video
# ============================================================

# ============================================================
#  highgui. High-level GUI and Media I/O: Qt new functions
# ============================================================

1;
__END__
