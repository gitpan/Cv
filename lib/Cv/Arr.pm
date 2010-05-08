# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Arr;

use 5.008000;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);
use Data::Dumper;

BEGIN {
	$Data::Dumper::Terse = 1;
}

use Cv::Constant;
use Cv::CxCore qw(:all);

our @ISA = qw(Exporter);

our @EXPORT = (
	);

our %EXPORT_TAGS = (
	'all' => [ ]
	);

our @EXPORT_OK = (
	@{ $EXPORT_TAGS{'all'} },
	);

our $VERSION = '0.03';

our %IMAGES = ();


# ######################################################################
# ### CxCORE ###########################################################
# ######################################################################

# ######################################################################
#  Operations on Arrays
# ######################################################################

# ======================================================================
#  Initialization
# ======================================================================

# ------------------------------------------------------------
#  CreateImage - Creates header and allocates data
#  ReleaseImage - Releases header and image data
#  CloneImage - Makes a full copy of image
#  SetImageCOI - Sets channel of interest to given value
#  GetImageCOI - Returns index of channel of interest
#  SetImageROI - Sets image ROI to given rectangle
#  ResetImageROI - Releases image ROI
#  GetImageROI - Returns image ROI coordinates
#  (see Cv::Image)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CreateMat - Creates new matrix
#  CreateMatHeader - Creates new matrix header
#  ReleaseMat - Deallocates matrix
#  InitMatHeader - Initializes matrix header
#  Mat - Initializes matrix header (light-weight variant)
#  CloneMat - Creates matrix copy
#  CreateMatND - Creates multi-dimensional dense array
#  CreateMatNDHeader - Creates new matrix header
#  ReleaseMatND - Deallocates multi-dimensional array
#  InitMatNDHeader - Initializes multi-dimensional array header
#  CloneMatND - Creates full copy of multi-dimensional array
#  GetMat - Returns matrix header for arbitrary array
#  CreateSparseMat - Creates sparse array
#  ReleaseSparseMat - Deallocates sparse array
#  CloneSparseMat - Creates full copy of sparse array
#  (see Cv::Mat)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  DecRefData - Decrements array data reference counter
# ------------------------------------------------------------

# ------------------------------------------------------------
#  IncRefData - Increments array data reference counter
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CreateData - Allocates array data
# ------------------------------------------------------------

# ------------------------------------------------------------
#  ReleaseData - Releases array data
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SetData - Assigns user data to the array header
# ------------------------------------------------------------

# ------------------------------------------------------------
#  GetRawData - Retrieves low-level information about the array
# ------------------------------------------------------------

# ------------------------------------------------------------
#  GetMat - Returns matrix header for arbitrary array
# ------------------------------------------------------------

# ------------------------------------------------------------
#  GetImage - Returns image header for arbitrary array
# ------------------------------------------------------------


# ======================================================================
#  2.2. Accessing Elements and sub-Arrays
# ======================================================================

# ------------------------------------------------------------
#  GetSubRect - Returns matrix header corresponding to the rectangular
#          sub-array of input image or matrix
# ------------------------------------------------------------
sub GetSubRect {
	my $self = shift;
	my %av = &argv([ -rect => undef,
					 -submat => undef,
					 -arr => $self,
				   ], @_);
	$av{-submat} ||= $av{-dst};
	unless (blessed($av{-arr}) &&
			blessed($av{-submat}) &&
			defined($av{-rect})) {
		chop(my $usage = <<"----"
usage:	Cv->GetSubRect(
	-submat => Pointer to the resultant sub-array header.
	-rect => Zero-based coordinates of the rectangle of interest.
	-arr => Input array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetSubRect($av{-arr},
				 $av{-submat},
				 pack("i4", @{$av{-rect}}));
	$av{-submat};
}

#------------------------------------------------------------
# GetRow, GetRows
#------------------------------------------------------------
sub GetRow {
	my $self = shift;
	my %av = &argv([ -row => undef,
					 -submat => undef,
					 -arr => $self,
				   ], @_);
	$av{-submat} ||= $av{-dst};
	$av{-arr}->GetRows(
		-submat => $av{-submat},
		-start => $av{-row}, -end => $av{-row} + 1,
		);
}

sub GetRows {
	my $self = shift;
	my %av = &argv([ -start_row => undef,
					 -end_row => undef,
					 -delta_row => undef,
					 -submat => undef,
					 -arr => $self,
				   ], @_);
	$av{-start_row} ||= $av{-start} || 0;
	$av{-end_row} ||= $av{-end} || 0;
	$av{-delta_row} ||= $av{-delta} || 1;
	$av{-submat} ||= $av{-dst};

	# XXXXX
	$av{-submat} ||= Cv::Mat->new(
		-rows => 1, -cols => 1,
		-type => $av{-arr}->GetElemType,
		);
	unless (blessed($av{-arr}) &&
			blessed($av{-submat}) &&
			defined($av{-start_row}) &&
			defined($av{-end_row}) &&
			defined($av{-delta_row})) {
		chop(my $usage = <<"----"
usage:	Cv->GetRows(
	-arr => Input array. 
	-submat => Pointer to the resulting sub-array header. 
	-start_row => Zero-based index of the starting row (inclusive) of the
	        span. 
	-end_row =>Zero-based index of the ending row (exclusive) of the span. 
	-delta_row => Index step in the row span. That is, the function extracts
	        every delta_row-th row from start_row and up to (but not
	        including) end_row.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetRows(
		$av{-arr},
		$av{-submat},
		$av{-start_row},
		$av{-end_row},
		$av{-delta_row},
		);
	$av{-submat};
}


# ------------------------------------------------------------
#  GetCol, GetCols - Returns array column or column span
# ------------------------------------------------------------
sub GetCol {
	my $self = shift;
	my %av = &argv([ -col => undef,
					 -submat => undef,
					 -arr => $self,
				   ], @_);
	$av{-submat} ||= $av{-dst};
	$av{-arr}->GetCols(
		-submat => $av{-submat},
		-start => $av{-col}, -end => $av{-col} + 1,
		);
}

sub GetCols {
	my $self = shift;
	my %av = &argv([ -start_col => undef,
					 -end_col => undef,
					 -submat => undef,
					 -arr => $self,
				   ], @_);
	$av{-start_col} ||= $av{-start} || 0;
	$av{-end_col} ||= $av{-end} || 0;
	$av{-submat} ||= $av{-dst};

	# XXXXX	
	$av{-submat} ||= Cv::Mat->new(
		-rows => 1, -cols => 1,
		-type => $av{-arr}->GetElemType
		);
	unless (blessed($av{-arr}) &&
			blessed($av{-submat}) &&
			defined($av{-start_col}) &&
			defined($av{-end_col})) {
		chop(my $usage = <<"----"
usage:	Cv->GetCols(
	-arr => Input array. 
	-submat => Pointer to the resulting sub-array header. 
	-col => Zero-based index of the selected column. 
	-start_col => Zero-based index of the starting column (inclusive) of the
	        span. 
	-end_col =>Zero-based index of the ending column (exclusive) of the span.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetCols(
		$av{-arr},
		$av{-submat},
		$av{-start_col},
		$av{-end_col},
		);
	$av{-submat};
}

# ------------------------------------------------------------
#  GetDiag - Returns one of array diagonals
# ------------------------------------------------------------

# ------------------------------------------------------------
#  GetSize - Returns size of matrix or image ROI
# ------------------------------------------------------------
sub GetSize {
    my $self = shift;
	my @size = unpack("i2", cvGetSize($self));
	wantarray? @size : \@size;
}

sub width {
	my $self = shift;
	${$self->GetSize}[0];
}

sub height {
	my $self = shift;
	${$self->GetSize}[1];
}


# ------------------------------------------------------------
#  InitSparseMatIterator - Initializes sparse array elements iterator
# ------------------------------------------------------------

# ------------------------------------------------------------
#  GetNextSparseNode - Initializes sparse array elements iterator
# ------------------------------------------------------------

# ------------------------------------------------------------ 
#  GetElemType - Returns type of array elements
# ------------------------------------------------------------
sub GetElemType {
    my $self = shift;
	cvGetElemType($self);
}

# ------------------------------------------------------------ 
#  GetDims, GetDimSize - Return number of array dimensions and their sizes
# ------------------------------------------------------------
sub GetDims {
    my $self = shift;
	my $dims = cvGetDims($self);
	wantarray? @$dims : $dims;
}

sub GetDimSize {
    my $self = shift;
	my $index = shift || 0;
	my @dims = $self->GetDims;
	$dims[$index];
}


# ------------------------------------------------------------ 
#  Ptr*D - Return pointer to the particular array element
# ------------------------------------------------------------
sub PtrD {
	my $self = shift;
	my %av = &argv([ -idx => undef,
					 -type => undef,
					 -arr => $self,
				   ], @_);

	my @idx = defined $av{-idx}? &cvIndex($av{-idx}) : &cvIndex(%av);
	unless (defined $av{-arr} && @idx > 0) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv->GetD(
	-idx0 => The first zero-based component of the element index 
	-idx1 => The second zero-based component of the element index 
	-idx2 => The third zero-based component of the element index 
	-idx => Array of the element indices 
	-type => Optional output parameter: type of matrix elements
	-arr => Input array, (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	my $r = undef; my $type = undef;
	$r = cvPtr1D($av{-arr}, @idx, $type) if (@idx == 1);
	$r = cvPtr2D($av{-arr}, @idx, $type) if (@idx == 2);
	$r = cvPtr3D($av{-arr}, @idx, $type) if (@idx == 3);
	goto usage unless (defined $r);
	goto usage unless (defined $type);
	if (defined $av{-type} && ref $av{-type} eq 'SCALAR') {
		${$av{-type}} = $type;
	}
	if ($type == CV_8SC1 || $type == CV_8SC2 ||
		$type == CV_8SC3 || $type == CV_8SC4) {
		wantarray ? unpack("c*", $r) : [unpack("c*", $r)];
	} elsif ($type == CV_8UC1 || $type == CV_8UC2 ||
			 $type == CV_8UC3 || $type == CV_8UC4) {
		wantarray ? unpack("C*", $r) : [unpack("C*", $r)];
	} elsif ($type == CV_16SC1 || $type == CV_16SC2 ||
			 $type == CV_16SC3 || $type == CV_16SC4) {
		wantarray ? unpack("s*", $r) : [unpack("s*", $r)];
	} elsif ($type == CV_16UC1 || $type == CV_16UC2 ||
			 $type == CV_16UC3 || $type == CV_16UC4) {
		wantarray ? unpack("S*", $r) : [unpack("S*", $r)];
	} elsif ($type == CV_32SC1 || $type == CV_32SC2 ||
			 $type == CV_32SC3 || $type == CV_32SC4) {
		wantarray ? unpack("l*", $r) : [unpack("l*", $r)];
	} elsif ($type == CV_32FC1 || $type == CV_32FC2 ||
			 $type == CV_32FC3 || $type == CV_32FC4) {
		wantarray ? unpack("f*", $r) : [unpack("f*", $r)];
	} elsif ($type == CV_64FC1 || $type == CV_64FC2 ||
			 $type == CV_64FC3 || $type == CV_64FC4) {
		wantarray ? unpack("d*", $r) : [unpack("d*", $r)];
	} else {
		goto usage;
	}
}

# ------------------------------------------------------------
#  Get*D - Return the particular array element
# ------------------------------------------------------------
sub GetD {
	my $self = shift;
	my %av = &argv([ -idx => undef,
					 -arr => $self,
				   ], @_);

	my @idx = defined $av{-idx}? &cvIndex($av{-idx}) : &cvIndex(%av);
	unless (defined $av{-arr} && @idx > 0) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv->GetD(
	-idx0 => The first zero-based component of the element index 
	-idx1 => The second zero-based component of the element index 
	-idx2 => The third zero-based component of the element index 
	-idx => Array of the element indices 
	-arr => Input array, (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $r = undef;
	$r = cvGet1D($av{-arr}, @idx) if (@idx == 1);
	$r = cvGet2D($av{-arr}, @idx) if (@idx == 2);
	$r = cvGet3D($av{-arr}, @idx) if (@idx == 3);
	goto usage unless (defined $r);
	wantarray ? unpack("d*", $r) : [unpack("d*", $r)];
}

sub Get1D {
	my $self = shift;
	$self->GetD(@_);
}

sub Get2D {
	my $self = shift;
	$self->GetD(@_);
}

sub Get3D {
	my $self = shift;
	$self->GetD(@_);
}

# ------------------------------------------------------------
#  GetReal*D - Return the particular element of single-channel array
# ------------------------------------------------------------
sub GetRealD {
	my $self = shift;
	my %av = &argv([ -idx => undef,
					 -arr => $self,
				   ], @_);

	my @idx = defined $av{-idx}? &cvIndex($av{-idx}) : &cvIndex(%av);
	unless (defined $av{-arr} && @idx > 0) {
		chop(my $usage = <<"----"
usage:	Cv->GetRealD(
	-idx0 => The first zero-based component of the element index 
	-idx1 => The second zero-based component of the element index 
	-idx2 => The third zero-based component of the element index 
	-idx => Array of the element indices 
	-arr => Input array. Must have a single channel. (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (@idx == 1) {
		cvGetReal1D($av{-arr}, @idx);
	} elsif (@idx == 2) {
		cvGetReal2D($av{-arr}, @idx);
	} elsif (@idx == 3) {
		cvGetReal3D($av{-arr}, @idx);
	} else {
		goto usage;
	}
}

sub GetReal1D {
	my $self = shift;
	$self->GetRealD(@_);
}

sub GetReal2D {
	my $self = shift;
	$self->GetRealD(@_);
}

sub GetReal3D {
	my $self = shift;
	$self->GetRealD(@_);
}

# ------------------------------------------------------------
#  mGet - Return the particular element of single-channel floating-point matrix
# ------------------------------------------------------------

# ------------------------------------------------------------
#  Set*D - Change the particular array element
# ------------------------------------------------------------
sub SetD {
	my $self = shift;
	my %av = &argv([ -idx => undef,
					 -value => undef,
					 -arr => $self,
				   ], @_);

	my @idx = defined $av{-idx}? &cvIndex($av{-idx}) : &cvIndex(%av);
	unless (defined $av{-arr} && @idx > 0 &&
			defined $av{-value}) {
		chop(my $usage = <<"----"
usage:	Cv->SetD(
	-idx0 => The first zero-based component of the element index 
	-idx1 => The second zero-based component of the element index 
	-idx2 => The third zero-based component of the element index 
	-idx => Array of the element indices,
	-value => The assigned value,
	-arr => Input array, (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my @val = &cvScalar($av{-value});
	cvSet1D($av{-arr}, @idx, pack("d4", @val)) if (@idx == 1);
	cvSet2D($av{-arr}, @idx, pack("d4", @val)) if (@idx == 2);
	cvSet3D($av{-arr}, @idx, pack("d4", @val)) if (@idx == 3);
}

sub Set1D {
	my $self = shift;
	$self->SetD(@_);
}

sub Set2D {
	my $self = shift;
	$self->SetD(@_);
}

sub Set3D {
	my $self = shift;
	$self->SetD(@_);
}


# ------------------------------------------------------------
#  SetReal*D - Change the particular array element
# ------------------------------------------------------------
sub SetRealD {
	my $self = shift;
	my %av = &argv([ -idx => undef,
					 -value => undef,
					 -arr => $self,
				   ], @_);

	my @idx = defined $av{-idx}? &cvIndex($av{-idx}) : &cvIndex(%av);
	unless (defined $av{-arr} && @idx > 0 &&
			defined $av{-value}) {
		chop(my $usage = <<"----"
usage:	Cv->SetRealD(
	-idx => Array of the element indices,
	-value => The assigned value,
	-arr => Input array, (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSetReal1D($av{-arr}, @idx, $av{-value}) if (@idx == 1);
	cvSetReal2D($av{-arr}, @idx, $av{-value}) if (@idx == 2);
	cvSetReal3D($av{-arr}, @idx, $av{-value}) if (@idx == 3);
}

sub SetReal1D {
	my $self = shift;
	$self->SetRealD(@_);
}

sub SetReal2D {
	my $self = shift;
	$self->SetRealD(@_);
}

sub SetReal3D {
	my $self = shift;
	$self->SetRealD(@_);
}

# ------------------------------------------------------------
#  mSet - Return the particular element of single-channel floating-point matrix
# ------------------------------------------------------------

# ------------------------------------------------------------
#  ClearND - Clears the particular array element
# ------------------------------------------------------------


# ======================================================================
#  2.3. Copying and Filling
# ======================================================================

# ------------------------------------------------------------
#   Copy - Copies one array to another
# ------------------------------------------------------------
sub Copy {
	my $self = shift;
	my %av = &argv([ -dst => undef,
					 -mask => \0,
					 -src => $self,
				   ], @_);
	unless (blessed($av{-src})) {
		chop(my $usage = <<"----"
usage:	Cv->Copy(
	-src => The source array. (default: $self)
	-dst => The destination array. 
	-mask => Operation mask, 8-bit single channel array; specifies elements of
	         destination array to be changed.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new;
    cvCopy(
		$av{-src},
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}

# ------------------------------------------------------------
#   Set - Sets every element of array to given value
# ------------------------------------------------------------
sub Set {
	my $self = shift;
	my %av = &argv([ -value => undef,
					 -mask => \0,
					 -arr => $self,
				   ], @_);
	unless (defined($av{-arr}) &&
			defined($av{-value})) {
		chop(my $usage = <<"----"
usage:	Cv->Set(
	-arr => The destination array. 
	-value => Fill value. 
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSet(
		$av{-arr},
		pack("d4", cvScalar($av{-value})),
		$av{-mask},
		);
	$av{-arr};
}

# ------------------------------------------------------------
#   SetZero, Zero - Clears the array
# ------------------------------------------------------------

sub Zero {
	my $self = shift;
	my %av = &argv([ -arr => $self,
				   ], @_);
	cvZero($av{-arr});
	$av{-arr};
}

sub SetZero {
 	my $self = shift;
 	$self->Zero;
}

# ------------------------------------------------------------
#   SetIdentity - Initializes scaled identity matrix
# ------------------------------------------------------------
sub SetIdentity {
	my $self = shift;
	my %av = &argv([ -value => 1,
					 -mat => $self,
				   ], @_);
	unless (blessed($av{-mat})) {
		chop(my $usage = <<"----"
usage:	Cv->SetIdentity(
	-mat => The matrix to initialize (not necessarily square). 
	-value => The value to assign to the diagonal elements.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSetIdentity(
		$av{-mat},
		pack("d*", cvScalar($av{-value})),
		);
	$av{-mat};
}

# ------------------------------------------------------------
#   Range - Fills matrix with given range of numbers
# ------------------------------------------------------------

# ======================================================================
#  2.4. Transforms and Permutations
# ======================================================================

# ------------------------------------------------------------
#   Reshape - Changes shape of matrix/image without copying data
# ------------------------------------------------------------

# ------------------------------------------------------------
#   ReshapeMatND - Changes shape of multi-dimensional array w/o copying data
# ------------------------------------------------------------

# ------------------------------------------------------------
#   Repeat - Fill destination array with tiled source array
# ------------------------------------------------------------

# ------------------------------------------------------------
#   Flip - Flip a 2D array around vertical, horizontal or both axises
# ------------------------------------------------------------
sub Flip {
	my $self = shift;
	my %av = &argv([ -flip_mode => 0,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (defined($av{-src}) &&
			defined $av{-flip_mode}) {
		chop(my $usage = <<"----"
usage:	Cv->Flip(
	-src => Source array. 
	-dst => Destination array. If dst = NULL the flipping is done in-place. 
	-flip_mode => Specifies how to flip the array.  flip_mode = 0 means flipping
	        around x-axis, flip_mode > 0 (e.g. 1) means flipping around Y-axis
	        and flip_mode < 0 (e.g. -1) means flipping around both axises. See
	        also the discussion below for the formulas.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	#$av{-dst} ||= $av{-src};
	$av{-dst} ||= $av{-src}->new; # 29mar10
	cvFlip(
		$av{-src},
		$av{-dst},
		$av{-flip_mode});
    $av{-dst};
}

# ------------------------------------------------------------
#   Split - Divides multi-channel array into several single-channel
#           arrays or extracts a single channel from the array
# ------------------------------------------------------------
sub Split {
	my $self = shift;
	my %av = &argv([ -dst0 => undef,
					 -dst1 => undef,
					 -dst2 => undef,
					 -dst3 => undef,
					 -src => $self,
				   ], @_);
	$av{-dst0} ||= $av{-dst}; delete $av{-dst};
	if (ref $av{-dst0} eq 'ARRAY') {
		($av{-dst0}, $av{-dst1}, $av{-dst2}, $av{-dst3}) = @{$av{-dst0}};
	}
	if (!defined $av{-src} ||
		(!defined $av{-dst0} && !defined $av{-dst1} &&
		 !defined $av{-dst2} && !defined $av{-dst3}) ) {
		chop(my $usage = <<"----"
usage:	Cv->Split(
	-dst0 => Destination channels.
	-dst1 => Destination channels.
	-dst2 => Destination channels.
	-dst3 => Destination channels.
	-src => Source array. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSplit(
		$av{-src},
		$av{-dst0} || \0,
		$av{-dst1} || \0,
		$av{-dst2} || \0,
		$av{-dst3} || \0,
		);
	my @dsts = ($av{-dst0}, $av{-dst1}, $av{-dst2}, $av{-dst3});
	wantarray ? @dsts : \@dsts;
}

# ------------------------------------------------------------
#   Merge - Composes multi-channel array from several single-channel
#           arrays or inserts a single channel into the array
# ------------------------------------------------------------
sub Merge {
	my $self = shift;
	my %av = &argv([ -src0 => undef,
					 -src1 => undef,
					 -src2 => undef,
					 -src3 => undef,
					 -dst => $self,
				   ], @_);
	$av{-src0} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src0} eq 'ARRAY') {
		($av{-src0}, $av{-src1}, $av{-src2}, $av{-src3}) = @{$av{-src0}};
	}
	if (!defined $av{-dst} || 
		(!defined $av{-src0} && !defined $av{-src1} &&
		 !defined $av{-src2} && !defined $av{-src3})) {
		chop(my $usage = <<"----"
usage:	Cv->Merge(
	-srcX => Input channels.
	-dst => Destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvMerge(
		$av{-src0} || \0,
		$av{-src1} || \0,
		$av{-src2} || \0,
		$av{-src3} || \0,
		$av{-dst},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#   MixChannels - Copies several channels from input arrays to certain
#                 channels of output arrays
# ------------------------------------------------------------

# ------------------------------------------------------------
#   RandShuffle - Randomly shuffles the array elements
# ------------------------------------------------------------


# ======================================================================
#  2.5. Arithmetic, Logic and Comparison
# ======================================================================
# ------------------------------------------------------------
#   LUT - Performs look-up table transform of array
# ------------------------------------------------------------
sub LUT {
	my $self = shift;
	my %av = &argv([ -lut => undef,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (defined($av{-src}) &&
			# defined($av{-dst}) &&
			defined($av{-lut})) {
		chop(my $usage = <<"----"
usage:	Cv->LUT(
	-src => Source array of 8-bit elements.
	-dst => Destination array of arbitrary depth and of the same number of
	        channels as the source array.
	-lut => Look-up table of 256 elements; should have the same depth as the
	        destination array. In case of multi-channel source and
	        destination arrays, the table should either have a
	        single-channel (in this case the same table is used for all
	        channels), or the same number of channels as the
	        source/destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
    $av{-dst} ||= $av{-src}->new; # 29mar10
    cvLUT(
		$av{-src},
		$av{-dst},
		$av{-lut},
		);
	$av{-dst};
}

# ------------------------------------------------------------
#  ConvertScale - Converts one array to another with optional linear
#                 transformation
# ------------------------------------------------------------
sub ConvertScale {
	my $self = shift;
	my %av = &argv([ -scale => 1,
					 -shift => 0,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (defined($av{-src}) &&
			# defined($av{-dst}) &&
			defined($av{-scale}) &&
			defined($av{-shift})) {
		chop(my $usage = <<"----"
usage:	Cv->ConvertScale(
	-src => Source array. 
	-dst => Destination array. 
	-scale => Scale factor. 
	-shift => Value added to the scaled source array elements.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
 	$av{-dst} ||= $av{-src}->new; # 29mar10
 	cvConvertScale(
		$av{-src},
		$av{-dst},
		$av{-scale},
		$av{-shift},
		);
 	$av{-dst};
}

sub CvtScale {
	my $self = shift;
 	$self->ConvertScale(@_);
}

sub Scale {
	my $self = shift;
 	$self->ConvertScale(@_);
}

sub Convert {
	my $self = shift;
 	$self->ConvertScale(@_);
}

# ------------------------------------------------------------
#  ConvertScaleAbs - Converts input array elements to 8-bit unsigned
#                    integer another with optional linear transformation
# ------------------------------------------------------------
sub ConvertScaleAbs {
	my $self = shift;
	my %av = &argv([ -scale => 1,
					 -shift => 0,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (defined($av{-src}) &&
			defined($av{-scale}) &&
			defined($av{-shift})) {
		chop(my $usage = <<"----"
usage:	Cv->ConvertScale(
	-src => Source array. 
	-dst => Destination array. 
	-scale => Scale factor. 
	-shift => Value added to the scaled source array elements.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
 	$av{-dst} ||= $av{-src}->new(-depth => IPL_DEPTH_8U);
 	cvConvertScaleAbs(
		$av{-src},
		$av{-dst},
		$av{-scale},
		$av{-shift},
		);
 	$av{-dst};
}


sub CvtScaleAbs {
	my $self = shift;
 	$self->ConvertScaleAbs(@_);
}


# ------------------------------------------------------------
#  Add - Computes per-element sum of two arrays
# ------------------------------------------------------------
sub Add {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -mask => \0,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	unless (blessed($av{-src1}) &&
			blessed($av{-src2}) &&
			# blessed($av{-dst}) &&
			(blessed($av{-mask}) || ref($av{-mask}))) {
		chop(my $usage = <<"----"
usage:	Cv->Add(
	-src1 => The first source array.
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed. 
	-src2 => The second source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
    cvAdd($av{-src1}, $av{-src2}, $av{-dst}, $av{-mask});
	$av{-dst};
}

# ------------------------------------------------------------
#  AddS - Computes sum of array and scalar
# ------------------------------------------------------------
sub AddS {
	my $self = shift;
	my %av = &argv([ -value => [ 0, 0, 0, 0 ],
					 -mask => \0,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (blessed($av{-src}) &&
			# blessed($av{-dst}) &&
			defined $av{-value} &&
			(blessed($av{-mask}) || ref($av{-mask}))) {
		chop(my $usage = <<"----"
usage:	Cv->AddS(
	-value => Added scalar.
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed.
	-src => The source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
    cvAddS(
		$av{-src},
		pack("d4", cvScalar($av{-value})),
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  AddWeighted - Computes weighted sum of two arrays
# ------------------------------------------------------------
sub AddWeighted {
	my $self = shift;
	my %av = &argv([ -src1 => undef,
					 -alpha => 0.5,
					 -src2 => undef,
					 -beta => 0.5,
					 -gamma => 0.0,
					 -dst => undef,
				   ], @_);
	$av{-src1} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src1} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src1}};
	}
	$av{-src1} = $self if (!defined($av{-src1}) &&  defined($av{-src2}));
	$av{-src2} = $self if ( defined($av{-src1}) && !defined($av{-src2}));
	unless (blessed($av{-src1}) &&
			blessed($av{-src2})
			# blessed($av{-dst})
		) {
		chop(my $usage = <<"----"
usage:	Cv->AddWeighted(
	-src1 => The first source array.
	-alpha => Weight of the first array elements.
	-src2 => The second source array.
	-beta => Weight of the second array elements.
	-gamma => Scalar, added to each sum.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
    cvAddWeighted(
		$av{-src1}, $av{-alpha},
		$av{-src2}, $av{-beta},
		$av{-gamma},
		$av{-dst},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  Sub - Computes per-element difference between two arrays
# ------------------------------------------------------------
sub Sub {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -mask => \0,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	unless (blessed($av{-src1}) && blessed($av{-src2})) {
		chop(my $usage = <<"----"
usage:	Cv->Sub(
	-src1 => The first source array.
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed. 
	-src2 => The second source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
    cvSub(
		$av{-src1},
		$av{-src2},
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  SubS - Computes difference between array and scalar
# ------------------------------------------------------------
sub SubS {
	my $self = shift;
	my %av = &argv([ -value => [ 0, 0, 0, 0 ],
					 -mask => \0,
					 -dst => undef,
					 -src => $self,
				   ], @_);

	unless (blessed($av{-src}) && defined($av{-value})) {
		chop(my $usage = <<"----"
usage:	Cv->SubS(
	-src (opt) => The source array.
	-value => Subtracted scalar.
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed.
	-dst (opt) => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
    cvSubS(
		$av{-src},
		pack("d4", cvScalar($av{-value})),
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  SubRS - Computes difference between scalar and array
# ------------------------------------------------------------
sub SubRS {
	my $self = shift;
	my %av = &argv([ -value => [ 0, 0, 0, 0 ],
					 -mask => \0,
					 -dst => undef,
					 -src => $self,
				   ], @_);

	unless (blessed($av{-src}) && defined($av{-value})) {
		chop(my $usage = <<"----"
usage:	Cv->SubRS(
	-src => The source array.
	-value => Subtracted scalar.
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
    cvSubRS(
		$av{-src},
		pack("d4", cvScalar($av{-value})),
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#   Mul - Calculates per-element product of two arrays
# ------------------------------------------------------------
sub Mul {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -scale => 1,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	unless (blessed($av{-src1}) && blessed($av{-src2})) {
		chop(my $usage = <<"----"
usage:	Cv->Mul(
	-src2 => The second source array.
	-src1 => The first source array.
	-dst => The destination array.
	-scale => Optional scale factor.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
	cvMul($av{-src1}, $av{-src2}, $av{-dst}, $av{-scale});
	$av{-dst};
}


# ------------------------------------------------------------
#  Div - Performs per-element division of two arrays
# ------------------------------------------------------------
sub Div {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -scale => 1,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	unless (blessed($av{-src1}) && blessed($av{-src2})) {
		chop(my $usage = <<"----"
usage:	Cv->Div(
	-src2 => The second source array.
	-src1 => The first source array.
	-dst => The destination array.
	-scale => Optional scale factor.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
	cvDiv($av{-src1}, $av{-src2}, $av{-dst}, $av{-scale});
	$av{-dst};
}


# ------------------------------------------------------------
#  And - Calculates per-element bit-wise conjunction of two arrays
# ------------------------------------------------------------
sub And {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -mask => \0,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	unless (blessed($av{-src1}) && blessed($av{-src2})) {
		chop(my $usage = <<"----"
usage:	Cv->And(
	-src1 => The first source array.
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed. 
	-src2 => The second source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
	cvAnd(
		$av{-src1},
		$av{-src2},
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  AndS - Calculates per-element bit-wise conjunction of array and scalar
# ------------------------------------------------------------
sub AndS {
	my $self = shift;
	my %av = &argv([ -value => [ 0, 0, 0, 0 ],
					 -mask => \0,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (blessed($av{-src}) && defined($av{-value})) {
		chop(my $usage = <<"----"
usage:	Cv->AndS(
	-value => Scalar to use in the operation.
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed. 
	-src => The source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
    cvAndS(
		$av{-src},
		pack("d4", cvScalar($av{-value})),
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  Or - Calculates per-element bit-wise disjunction of two arrays
# ------------------------------------------------------------
sub Or {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -mask => \0,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	unless (blessed($av{-src1}) && blessed($av{-src2})) {
		chop(my $usage = <<"----"
usage:	Cv->Or(
	-src1 => The first source array.
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed. 
	-src2 => The second source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
	cvOr(
		$av{-src1},
		$av{-src2},
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  OrS - Calculates per-element bit-wise disjunction of array and scalar
# ------------------------------------------------------------
sub OrS {
	my $self = shift;
	my %av = &argv([ -value => [ 0, 0, 0, 0 ],
					 -mask => \0,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (blessed($av{-src}) && defined($av{-value})) {
		chop(my $usage = <<"----"
usage:	Cv->OrS(
	-value => Scalar to use in the operation.
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed. 
	-src => The source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
    cvOrS(
		$av{-src},
		pack("d4", cvScalar($av{-value})),
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  Xor - Performs per-element bit-wise "exclusive or" operation on two arrays
# ------------------------------------------------------------
sub Xor {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -mask => \0,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	unless (blessed($av{-src1}) && blessed($av{-src2})) {
		chop(my $usage = <<"----"
usage:	Cv->Xor(
	-src1 => The first source array.
	-mask => Operation mask, 8-bit single channel array; specifies elements of
	        destination array to be changed. 
	-src2 => The second source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
	cvXor(
		$av{-src1},
		$av{-src2},
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  XorS - Performs per-element bit-wise "exclusive or" operation on
#         array and scalar
# ------------------------------------------------------------
sub XorS {
	my $self = shift;
	my %av = &argv([ -value => [ 0, 0, 0, 0 ],
					 -mask => \0,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (blessed($av{-src}) && defined($av{-value})) {
		chop(my $usage = <<"----"
usage:	Cv->XorS(
	-value => Scalar to use in the operation.
	-mask => Operation mask, 8-bit single channel array; specifies elements
	        of destination array to be changed. 
	-src => The source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
    cvXorS(
		$av{-src},
		pack("d4", cvScalar($av{-value})),
		$av{-dst},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  Not -  Performs per-element bit-wise inversion of array elements
# ------------------------------------------------------------
sub Not {
	my $self = shift;
	my %av = &argv([ -dst => undef,
					 -src => $self,
				   ], @_);
	unless (blessed($av{-src})) {
		chop(my $usage = <<"----"
usage:	Cv->Not(
	-dst => The destination array.
	-src => The source array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
	cvNot($av{-src}, $av{-dst});
	$av{-dst};
}


# ------------------------------------------------------------
#  Cmp - Performs per-element comparison of two arrays
# ------------------------------------------------------------
sub Cmp {
	my $self = shift;
	my %av = &argv([ -cmp_op => undef,
					 -src2 => undef,
					 -src1 => $self,
					 -dst => undef,
				   ], @_);
	$av{-dst} ||= $self->new(-depth => &IPL_DEPTH_8U, -channels => 1);
	unless (blessed $av{-src1} && blessed $av{-src2} &&
			defined $av{-cmp_op}) {
		chop(my $usage = <<"----"
usage:	Cv->Cmp(
	-src2 => The second source array.
	-cmp_op => The flag specifying the relation between the
	        elements to be checked:
	          CV_CMP_EQ - src1(I) "equal to" src2(I)
	          CV_CMP_GT - src1(I) "greater than" src2(I)
	          CV_CMP_GE - src1(I) "greater or equal" src2(I)
	          CV_CMP_LT - src1(I) "less than" src2(I)
	          CV_CMP_LE - src1(I) "less or equal" src2(I)
	          CV_CMP_NE - src1(I) "not equal to" src2(I)
	-src1 => The first source array.
	-dst => The destination array, must have 8u or 8s type.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCmp($av{-src1}, $av{-src2}, $av{-dst}, $av{-cmp_op});
	$av{-dst};
}


# ------------------------------------------------------------
#  CmpS - Performs per-element comparison of array and scalar
# ------------------------------------------------------------
sub CmpS {
	my $self = shift;
	my %av = &argv([ -value => undef,
					 -cmp_op => undef,
					 -src => $self,
					 -dst => undef,
				   ], @_);
	$av{-dst} ||= $self->new(-depth => &IPL_DEPTH_8U, -channels => 1);
	unless (blessed $av{-src} &&
			defined $av{-value} && defined $av{-cmp_op}) {
		chop(my $usage = <<"----"
usage:	Cv->CmpS(
	-value => The scalar value to compare each array element with.
	-cmp_op => The flag specifying the relation between the
	        elements to be checked:
	          CV_CMP_EQ - src1(I) "equal to" src2(I)
	          CV_CMP_GT - src1(I) "greater than" src2(I)
	          CV_CMP_GE - src1(I) "greater or equal" src2(I)
	          CV_CMP_LT - src1(I) "less than" src2(I)
	          CV_CMP_LE - src1(I) "less or equal" src2(I)
	          CV_CMP_NE - src1(I) "not equal to" src2(I)
	-src => The first source array.
	-dst => The destination array, must have 8u or 8s type.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCmpS($av{-src}, $av{-value}, $av{-dst}, $av{-cmp_op});
	$av{-dst};
}


# ------------------------------------------------------------
#  InRange - Checks that array elements lie between elements of two
#            other arrays
# ------------------------------------------------------------
sub InRange {
	my $self = shift;
	my %av = &argv([ -lower => undef,
					 -upper => undef,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $self->new(-depth => &IPL_DEPTH_8U, -channels => 1);
	unless (blessed($av{-src}) &&
			defined($av{-lower}) && defined($av{-upper})) {
		chop(my $usage = <<"----"
usage:	Cv->InRange(
	-src => The first source array. 
	-lower => The inclusive lower boundary array. 
	-upper => The exclusive upper boundary array. 
	-dst => The destination array, must have 8u or 8s type.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
    cvInRange(
		$av{-src},
		$av{-lower},
		$av{-upper},
		$av{-dst},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  InRangeS - Checks that array elements lie between two scalars
# ------------------------------------------------------------
sub InRangeS {
	my $self = shift;
	my %av = &argv([ -lower => [ 0, 0, 0, 0 ],
					 -upper => [ 0, 0, 0, 0 ],
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $self->new(-depth => &IPL_DEPTH_8U, -channels => 1);
	unless (blessed($av{-src}) &&
			defined($av{-lower}) && defined($av{-upper})) {
		chop(my $usage = <<"----"
usage:	Cv->InRange(
	-src => The first source array. 
	-lower => The inclusive lower boundary. 
	-upper => The exclusive upper boundary. 
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
    cvInRangeS(
		$av{-src},
		pack("d4", cvScalar($av{-lower})),
		pack("d4", cvScalar($av{-upper})),
		$av{-dst},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  Max - Finds per-element maximum of two arrays
# ------------------------------------------------------------
sub Max {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	unless (blessed($av{-src1}) && blessed($av{-src2})) {
		chop(my $usage = <<"----"
usage:	Cv->Max(
	-src1 => The first source array.
	-src2 => The second source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
	cvMax($av{-src1},
		  $av{-src2},
		  $av{-dst},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  MaxS - Finds per-element maximum of array and scalar
# ------------------------------------------------------------
sub MaxS {
	my $self = shift;
	my %av = &argv([ -value => undef,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (blessed($av{-src}) && defined($av{-value})) {
		chop(my $usage = <<"----"
usage:	Cv->MaxS(
	-value => The scalar value
	-src => The first source array
	-dst => The destination array
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
	cvMaxS($av{-src},
		   $av{-value},
		   $av{-dst},
		);
	$av{-dst};
}

# ------------------------------------------------------------
#  Min -  Finds per-element minimum of two arrays
# ------------------------------------------------------------
sub Min {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	unless (blessed($av{-src1}) && blessed($av{-src2})) {
		chop(my $usage = <<"----"
usage:	Cv->Min(
	-src1 => The first source array.
	-src2 => The second source array.
	-dst => The destination array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
	cvMin($av{-src1},
		  $av{-src2},
		  $av{-dst},
		);
	$av{-dst};
}

# ------------------------------------------------------------
#  MinS - Finds per-element minimum of array and scalar
# ------------------------------------------------------------
sub MinS {
	my $self = shift;
	my %av = &argv([ -value => undef,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (blessed($av{-src}) && defined($av{-value})) {
		chop(my $usage = <<"----"
usage:	Cv->MinS(
	-value => The scalar value
	-src => The first source array
	-dst => The destination array
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
	cvMinS($av{-src},
		   $av{-value},
		   $av{-dst},
		);
	$av{-dst};
}

# ------------------------------------------------------------
#  AbsDiff - Calculates absolute difference between two arrays
# ------------------------------------------------------------
sub AbsDiff {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	unless (blessed($av{-src1}) && blessed($av{-src2})) {
		chop(my $usage = <<"----"
usage:	Cv->AbsDiff(
	-src2 => The second source array. 
	-dst => The destination array.
	-src1 => The first source array. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src1}->new; # 29mar10
	cvAbsDiff($av{-src1},
			  $av{-src2},
			  $av{-dst},
		);
	$av{-dst};
}

# ------------------------------------------------------------
#  AbsDiffS - Calculates absolute difference between array and scalar
# ------------------------------------------------------------
sub AbsDiffS {
	my $self = shift;
	my %av = &argv([ -value => undef,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (blessed($av{-src}) && defined($av{-value})) {
		chop(my $usage = <<"----"
usage:	Cv->AbsDiffS(
	-value => The scalar value
	-dst => The destination array
	-src => The first source array
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
	cvAbsDiffS($av{-src},
			   $av{-dst},
			   pack("d4", cvScalar($av{-value})),
		);
	$av{-dst};
}


# ======================================================================
#  2.6. Statistics
# ======================================================================

# ------------------------------------------------------------
#  CountNonZero - Counts non-zero array elements
# ------------------------------------------------------------

# ------------------------------------------------------------
#  Sum - Summarizes array elements
# ------------------------------------------------------------

# ------------------------------------------------------------
#  Avg - Calculates average (mean) of array elements
# ------------------------------------------------------------

# ------------------------------------------------------------
#  AvgSdv - Calculates average (mean) of array elements
# ------------------------------------------------------------

# ------------------------------------------------------------
#  MinMaxLoc - Finds global minimum and maximum in array or subarray
# ------------------------------------------------------------
sub MinMaxLoc {
	my $self = shift;
	my %av = &argv([ -min_val => undef,
					 -max_val => undef,
					 -min_loc => undef,
					 -max_loc => undef,
					 -mask => \0,
					 -arr => $self,
				   ], @_);
	unless (defined($av{-arr})) {
		chop(my $usage = <<"----"
usage:	Cv->MinMaxLoc(
	-arr => The source array, single-channel or multi-channel with COI set. 
	-min_val => Pointer to returned minimum value. 
	-max_val => Pointer to returned maximum value. 
	-min_loc => Pointer to returned minimum location. 
	-max_loc => Pointer to returned maximum location. 
	-mask => The optional mask that is used to select a subarray.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $mm = cvMinMaxLoc(
		$av{-arr},
		my $min_val,
		my $max_val,
		my $min_loc,
		my $max_loc,
		$av{-mask},
		);
	my ($min_x, $min_y) = unpack("i2", $min_loc);
	my ($max_x, $max_y) = unpack("i2", $max_loc);
	if (defined $av{-min_val} && ref $av{-min_val} eq 'SCALAR') {
		${$av{-min_val}} = $min_val;
	}
	if (defined $av{-max_val} && ref $av{-max_val} eq 'SCALAR') {
		${$av{-max_val}} = $max_val;
	}
	if (defined $av{-min_loc}) {
		if (ref $av{-min_loc} eq 'HASH') {
			%{$av{-min_loc}} = ('x' => $min_x, 'y' => $min_y);
		} elsif (ref $av{-min_loc} eq 'ARRAY') {
			@{$av{-min_loc}} = ($min_x, $min_y);
		}
	}
	if (defined $av{-max_loc}) {
		if (ref $av{-max_loc} eq 'HASH') {
			%{$av{-max_loc}} = ('x' => $max_x, 'y' => $max_y);
		} elsif (ref $av{-max_loc} eq 'ARRAY') {
			@{$av{-max_loc}} = ($max_x, $max_y);
		}
	}
	my $minmaxloc = {
		min => {
			val => $min_val,
			loc => {
				'x' => $min_x,
				'y' => $min_y,
			},
		},
		max => {
			val => $max_val,
			loc => {
				'x' => $max_x,
				'y' => $max_y,
			},
		},
	};
}

# ------------------------------------------------------------
#  Norm - Calculates absolute array norm, absolute difference norm or
#  relative difference norm
# ------------------------------------------------------------
sub Norm {
	my $self = shift;
	my %av = &argv([ -arr2 => \0,
					 -norm_type => &CV_L2,
					 -mask => \0,
					 -arr1 => $self,
				   ], @_);
	unless (defined($av{-arr1}) &&
			defined($av{-norm_type})) {
		chop(my $usage = <<"----"
usage:	Cv->Norm(
	-arr1 => The first source image. 
	-arr2 => The second source image. If it is NULL, the absolute norm of
	        arr1 is calculated, otherwise absolute or relative norm of
	        arr1 - arr2 is calculated.
	-normType => Type of norm, see the discussion. 
	-mask => The optional operation mask.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvNorm(
		$av{-arr1},
		$av{-arr2},
		$av{-norm_type},
		$av{-mask},
		);
}


# ------------------------------------------------------------
#  Reduce - Reduces matrix to a vector
# ------------------------------------------------------------
sub Reduce {
	my $self = shift;
	my %av = &argv([ -dst => undef,
					 -dim => -1,
					 -op => &CV_REDUCE_SUM,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new;
	unless (defined($av{-src}) && 
			defined($av{-dst})) {
		chop(my $usage = <<"----"
usage:	Cv->Reduce(
	-src => The input matrix. 
	-dst => The output single-row/single-column vector that accumulates
	        somehow all the matrix rows/columns.
	-dim => The dimension index along which the matrix is reduce. 0 means
	        that the matrix is reduced to a single row, 1 means that the
	        matrix is reduced to a single column. -1 means that the
	        dimension is chosen automatically by analysing the dst size.
	-op => The reduction operation. It can take of the following values:
	        CV_REDUCE_SUM - the output is the sum of all the matrix
	        rows/columns.
	        CV_REDUCE_AVG - the output is the mean vector of all the matrix
	        rows/columns.
	        CV_REDUCE_MAX - the output is the maximum (column/row-wise) of
	        all the matrix rows/columns.
	        CV_REDUCE_MIN - the output is the minimum (column/row-wise) of
	        all the matrix rows/columns.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
    cvReduce(
		$av{-src},
		$av{-dst},
		$av{-dim},
		$av{-op},
		);
	$av{-dst};
}


# ======================================================================
#  2.7. Linear Algebra
# ======================================================================

# ------------------------------------------------------------
#  DotProduct - Calculates dot product of two arrays in Euclidean metrics
# ------------------------------------------------------------

# ------------------------------------------------------------
#  Normalize - Normalizes array to a certain norm or value range
# ------------------------------------------------------------
sub Normalize {
	my $self = shift;
	my %av = &argv([ -dst => undef,
					 -a => 1,
					 -b => 0,
					 -norm_type => &CV_L2,
					 -mask => \0,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new;
	unless (defined($av{-src}) &&
			defined($av{-dst})) {
		chop(my $usage = <<"----"
usage:	Cv->Normalize(
	-src => The input array. 
	-dst => The output array; in-place operation is supported. 
	-a => The minimum/maximum value of the output array or the norm of
	        output array. 
	-b => The maximum/minimum value of the output array. 
	-norm_type => The normalization type. It can take one of the following
	        values:
	        CV_C - the C-norm (maximum of absolute values) of the array is
	                normalized.
	        CV_L1 - the L1-norm (sum of absolute values) of the array is
	                normalized.
	        CV_L2 - the (Euclidean) L2-norm of the array is normalized.
	        CV_MINMAX - the array values are scaled and shifted to the
	                specified range.
	-mask => The operation mask. Makes the function consider and normalize
	        only certain array elements.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvNormalize(
		$av{-src},
		$av{-dst},
		$av{-a}, $av{-b},
		$av{-norm_type},
		$av{-mask},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  CrossProduct - Calculates cross product of two 3D vectors
# ------------------------------------------------------------
sub CrossProduct {
	my $self = shift;
	my %av = &argv([ -src2 => undef,
					 -dst => undef,
					 -src1 => $self,
				   ], @_);
	$av{-src2} ||= $av{-src}; delete $av{-src};
	if (ref $av{-src2} eq 'ARRAY') {
		($av{-src1}, $av{-src2}) = @{$av{-src2}};
	}
	$av{-dst} ||= $av{-src1}->new;
	unless (defined($av{-src1}) &&
			defined($av{-dst})) {
		chop(my $usage = <<"----"
usage:	Cv->CrossProduct(
	-src1 => The first source vector. 
	-src2 => The second source vector. 
	-dst => The destination vector. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCrossProduct(
		$av{-src1},
		$av{-src2},
		$av{-dst},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  ScaleAdd - Calculates sum of scaled array and another array
# ------------------------------------------------------------

sub ScaleAdd {
	my $self = shift;
	my %av = &argv([ -src1 => undef,
					 -scale => undef,
					 -src2 => undef,
					 -dst => undef,
				   ], @_);
	$av{-dst} ||= $av{-src1}->new;
	unless (defined($av{-src1}) &&
			defined($av{-src2}) &&
			defined($av{-dst})) {
		chop(my $usage = <<"----"
usage:	Cv->ScaleAdd(
	-src1 => The first source array. 
	-scale => Scale factor for the first array. 
	-src2 => The second source array. 
	-dst => The destination array 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvScaleAdd(
		$av{-src1},
		$av{-scale},
		$av{-src2},
		$av{-dst},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  GEMM - Performs generalized matrix multiplication
# ------------------------------------------------------------
sub GEMM {
	my $self = shift;
	my %av = &argv([ -src1 => \0,
					 -src2 => \0,
					 -alpha => undef,
					 -src3 => \0,
					 -beta => undef,
					 -dst => undef,
					 -tABC => 0,
				   ], @_);
	$av{-dst} ||= $self->new;
	cvGEMM(
		$av{-src1},
		$av{-src2},
		$av{-alpha},
		$av{-src3},
		$av{-beta},
		$av{-dst},
		$av{-tABC},
		);
	$av{-dst};
}

sub MatMulAdd {
	my $self = shift;
	my %av = &argv([ -src1 => \0,
					 -src2 => \0,
					 -src3 => \0,
					 -dst => undef,
				   ], @_);
	$av{-dst} ||= $self->new;
	$self->GEMM(
		-src1 => $av{-src1},
		-src2 => $av{-src2},
		-alpha => 1,
		-src3 => $av{-src3},
		-beta => 1,
		-dst => $av{-dst},
		);
}

sub MatMul {
	my $self = shift;
	my %av = &argv([ -src2 => \0,
					 -dst  => undef,
					 -src1 => $self,
				   ], @_);
	$av{-dst} ||= $self->new;
	$self->MatMulAdd(
		-src1 => $av{-src1},
		-src2 => $av{-src2},
		-src3 => \0,
		-dst => $av{-dst},
		);
}


# ------------------------------------------------------------
#  Transform - Performs matrix transform of every array element
# ------------------------------------------------------------


# ------------------------------------------------------------
#  PerspectiveTransform - Performs perspective matrix transform of
#  vector array
# ------------------------------------------------------------


# ------------------------------------------------------------
#  MulTransposed - Calculates product of array and transposed array
# ------------------------------------------------------------


# ------------------------------------------------------------
#  Trace - Returns trace of matrix
# ------------------------------------------------------------


# ------------------------------------------------------------
#  Transpose - Transposes matrix
# ------------------------------------------------------------


# ------------------------------------------------------------
#  Det - Returns determinant of matrix
# ------------------------------------------------------------


# ------------------------------------------------------------
#  Invert - Finds inverse or pseudo-inverse of matrix
# ------------------------------------------------------------
sub Invert {
	my $self = shift;
	my %av = &argv([ -method => &CV_LU,
					 -dst => undef,
					 -src => $self,
				   ], @_);

	unless (defined($av{-src}) &&
			defined($av{-method}) 
			) {
		chop(my $usage = <<"----"
usage:	Cv->Invert(
	-src => The source matrix. 
	-dst => The destination matrix. 
	-method => Inversion method:
	      CV_LU - Gaussian elimination with optimal pivot element chose
	      CV_SVD - Singular value decomposition (SVD) method
	      CV_SVD_SYM - SVD method for a symmetric positively-defined matrix
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	$av{-dst} ||= $av{-src}->new;
	cvInvert(
		$av{-src},
		$av{-dst},
		$av{-method},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  Solve - Solves linear system or least-squares problem
# ------------------------------------------------------------


# ------------------------------------------------------------
#  SVD - Performs singular value decomposition of real floating-point
#  matrix
# ------------------------------------------------------------


# ------------------------------------------------------------
#  SVBkSb - Performs singular value back substitution
# ------------------------------------------------------------


# ------------------------------------------------------------
#  EigenVV - Computes eigenvalues and eigenvectors of symmetric matrix
# ------------------------------------------------------------


# ------------------------------------------------------------
#  CalcCovarMatrix - Calculates covariation matrix of the set of vectors
# ------------------------------------------------------------


# ------------------------------------------------------------
#  Mahalonobis - Calculates Mahalonobis distance between two vectors
# ------------------------------------------------------------


# ------------------------------------------------------------
#  CalcPCA - Performs Principal Component Analysis of a vector set
# ------------------------------------------------------------


# ------------------------------------------------------------
#  ProjectPCA - Projects vectors to the specified subspace
# ------------------------------------------------------------


# ------------------------------------------------------------
#  BackProjectPCA - Reconstructs the original vectors from the
#  projection coefficients
# ------------------------------------------------------------


# ======================================================================
#  2.8. Math Functions
# ======================================================================

# ------------------------------------------------------------
#  Round, Floor, Ceil - Converts floating-point number to integer
#  (Cv::CxCore)
# ------------------------------------------------------------
sub Round { my $class = shift; cvRound(@_); }
sub Floor { my $class = shift; cvFloor(@_); }
sub Ceil { my $class = shift; cvCeil(@_); }

# ------------------------------------------------------------
#  Pow - Raises every array element to power
# ------------------------------------------------------------
sub Pow {
	my $self = shift;
	my %av = &argv([ -power => 1,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new; # 29mar10
    cvPow(
		$av{-src},
		$av{-dst},
		$av{-power},
		);
	$av{-dst};
}

# ------------------------------------------------------------
#  Exp - Calculates exponent of every array element
# ------------------------------------------------------------
sub Exp {
	my $self = shift;
	my %av = &argv([ -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new; # 29mar10
    cvExp(
		$av{-src},
		$av{-dst},
		);
	$av{-dst};
}

# ------------------------------------------------------------
#  Log - Calculates natural logarithm of every array element absolute value
# ------------------------------------------------------------
sub Log {
	my $self = shift;
	my %av = &argv([ -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new; # 29mar10
    cvLog(
		$av{-src},
		$av{-dst},
		);
	$av{-dst};
}


# ======================================================================
#  2.9. Random Number Generation
# ======================================================================
# ------------------------------------------------------------
#  RNG - Initializes random number generator state
#  RandArr - Fills array with random numbers and updates the RNG state
#  RandInt - Returns 32-bit unsigned integer and updates RNG
#  RandReal - Returns floating-point random number and updates RNG
#  (see Cv::RNG)
# ------------------------------------------------------------

# ======================================================================
#  2.10. Discrete Transforms
# ======================================================================

# ------------------------------------------------------------
#  Performs forward or inverse Discrete Fourier transform of
#  1D or 2D floating-point array
# ------------------------------------------------------------
sub DFT {
	my $self = shift;
	my %av = &argv([ -flags => undef,
					 -nonzero_rows => undef,
					 -dst => undef,					 
					 -src => $self,
				   ], @_);
	unless (blessed $av{-src} &&
			defined $av{-flags} && defined $av{-nonzero_rows}) {
		chop(my $usage = <<"----"
usage:	Cv->DFT(
	-dst => Destination array of the same size and same type as the source.
	-flags => Transformation flags, a combination of the following values:
            CV_DXT_FORWARD - do forward 1D or 2D transform. The result is
	        not scaled.
	        CV_DXT_INVERSE - do inverse 1D or 2D transform. The result is
	        not scaled. CV_DXT_FORWARD and CV_DXT_INVERSE are mutually
	        exclusive, of course.
	        CV_DXT_SCALE - scale the result: divide it by the number of
	        array elements. Usually, it is combined with CV_DXT_INVERSE, and
	        one may use a shortcut CV_DXT_INV_SCALE.
	        CV_DXT_ROWS - do forward or inverse transform of every
	        individual row of the input matrix. This flag allows user to
	        transform multiple vectors simultaneously and can be used to
	        decrease the overhead (which is sometimes several times larger
	        than the processing itself), to do 3D and higher-dimensional
	        transforms etc. 
	-nonzero_rows => Number of nonzero rows to in the source array (in case
	        of forward 2d transform), or a number of rows of interest in the
	        destination array (in case of inverse 2d transform). If the
	        value is negative, zero, or greater than the total number of
	        rows, it is ignored. The parameter can be used to speed up 2d
	        convolution/correlation when computing them via DFT. See the
	        sample below. 
	-src => Source array, real or complex.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new; # 29mar10
	cvDFT($av{-src}, $av{-dst}, $av{-flags}, $av{-nonzero_rows});
	$av{-dst};
}

# ------------------------------------------------------------
#  Returns optimal DFT size for given vector size
# ------------------------------------------------------------
sub GetOptimalDFTSize {
	my $self = shift;
	my %av = &argv([ -size0 => undef ], @_);
	unless (defined $av{-size0}) {
		chop(my $usage = <<"----"
usage:	Cv->GetOptimalDFTSize(
	-size0 => Vector size.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetOptimalDFTSize($av{-size0});
}


# ######################################################################
#  3. Dynamic Structures
# ######################################################################

# ======================================================================
#  3.1. Memory Storages
# ======================================================================

# ======================================================================
#  3.2. Sequences
# ======================================================================
# ------------------------------------------------------------
#  GetSeqElem - Returns pointer to sequence element by its index
#  SeqElemIdx - Returns index of concrete sequence element
#  CvtSeqToArray - Copies sequence to one continuous block of memory
#  MakeSeqHeaderForArray - Constructs sequence from array
#  SeqSlice - Makes separate header for the sequence slice
#  CloneSeq - Creates a copy of sequence
#  SeqRemoveSlice - Removes sequence slice
#  SeqInsertSlice - Inserts array in the middle of sequence
#  SeqInvert - Reverses the order of sequence elements
#  SeqSort - Sorts sequence element using the specified comparison function
#  SeqSearch - Searches element in sequence
#  StartAppendToSeq - Initializes process of writing data to sequence
#  StartWriteSeq - Creates new sequence and initializes writer for it
#  EndWriteSeq - Finishes process of writing sequence
#  FlushSeqWriter - Updates sequence headers from the writer state
#  StartReadSeq - Initializes process of sequential reading from sequence
#  GetSeqReaderPos - Returns the current reader position
#  SetSeqReaderPos - Moves the reader to specified position
#  (see Cv::Seq)
# ------------------------------------------------------------

# ======================================================================
#  3.3. Sets
# ======================================================================

# ======================================================================
#  3.4. Graphs
# ======================================================================

# ======================================================================
#  3.5. Trees
# ======================================================================

# ######################################################################
#  4. Drawing Functions
# ######################################################################

# ======================================================================
#  4.1. Curves and Shapes
# ======================================================================

# ------------------------------------------------------------
#  Line - Draws a line segment connecting two points
# ------------------------------------------------------------
sub Line {
	my $self = shift;
	my %av = &argv([ -pt1 => undef,
					 -pt2 => undef,
					 -color => [ 255, 255, 255 ],
					 -thickness => 1,
					 -line_type => 8,
					 -shift => 0,
					 -img => $self,
				   ], @_);
	unless (defined $av{-pt1} && defined $av{-pt2} &&
			blessed($av{-img})) {
		chop(my $usage = <<"----"
usage:	Cv->Line(
	-pt1 => First point of the line segment.
	-pt2 => Second point of the line segment.
	-color => Line color.
	-thickness => Line thickness.
	-line_type => Type of the line:
            8 (or 0) - 8-connected line.
	        4 - 4-connected line.
	        CV_AA - antialiased line.
	-shift => Number of fractional bits in the point coordinates.
	-img => The image.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvLine(
		$av{-img},
		pack("i2", cvPoint($av{-pt1})),
		pack("i2", cvPoint($av{-pt2})),
		pack("d4", cvScalar($av{-color})),
		$av{-thickness},
		$av{-line_type},
		$av{-shift});
	$av{-img};
}


# ------------------------------------------------------------
#  Rectangle - Draws simple, thick or filled rectangle
# ------------------------------------------------------------
sub Rectangle {
    my $self = shift;
	my %av = &argv([ -pt1 => undef,
					 -pt2 => undef,
					 -color => [ 255, 255, 255 ],
					 -thickness => 1,
					 -line_type => 8,
					 -shift => 0,
					 -img => $self,
				   ], @_);
	if (ref $av{-rect}) {
		if (ref $av{-rect} eq 'HASH') {
			$av{-pt1} = { 'x' => $av{-rect}->{x},
						  'y' => $av{-rect}->{y},
			};
			$av{-pt2} = { 'x' => $av{-rect}->{x} + $av{-rect}->{width}  - 1,
						  'y' => $av{-rect}->{y} + $av{-rect}->{height} - 1,
			};
			delete $av{-rect};
		} elsif (ref $av{-rect} eq 'ARRAY') {
			$av{-pt1} = { 'x' => $av{-rect}->[0],
						  'y' => $av{-rect}->[1],
			};
			$av{-pt2} = { 'x' => $av{-rect}->[0] + $av{-rect}->[2] - 1,
						  'y' => $av{-rect}->[1] + $av{-rect}->[3] - 1,
			};
			delete $av{-rect};
		}
	}
	cvRectangle(
		$av{-img},
		pack("i2", cvPoint($av{-pt1})),
		pack("i2", cvPoint($av{-pt2})),
		pack("d4", cvScalar($av{-color})),
		$av{-thickness},
		$av{-line_type},
		$av{-shift},
		);
	$av{-img};
}


# ------------------------------------------------------------
#  Circle - Draws a circle
# ------------------------------------------------------------
sub Circle {
	my $self = shift;
	my %av = &argv([ -center => undef,
					 -radius => undef,
					 -color => [ 255, 255, 255 ],
					 -thickness => 1,
					 -line_type => 8,
					 -shift => 0,
					 -circle => undef,
					 -img => $self,
				   ], @_);

	if (defined $av{-circle} &&
		!(defined $av{-center} && defined $av{-radius})) {
		$av{-center} = $av{-circle}->{center};
		$av{-radius} = $av{-circle}->{radius};
		delete $av{-circle};
	}
	unless (blessed($av{-img}) &&
			defined $av{-center} &&
			defined $av{-radius} &&
			defined $av{-color} &&
			defined $av{-thickness} &&
			defined $av{-line_type} &&
			defined $av{-shift}) {
		chop(my $usage = <<"----"
usage:	Cv->Circle(
	-center => Center of the circle.
	-radius => Radius of the circle.
	-color => Circle color.
	-thickness => Thickness of the circle outline if positive,
				 \t otherwise indicates that a filled circle
				 \t has to be drawn.
	-line_type => Type of the circle boundary, see cvLine description. 
	-shift => Number of fractional bits in the center coordinates
				 \t and radius value.
	-img => Image where the circle is drawn.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCircle(
		$av{-img},
		pack("i2", cvPoint($av{-center})),
		$av{-radius},
		pack("d4", cvScalar($av{-color})),
		$av{-thickness},
		$av{-line_type},
		$av{-shift},
		);

	$av{-img};
}


# ------------------------------------------------------------
#  Ellipse - Draws simple or thick elliptic arc or fills ellipse sector
# ------------------------------------------------------------
sub Ellipse {
    my $self = shift;
	my %av = &argv([ -center => undef,
					 -axes => undef,
					 -angle => 0,
					 -start_angle => undef,
					 -end_angle => undef,
					 -color => [ 255, 255, 255 ],
					 -thickness => 1,
					 -line_type => 8,
					 -shift => 0,
					 -img => $self,
				   ], @_);
	unless ($av{-start_angle} && $av{-end_angle}) {
		$av{-start_angle} = 0;
		$av{-end_angle} = 360;
	}
	unless (blessed($av{-img}) &&
			defined($av{-axes}) &&
			defined($av{-angle}) &&
			defined($av{-start_angle}) &&
			defined($av{-end_angle}) &&
			defined($av{-color}) &&
			defined($av{-thickness}) &&
			defined($av{-line_type}) &&
			defined($av{-shift})) {
		chop(my $usage = <<"----"
usage:	Cv->Ellipse(
	-img => Image. 
	-center => Center of the ellipse. 
	-axes => Length of the ellipse axes. 
	-angle => Rotation angle. 
	-start_angle => Starting angle of the elliptic arc. 
	-end_angle => Ending angle of the elliptic arc. 
	-color => Ellipse color. 
	-thickness => Thickness of the ellipse arc. 
	-line_type => Type of the ellipse boundary, see cvLine description. 
	-shift => Number of fractional bits in the center coordinates and axes\'
	        values. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvEllipse(
		$av{-img},
		pack("i2", cvPoint($av{-center})),
		pack("i2", cvSize($av{-axes})),
		$av{-angle},
		$av{-start_angle},
		$av{-end_angle},
		pack("d4", cvScalar($av{-color})),
		$av{-thickness},
		$av{-line_type},
		$av{-shift},
		);
	$av{-img};
}

# ------------------------------------------------------------
#  EllipseBox - Draws simple or thick elliptic arc or fills ellipse sector
# ------------------------------------------------------------

sub EllipseBox {
    my $self = shift;
	my %av = &argv([ -box => undef,
					 -color => [ 255, 255, 255 ],
					 -thickness => 1,
					 -line_type => 8,
					 -shift => 0,
					 -img => $self,
				   ], @_);
	unless (blessed($av{-img}) &&
		defined($av{-box}) &&
		defined($av{-color}) &&
		defined($av{-thickness}) &&
		defined($av{-line_type}) &&
		defined($av{-shift})) {
		chop(my $usage = <<"----"
usage:	Cv->EllipseBox(
	-img => Image. 
	-box => The enclosing box of the ellipse drawn.
	-color => Ellipse color. 
	-thickness => Thickness of the ellipse boundary.
	-line_type => Type of the ellipse boundary, see cvLine description. 
	-shift => Number of fractional bits in the center coordinates.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $box = $av{-box};
	if ($av{-fitellipse}) {
        $box = {
			angle => -$box->{angle} + 90,
			center => { 'x' => $box->{center}{x},
						'y' => $box->{center}{y}, },
			size => { width => $box->{size}{width},
					  height => $box->{size}{height}, },
		};
	}
	cvEllipseBox(
		$av{-img},
		pack("f5",
			 cvPoint($box->{center}),
			 cvSize($box->{size}),
			 $box->{angle}),
		pack("d4", cvScalar($av{-color})),
		$av{-thickness},
		$av{-line_type},
		$av{-shift},
		);
	$av{-img};
}

# ------------------------------------------------------------
#  FillPoly - Fills polygons interior
# ------------------------------------------------------------
sub FillPoly {
	my $self = shift;
	my %av = &argv([ -pts => undef,
					 -npts => undef,
					 -contours => undef,
					 -color => [ 255, 255, 255 ],
					 -line_type => 8,
					 -shift => 0,
					 -img => $self,
				   ], @_);

	unless (blessed $av{-img} &&
			defined $av{-pts} &&
#			defined $av{-npts} &&
#			defined $av{-contours} &&
			defined $av{-color}) {
		chop(my $usage = <<"----"
usage:	Cv->FillPoly(
	-pts => Array of pointers to polygons.
	-npts => Array of polygon vertex counters.
	-contours => Number of contours that bind the filled region.
	-color => Polygon color.
	-line_type => Type of the line segments, see cvLine description. 
	-shift => Number of fractional bits in the vertex coordinates.
	-img => Image.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	$av{-contours} = @{$av{-pts}};
	$av{-npts} = ();
	foreach my $p (@{$av{-pts}}) {
		push(@{$av{-npts}}, scalar @{$p});
	}

	cvFillPoly(
		$av{-img},
		$av{-pts},
		$av{-npts},
		$av{-contours},
		pack("d4", cvScalar($av{-color})),
		$av{-line_type},
		$av{-shift},
		);
	$av{-img};
}

# ------------------------------------------------------------
#  FillConvexPoly - Fills convex polygon
# ------------------------------------------------------------
sub FillConvexPoly {
    my $self = shift;
	my %av = &argv([ -pts => undef,
					 #-npts => undef,
					 -color => [ 255, 255, 255 ],
					 -line_type => 8,
					 -shift => 0,
					 -img => $self,
				   ], @_);
	unless (blessed $av{-img} &&
			defined $av{-pts} &&
#			defined $av{-npts} &&
			defined $av{-color}) {
		chop(my $usage = <<"----"
usage:	Cv->FillConvexPoly(
	-img => Image. 
	-pts => Array of pointers to a single polygon. 
	-npts => Polygon vertex counter. 
	-color => Polygon color. 
	-line_type => Type of the polygon boundaries, see cvLine description. 
	-shift => Number of fractional bits in the vertex coordinates.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvFillConvexPoly(
		$av{-img},
		$av{-pts},
		#$av{-npts},
		pack("d4", cvScalar($av{-color})),
		$av{-line_type},
		$av{-shift},
		);
	$av{-img};
}

# ------------------------------------------------------------
#  PolyLine - Draws simple or thick polygons
# ------------------------------------------------------------
sub PolyLine {
	my $self = shift;
	my %av = &argv([ -pts => undef,
					 -npts => undef,
					 -contours => undef,
					 -is_closed => undef,
					 -color => [ 255, 255, 255 ],
					 -thickness => 1,
					 -line_type => 8,
					 -shift => 0,
					 -img => $self,
				   ], @_);

	unless (blessed $av{-img} &&
			defined $av{-pts} &&
#			defined $av{-npts} &&
#			defined $av{-contours} &&
			defined $av{-is_closed} &&
			defined $av{-color}) {
		chop(my $usage = <<"----"
usage:	Cv->PolyLine(
	-pts => Array of pointers to polylines.
	-npts => Array of polyline vertex counters.
	-contours => Number of polyline contours. 
	-is_closed => Indicates whether the polylines must be drawn closed.
    If closed, the function draws the line from the last vertex of every
	contour to the first vertex.
	-color => Polyline color.
	-thickness => Thickness of the polyline edges.
	-line_type => Type of the line segments, see cvLine description. 
	-shift => Number of fractional bits in the vertex coordinates.
	-img => Image.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	$av{-contours} = @{$av{-pts}};
	$av{-npts} = ();
	foreach my $p (@{$av{-pts}}) {
		push(@{$av{-npts}}, scalar @$p);
	}

	cvPolyLine(
		$av{-img},
		$av{-pts},
		$av{-npts},
		$av{-contours},
		$av{-is_closed},
		pack("d4", cvScalar($av{-color})),
		$av{-thickness},
		$av{-line_type},
		$av{-shift},
		);
	$av{-img};
}

# ======================================================================
#  4.2. Text
# ======================================================================
# ------------------------------------------------------------
#  InitFont - Initializes font structure
#  PutText - Draws text string
#  GetTextSize - Retrieves width and height of text string
#  (see Cv::Text)
# ------------------------------------------------------------
sub PutText {
	my $self = shift;
	my %av = &argv([ -font => undef,
				   ], @_);
	if (blessed $av{-font}) {
		my $font = $av{-font};
		delete $av{-font};
		$font->PutText(-img => $self, %av);
		$self;
	} else {
		carp "can\'t PutText";
	}
}
	

# ======================================================================
#  4.3. Point Sets and Contours
# ======================================================================

# ------------------------------------------------------------
#  DrawContours - Draws contour outlines or interiors in the image
# ------------------------------------------------------------


# ######################################################################
#  5. Data Persistence and RTTI
# ######################################################################
=xxx

# ======================================================================
#  5.1. File Storage
# ======================================================================

# ======================================================================
#  5.2. Writing Data
# ======================================================================

# ======================================================================
#  5.3. Reading Data
# ======================================================================

# ======================================================================
#  5.4. RTTI and Generic Functions 
# ======================================================================

# ------------------------------------------------------------
#  Load - Loads object from file
# ------------------------------------------------------------

sub Load {
	my $self = shift;
	my %av = &argv([ -filename => undef,
					 -memstorage => \0,
					 -name => \0,
					 -real_name => \0,
				   ], @_);

	unless ( defined $av{-filename} &&
			defined $av{-memstorage} &&
			defined $av{-name} &&
			defined $av{-real_name}) {
		chop(my $usage = <<"----"
usage:	Cv->Load(
	-filename => File name.
	-memstorage => Memory storage for dynamic structures, such as
	CvSeq  or CvGraph. It is not used for matrices or images. 
	-name => Optional object name. If it is NULL, the first top-level
	object in the storage will be loaded. 
	-real_name => Optional output parameter that will contain name of
	the loaded object (useful if name=NULL).
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvLoad($av{-filename}, $av{-memstorage}, $av{-name}, $av{-real_name});
}

sub LoadCascade {
	my $self = shift;
	my %av = &argv([ -filename => undef ], @_);
	cvLoadCascade($av{-filename});
}

=cut

# ######################################################################
#  6. Miscellaneous Functions
# ######################################################################

# ------------------------------------------------------------
#  CheckArr - Checks every element of input array for invalid values
# ------------------------------------------------------------

# ------------------------------------------------------------
#  KMeans2 - Splits set of vectors by given number of clusters
# ------------------------------------------------------------
sub KMeans2 {
	my $self = shift;
	my %av = &argv([ -cluster_count => undef,
					 -labels => undef,
					 -termcrit => undef,
					 -samples => $self,
				   ], @_);
	if (!defined $av{-termcrit} && defined $av{-criteria}) {
		$av{-termcrit} = $av{-criteria};
		delete $av{-criteria};
	}
	unless (blessed $av{-samples} &&
			defined $av{-cluster_count} &&
			blessed $av{-labels} &&
			defined $av{-termcrit}) {
		chop(my $usage = <<"----"
usage:	Cv->KMeans2(
	-samples => Floating-point matrix of input samples, one row per sample. 
	-cluster_count => Number of clusters to split the set by. 
	-labels => Output integer vector storing cluster indices for every
	        sample. 
	-criteria => Specifies maximum number of iterations and/or accuracy
	       (distance the centers move by between the subsequent iterations). 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvKMeans2(
		$av{-samples},
		$av{-cluster_count},
		$av{-labels},
		pack("i2d", cvTermCriteria($av{-termcrit})),
		);
	$av{-labels};
}


# ######################################################################
#  7. Error Handling and System Functions
# ######################################################################

# ======================================================================
#  7.1. Error Handling
# ======================================================================

# ------------------------------------------------------------
#  Raises an error
# ------------------------------------------------------------
sub Error {
	my $self = shift;
	my %av = &argv([ -status => undef,
					 -func_name => undef,
					 -err_msg => undef,
					 -file_name => undef,
					 -line => undef,
				   ], @_);
	unless (defined $av{-status} &&
			defined $av{-func_name} &&
			defined $av{-err_msg} &&
			defined $av{-file_name} &&
			defined $av{-line}
			) {
		chop(my $usage = <<"----"
usage:	Cv->Error(
	-status => The error status.
	-func_name => Name of the function where the error occurred.
	-err_msg => Additional information/diagnostics about the error.
	-file_name => Name of the file where the error occurred.
	-line => Line number, where the error occurred.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvError($av{-status}, $av{-func_name},
			$av{-err_msg}, $av{-file_name}, $av{-line});
}


# ======================================================================
#  7.2. System Functions
# ======================================================================



# ######################################################################
# ### HighGUI ##########################################################
# ######################################################################

# ======================================================================
#  Simple GUI
# ======================================================================
# ------------------------------------------------------------
#  cvShowImage - Shows the image in the specified window
# ------------------------------------------------------------
sub ShowImage {
	my $self = shift;
	my %av = &argv([ -name => undef,
					 -image => $self,
				   ], @_);
	if (blessed($av{-name} ||= $av{-window_name})) {
		$av{-name} = $av{-name}->name;
	}
	unless (eval { $av{-image}->isa('Cv::Arr') }) {
		chop(my $usage = <<"----"
usage:	Cv::Arr->ShowImage(
	-name => Name of the window. 
	-image => Image to be shown.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-name} ||= $IMAGES{$av{-image}}{window};
	if (eval { $av{-name}->isa('Cv::Window') }) {
		$av{-name}->ShowImage(-image => $av{-image});
	} else {
		use Cv::Window;
		if (my $window = Cv::Window->new(-name => $av{-name})) {
			($IMAGES{$av{-image}}{window} = $window)
				->ShowImage(-image => $av{-image});
		} else {
			carp "can\'t ShowImage";
		}
	}
	$av{-image};
}

sub show {
	my $self = shift;
	$self->ShowImage(@_);
}


# ######################################################################
# ### CV ###############################################################
# ######################################################################

# ######################################################################
#  1. Image Processing
# ######################################################################

# ======================================================================
#  1.1. Gradients, Edges, Corners and Features
# ======================================================================

# ------------------------------------------------------------
# Sobel - Calculates first, second, third or mixed image derivatives
# using extended Sobel operator
# ------------------------------------------------------------
sub Sobel {
	my $self = shift;
	my %av = &argv([ -xorder => 1,
					 -yorder => 0,
					 -aperture_size => 3,
					 -dst => undef,
					 -src => $self,
				   ], @_);

	unless (defined $av{-xorder} &&
			defined $av{-yorder} &&
			defined $av{-aperture_size} &&
			blessed($av{-src}) &&
			$av{-src}->channels == 1) {
		chop(my $usage = <<"----"
usage:	Cv->Sobel(
	-src => Source image
	-dst => Destination image
	-xorder => Order of the derivative X
	-yorder => Order of the derivative Y
	-aperture_size => Size of the extended Sobel kernel
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	unless (blessed($av{-dst})) {
		my $depth = $av{-src}->depth;
		if ($av{-src}->depth == IPL_DEPTH_8U ||
			$av{-src}->depth == IPL_DEPTH_8S) {
			$depth = IPL_DEPTH_16S;
		} elsif ($av{-src}->depth == IPL_DEPTH_16U ||
				 $av{-src}->depth == IPL_DEPTH_16S) {
			$depth = IPL_DEPTH_32S;
		} elsif ($av{-src}->depth == IPL_DEPTH_32S) {
			$depth = IPL_DEPTH_32F;
		}
		$av{-dst} = $av{-src}->new(-depth => $depth, -channels => 1);
	}
	cvSobel($av{-src}, $av{-dst},
			$av{-xorder}, $av{-yorder},
			$av{-aperture_size});
	$av{-dst};
}

# ------------------------------------------------------------
#  Laplace - Calculates Laplacian of the image
# ------------------------------------------------------------
sub Laplace {
	my $self = shift;
	my %av = &argv([ -aperture_size => 3,
					 -dst => undef,
					 -src => $self,
				   ], @_);

	$av{-src} ||= $av{-image};
	unless (blessed($av{-src}) && defined($av{-aperture_size})) {
		chop(my $usage = <<"----"
usage:	Cv::Laplace(
	-aperture_size => Aperture size (it has the same meaning as in cvSobel).
	-dst => Destination image.
	-src => Source image.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	# $av{-dst} ||= $av{-edges};
	unless (blessed($av{-dst})) {
		my $depth = $av{-src}->depth == &IPL_DEPTH_8U ?
			&IPL_DEPTH_16S : &IPL_DEPTH_32S;
		$av{-dst} = $av{-src}->new(-depth => $depth);
	}
	cvLaplace($av{-src}, $av{-dst}, $av{-aperture_size});
	$av{-dst};
}

# ------------------------------------------------------------
# Canny - Implements Canny algorithm for edge detection
# ------------------------------------------------------------
sub Canny {
	my $self = shift;
	my %av = &argv([ -threshold1 => 50,  # or -threshold[0]
					 -threshold2 => 100, # or -threshold[1]
					 -aperture_size => 3,
					 -dst => undef, # or -edges
					 -src => $self, # or -image
				   ], @_);

	$av{-src} ||= $av{-image};
	$av{-dst} ||= $av{-edges};
	if (!defined $av{-threshold1} && !defined $av{-threshold2} &&
		defined $av{-threshold} && ref $av{-threshold} eq 'ARRAY') {
		($av{-threshold1}, $av{-threshold2}) = @{$av{-threshold}};
	}
	unless (defined $av{-threshold1} &&
			defined $av{-threshold2} &&
			defined $av{-aperture_size} &&
			defined($av{-src}) &&
			$av{-src}->GetChannels == 1) {
		chop(my $usage = <<"----"
usage:	Cv->Canny(
	-src (-image) => Input image. 
	-dst (-edges) => Image to store the edges found by the function. 
	-threshold1 => The first threshold. 
	-threshold2 => The second threshold. 
	-aperture_size => Aperture parameter for Sobel operator (see cvSobel).
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	$av{-dst} ||= $av{-src}->new;
	cvCanny($av{-src}, $av{-dst},
			$av{-threshold1}, $av{-threshold2},
			$av{-aperture_size});
	$av{-dst};
}

# ------------------------------------------------------------
#  PreCornerDetect - Calculates feature map for corner detection
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CornerEigenValsAndVecs - Calculates eigenvalues and eigenvectors of
#  image blocks for corner detection
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CornerMinEigenVal - Calculates minimal eigenvalue of gradient
#  matrices for corner detection
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CornerHarris - Harris edge detector
# ------------------------------------------------------------

# ------------------------------------------------------------
#  FindCornerSubPix - Refines corner locations
# ------------------------------------------------------------
sub FindCornerSubPix {
    my $self = shift;
	my %av = &argv([ -corners => undef,
					 -win => undef,
					 -zero_zone => [ -1, -1 ],
					 -criteria => undef,
					 -image => $self,
				   ], @_);

	unless (ref $av{-corners} eq 'ARRAY' &&
			defined $av{-win} &&
			defined $av{-zero_zone} &&
			ref $av{-criteria} eq 'ARRAY' &&
			blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->FindCornerSubPix(
	-image => Input image. 
	-corners => Initial coordinates of the input corners and refined
	        coordinates on output.
	-count => Number of corners. 
	-win => Half sizes of the search window. For example,
	        if win=(5,5) then 5*2+1 × 5*2+1 = 11 × 11 search window is used.
	-zero_zone => Half size of the dead region in the middle of the
	        search zone over which the summation in formulae below is not
	        done. It is used sometimes to avoid possible singularities of
	        the autocorrelation matrix. The value of (-1,-1) indicates that
	        there is no such size.
	-criteria => Criteria for termination of the iterative process of
	        corner refinement. That is, the process of corner position
	        refinement stops either after certain number of iteration or
	        when a required accuracy is achieved. The criteria may specify
	        either of or both the maximum number of iteration and the
	        required accuracy.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	cvFindCornerSubPix(
		$av{-image},
		$av{-corners},
		pack("i2", cvSize($av{-win})),
		#$av{-win},
		pack("i2", cvSize($av{-zero_zone})),
		#$av{-zero_zone},
		pack("i2d", cvTermCriteria($av{-criteria})),
		#$av{-criteria},
		);
}


# ------------------------------------------------------------
#  GoodFeaturesToTrack - Determines strong corners on image
# ------------------------------------------------------------
sub GoodFeaturesToTrack {
    my $self = shift;
	my %av = &argv([ -corners => undef,
					 -corner_count => undef,
					 -quality_level => undef,
					 -min_distance => undef,
					 -mask => \0,
					 -block_size => 3,
					 -use_harris => 0,
					 -k => 0.04,
					 -image => $self,
				   ], @_);
	unless (ref $av{-corners} eq 'ARRAY' &&
			defined $av{-corner_count} &&
			defined $av{-quality_level} &&
			defined $av{-min_distance} &&
			defined $av{-block_size} &&
			defined $av{-use_harris} &&
			defined $av{-k} &&
			blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->GoodFeaturesToTrack(
	-image => The source 8-bit or floating-point 32-bit, single-channel
	        image.
	-eig_image => (auto) Temporary floating-point 32-bit image of the same
	        size as image.
	-temp_image => (auto) Another temporary image of the same size and
	        same format as eig_image.
	-corners => Output parameter. Detected corners. 
	-corner_count => Output parameter. Number of detected corners. 
	-quality_level => Multiplier for the maxmin eigenvalue; specifies
	        minimal accepted quality of image corners.
	-min_distance => Limit, specifying minimum possible distance
	        between returned corners; Euclidean distance is used.
	-mask => Region of interest. The function selects points either in the
	        specified region or in the whole image if the mask is NULL.
	-block_size => Size of the averaging block, passed to underlying
	        cvCornerMinEigenVal or cvCornerHarris used by the function.
	-use_harris => If nonzero, Harris operator (cvCornerHarris) is used
	        instead of default cvCornerMinEigenVal.
	-k => Free parameter of Harris detector; used only if use_harris != 0 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	my $eig_image = $av{-image}->new(-depth => 32);
	my $temp_image = $av{-image}->new(-depth => 32);
	cvGoodFeaturesToTrack(
		$av{-image},
		$eig_image,
		$temp_image,
		$av{-corners},
		$av{-corner_count},
		$av{-quality_level},
		$av{-min_distance},
		$av{-mask},
		$av{-block_size},
		$av{-use_harris},
		$av{-k},
		);
}


# ------------------------------------------------------------
#  ExtractSURF - Extracts Speeded Up Robust Features from image
# ------------------------------------------------------------

# ======================================================================
#  1.2. Sampling, Interpolation and Geometrical Transforms
# ======================================================================

# ------------------------------------------------------------
#  SampleLine - Reads raster line to buffer
# ------------------------------------------------------------

# ------------------------------------------------------------
#  GetRectSubPix - Retrieves pixel rectangle from image with sub-pixel accuracy
# ------------------------------------------------------------
sub GetRectSubPix {
	my $self = shift;
	my %av = &argv([ -center => undef,
					 -dst => undef,
					 -src => $self,
				   ], @_);
 	$av{-dst} ||= $av{-src}->new;
	cvGetRectSubPix(
		$av{-src},
		$av{-dst},
		pack("d2", cvPoint($av{-center})),
		);
	$av{-dst};
}

# ------------------------------------------------------------
#  GetQuadrangleSubPix - Retrieves pixel quadrangle from image with
#  sub-pixel accuracy
# ------------------------------------------------------------
sub Affine {
	my $self = shift;
	my %av = &argv([ -mat => undef,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new;
	my ($rows, $cols, @m) = &matrix($av{-mat});
	use Cv::Mat;
	my $mat = Cv::Mat->new(
		-rows => $rows,
		-cols => $cols,
		-type => &CV_32FC1,
		);
	foreach my $r (0 .. $rows - 1) {
		foreach my $c (0 .. $cols - 1) {
			$mat->SetD(-idx => [$r, $c], -value => [ shift(@m) ]);
		}
	}
	cvGetQuadrangleSubPix(
		$av{-src},
		$av{-dst},
		$mat,
		);
	$av{-dst};
}


# ------------------------------------------------------------
#   Resize - Resizes image
# ------------------------------------------------------------
sub Resize {
	my $self = shift;
	my %av = &argv([ -dst => undef,
					 -interpolation => &CV_INTER_LINEAR,
					 -src => $self,
				   ], @_);

	unless (defined $av{-interpolation} &&
			blessed($av{-src})) {
		chop(my $usage = <<"----"
usage:	Cv->Resize(
	-interpolation => Interpolation method
	-dst => Destination image. 
	-src => Source image. 
	)
----
		);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new;
	cvResize($av{-src}, $av{-dst}, $av{-interpolation});
	$av{-dst};
}


# ------------------------------------------------------------
#  WarpAffine - Applies affine transformation to the image
# ------------------------------------------------------------


# ------------------------------------------------------------
#  GetAffineTransform - Calculates affine transform from 3
#  corresponding points
# ------------------------------------------------------------


# ------------------------------------------------------------
#  2DRotationMatrix - Calculates affine matrix of 2d rotation
# ------------------------------------------------------------


# ------------------------------------------------------------
#  WarpPerspective - Applies perspective transformation to the image
# ------------------------------------------------------------


# ------------------------------------------------------------
#  GetPerspectiveTransform - Calculates perspective transform from 4
#  corresponding points
# ------------------------------------------------------------


# ------------------------------------------------------------
#   Remap - Applies generic geometrical transformation to the image
# ------------------------------------------------------------
sub Remap {
	my $self = shift;
	my %av = &argv([ -mapx => undef,
					 -mapy => undef,
					 -flags => &CV_INTER_LINEAR + &CV_WARP_FILL_OUTLIERS,
					 -fillval => [ 0, 0, 0, 0 ],
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new;
	unless (defined $av{-mapx} &&
			defined $av{-mapy} &&
			defined $av{-flags} &&
			defined $av{-fillval} &&
			blessed($av{-src})) {
		chop(my $usage = <<"----"
usage:	Cv->Remap(
	-mapx => The map of X-coordinates (32FC1 image). 
	-mapy => The map of Y-coordinates (32FC1 image). 
	-flags => A combination of interpolation method and the optional flag(s).
	-fillval => A value used to fill outliers.
	-dst => Destination image. 
	-src => Source image. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvRemap(
		$av{-src},
		$av{-dst},
		$av{-mapx},
		$av{-mapy},
		$av{-flags},
		pack("d4", cvScalar($av{-fillval})),
		);
	$av{-dst};
}

# ------------------------------------------------------------
#  LogPolar - Remaps image to log-polar space
# ------------------------------------------------------------
sub LogPolar {
	my $self = shift;
	my %av = &argv([ -center => undef,
					 -M => undef,
					 -flags => &CV_INTER_LINEAR + &CV_WARP_FILL_OUTLIERS,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new;
	unless (blessed $av{-src} &&
			blessed $av{-dst} &&
			defined $av{-center} &&
			defined $av{-M} &&
			defined $av{-flags}) {
		chop(my $usage = <<"----"
usage:	Cv->LogPolar(
	-src => Source image. 
	-dst => Destination image. 
	-center => The transformation center, where the output precision is
	        maximal. 
	-M => Magnitude scale parameter. See below. 
	-flags => A combination of interpolation method and the following
	        optional flags:
	    * CV_WARP_FILL_OUTLIERS - fill all the destination image pixels. If
	      some of them correspond to outliers in the source image, they are
	      set to zeros.
        * CV_WARP_INVERSE_MAP - indicates that matrix is inverse transform
	      from destination image to source and, thus, can be used directly
	      for pixel interpolation. Otherwise, the function finds the inverse
	      transform from map_matrix. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvLogPolar(
		$av{-src},
		$av{-dst},
		pack("f2", cvPoint($av{-center})),
		$av{-M},
		$av{-flags},
		);
	$av{-dst};
}


# ======================================================================
#  1.3. Morphological Operations
# ======================================================================

# ------------------------------------------------------------
#   Erode - Erodes image by using arbitrary structuring element
# ------------------------------------------------------------
sub Erode {
	my $self = shift;
	my %av = &argv([ -element => \0,
					 -iterations => 1,
					 -dst => undef,
					 -src => $self,
				   ], @_);

	unless (blessed($av{-src}) && defined($av{-iterations})) {
		chop(my $usage = <<"----"
usage:	Cv->Erode(
	-element => Structuring element used for erosion.
	-iterations => Number of times erosion is applied.
	-src => Source image. 
	-dst => Destination image. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new;
	cvErode($av{-src}, $av{-dst}, $av{-element}, $av{-iterations});
	$av{-dst};
}

# ------------------------------------------------------------
#  Dilate - Dilates image by using arbitrary structuring element
# ------------------------------------------------------------
sub Dilate {
	my $self = shift;
	my %av = &argv([ -element => \0,
					 -iterations => 1,
					 -dst => undef,
					 -src => $self,
				   ], @_);

	unless (blessed($av{-src}) && defined($av{-iterations})) {
		chop(my $usage = <<"----"
usage:	Cv->Dilate(
	-element => Structuring element used for erosion.
	-iterations => Number of times erosion is applied.
	-src => Source image. 
	-dst => Destination image. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new;
	cvDilate($av{-src}, $av{-dst}, $av{-element}, $av{-iterations});
	$av{-dst};
}

# ------------------------------------------------------------
#  MorphologyEx - Performs advanced morphological transformations
# ------------------------------------------------------------
sub MorphologyEx {
	my $self = shift;
	my %av = &argv([ -operation => undef,
					 -iterations => 1,
					 -element => \0,
					 -dst => undef,
					 -src => $self,
				   ], @_);

	unless (blessed($av{-src}) && defined($av{-iterations}) &&
			defined $av{-operation}) {
		chop(my $usage = <<"----"
usage:	Cv->MorphologyEx(
	-element => Structuring element. 
	-operation => Type of morphological operation, one of:
	\t CV_MOP_OPEN - opening
	\t CV_MOP_CLOSE - closing
	\t CV_MOP_GRADIENT - morphological gradient
	\t CV_MOP_TOPHAT - "top hat"
	\t CV_MOP_BLACKHAT - "black hat"
	-iterations => Number of times erosion and dilation are applied.
	-src => Source image. 
	-dst => Destination image. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $temp = undef;
	if ($av{-operation} == &CV_MOP_GRADIENT ||
		$av{-operation} == &CV_MOP_TOPHAT ||
		$av{-operation} == &CV_MOP_BLACKHAT) {
		$temp = $av{-src}->new;
	}
	$av{-dst} ||= $av{-src}->new;
	cvMorphologyEx($av{-src}, $av{-dst}, $temp || \0,
		$av{-element}, $av{-operation}, $av{-iterations});
	$av{-dst};
}

# ======================================================================
#  1.4. Filters and Color Conversion
# ======================================================================

# ------------------------------------------------------------
#  Smooth - Smoothes the image in one of several ways
# ------------------------------------------------------------
sub Smooth {
	my $self = shift;
	my %av = &argv([ -smoothtype => &CV_GAUSSIAN,
					 -size1 => 3,
					 -size2 => 0,
					 -sigma1 => 0,
					 -sigma2 => 0,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new;
	unless (defined $av{-smoothtype} &&
			defined $av{-size1} && defined $av{-size2} &&
			defined $av{-sigma1} && defined $av{-sigma2} &&
			blessed($av{-src})) {
		chop(my $usage = <<"----"
usage:	Cv->Smooth(
	-smoothtype => Type of the smoothing operation,
	-size1 => The first parameter of smoothing operation. It should be
	        odd (1, 3, 5, ...), so that a pixel neighborhood used for
	        smoothing operation is symmetrical relative to the pixel.
	-size2 => The second parameter of smoothing operation. In case of
	        simple scaled/non-scaled and Gaussian blur if size2 is zero,
	        it is set to size1. When not 0, it should be odd too.
	-sigma1 => In case of Gaussian kernel this parameter may specify
	        Gaussian sigma (standard deviation).
	-sigma2 => In case of non-square Gaussian kernel the parameter may
	        be used to specify a different (from param3) sigma in the
	        vertical direction.
	-dst => The destination image,
	-src => The source image,
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSmooth($av{-src}, $av{-dst},
			 $av{-smoothtype},
			 $av{-size1}, $av{-size2},
			 $av{-sigma1}, $av{-sigma2});
	$av{-dst};
}


# ------------------------------------------------------------
#  Filter2D - Applies linear filter to image
# ------------------------------------------------------------
sub Filter2D {
	my $self = shift;
	my %av = &argv([ -kernel => undef,
					 -anchor => [ -1, -1 ],
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new;
	if (defined $av{-kernel} && ref $av{-kernel} eq 'ARRAY') {
		my ($rows, $cols, @m) = &matrix($av{-kernel});
		use Cv::Mat;
		my $kernel = Cv::Mat->new(
			-rows => $rows,
			-cols => $cols,
			-type => &CV_32FC1,
			);
		foreach my $r (0 .. $rows - 1) {
			foreach my $c (0 .. $cols - 1) {
				$kernel->SetD([ $r, $c ], [ shift(@m) ]);
			}
		}
		cvNormalize($kernel, $kernel, 1, 0, &CV_L1, \0);
		$av{-kernel} = $kernel;
	}
	cvFilter2D(
		$av{-src},
		$av{-dst},
		$av{-kernel},
		pack("i2", cvPoint($av{-anchor})),
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  CopyMakeBorder - Copies image and makes border around it
# ------------------------------------------------------------
sub CopyMakeBorder { croak "### TBD ###"; }


# ------------------------------------------------------------
#  Integral - Calculates integral images
# ------------------------------------------------------------
sub Integral { croak "### TBD ###"; }

# ------------------------------------------------------------
#  CvtColor - Converts image from one color space to another
# ------------------------------------------------------------
sub CvtColor {
	my $self = shift;
	my %av = &argv([ -code => undef,
					 -dst => undef,
					 -src => $self,
				   ], @_);

	unless (defined $av{-code} &&
			defined($av{-src})) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv->CvtColor(
	-src => The source 8-bit (8u), 16-bit (16u) or single-precision
	        floating-point (32f) image.
	-dst => The destination image of the same data type as the source one.
	        The number of channels may be different.
	-code => Color conversion operation that can be specified using
	        CV_<src_color_space>2<dst_color_space> constants
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	unless (defined $av{-dst}) {

		if ($av{-code} == &CV_BGR2GRAY ||
			$av{-code} == &CV_RGB2GRAY) {

			$av{-dst} = $av{-src}->new(-channels => 1);

		} elsif ($av{-code} == &CV_GRAY2BGR ||
				 $av{-code} == &CV_GRAY2RGB ||
				 $av{-code} == &CV_BGR2HSV ||
				 $av{-code} == &CV_RGB2HSV ||
				 $av{-code} == &CV_BGR2YCrCb ||
				 $av{-code} == &CV_RGB2YCrCb ||
				 $av{-code} == &CV_YCrCb2BGR ||
				 $av{-code} == &CV_YCrCb2RGB) {

			$av{-dst} = $av{-src}->new(-channels => 3);
		}
	}
=xxx
	print STDERR "code = ", $av{-code}, ", ";
	print STDERR "src.channels = ", $av{-src}->GetChannels, ", ";
	print STDERR "src.depth = ", $av{-src}->GetDepth, "\n";
	print STDERR "code = ", $av{-code}, ", ";
	print STDERR "dst.channels = ", $av{-dst}->GetChannels, ", ";
	print STDERR "dst.depth = ", $av{-dst}->GetDepth, "\n";
=cut
	unless (defined($av{-dst})) {
		goto usage;
	}
	cvCvtColor(
		$av{-src},
		$av{-dst},
		$av{-code},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  Threshold - Applies fixed-level threshold to array elements
# ------------------------------------------------------------
sub Threshold {
	my $self = shift;
	my %av = &argv([ -threshold => 70,
					 -max_value => 255,
					 -threshold_type => &CV_THRESH_BINARY,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new;
	unless (defined $av{-threshold} &&
			defined $av{-max_value} &&
			defined $av{-threshold_type} &&
			defined($av{-src}) &&
			$av{-src}->GetChannels == 1) {
		chop(my $usage = <<"----"
usage:	Cv->Threshold(
	-threshold => Threshold value.
	-max_value => Maximum value to use with CV_THRESH_BINARY and
	        CV_THRESH_BINARY_INV thresholding types.
	-threshold_type => Thresholding type
	-src => Source array (single-channel, 8-bit of 32-bit floating point).
	-dst => Destination array; must be either the same type as src or 8-bit.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvThreshold(
		$av{-src},
		$av{-dst},
		$av{-threshold},
		$av{-max_value},
		$av{-threshold_type},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  AdaptiveThreshold -  Applies adaptive threshold to array
# ------------------------------------------------------------
sub AdaptiveThreshold {
	my $self = shift;
	my %av = &argv([ -max_value => 255,
					 -adaptive_method => &CV_ADAPTIVE_THRESH_MEAN_C,
					 -threshold_type => &CV_THRESH_BINARY,
					 -block_size => 3,
					 -param1 => 5,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new;
	unless (defined $av{-max_value} &&
			defined $av{-adaptive_method} &&
			defined $av{-threshold_type} &&
			defined $av{-block_size} &&
			defined $av{-param1} &&
			defined($av{-src}) &&
			$av{-src}->GetChannels == 1) {
		chop(my $usage = <<"----"
usage:	Cv->AdaptiveThreshold(
	-max_value => Maximum value that is used with CV_THRESH_BINARY and
	        CV_THRESH_BINARY_INV. 
	-adaptive_method => Adaptive thresholding algorithm to use:
	        CV_ADAPTIVE_THRESH_MEAN_C or CV_ADAPTIVE_THRESH_GAUSSIAN_C.
	-threshold_type => Thresholding type; must be one of
            * CV_THRESH_BINARY,
            * CV_THRESH_BINARY_INV 
	-block_size => The size of a pixel neighborhood that is used to
	        calculate a threshold value for the pixel: 3, 5, 7, ...
	-param1 => The method-dependent parameter. For the methods
	        CV_ADAPTIVE_THRESH_MEAN_C and CV_ADAPTIVE_THRESH_GAUSSIAN_C
	        it is a constant subtracted from mean or weighted mean,
	        though it may be negative.
	-src => Source image.
	-dst => Destination image.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvAdaptiveThreshold(
		$av{-src},
		$av{-dst},
		$av{-max_value},
		$av{-adaptive_method},
		$av{-threshold_type},
		$av{-block_size},
		$av{-param1},
		);
	$av{-dst};
}


# ======================================================================
#  1.5. Pyramids and the Applications
# ======================================================================

# ------------------------------------------------------------
#  PyrDown - Downsamples image
# ------------------------------------------------------------
sub PyrDown {
	my $self = shift;
	my %av = &argv([ -filter => &CV_GAUSSIAN_5x5,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new(
		-size => [ map { int($_ / 2) } $av{-src}->GetSize ],
		);
	unless (defined $av{-filter} &&
			defined($av{-src})) {
		chop(my $usage = <<"----"
usage:	Cv->PyrDown(
	-src => The source image. 
	-dst => The destination image, should have 2x smaller width and
	        height than the source.
	-filter => Type of the filter used for convolution; only
            CV_GAUSSIAN_5x5 is currently supported.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvPyrDown($av{-src}, $av{-dst},
			  $av{-filter});
	$av{-dst};
}


# ------------------------------------------------------------
#  PyrUp - Upsamples image
# ------------------------------------------------------------
sub PyrUp {
	my $self = shift;
	my %av = &argv([ -filter => &CV_GAUSSIAN_5x5,
					 -dst => undef,
					 -src => $self,
				   ], @_);
	$av{-dst} ||= $av{-src}->new(
		-size => [ map { int($_ * 2) } $self->GetSize ],
		);
	unless (defined $av{-filter} &&
			defined($av{-src})) {
		chop(my $usage = <<"----"
usage:	Cv->PyrUp(
	-src => The source image. 
	-dst => The destination image, should have 2x smaller width and
	        height than the source.
	-filter => Type of the filter used for convolution; only
            CV_GAUSSIAN_5x5 is currently supported.
	)
----
		 );
		croak $usage, " = ", &Dumper(\%av);
	}
	cvPyrUp($av{-src}, $av{-dst},
			$av{-filter});
	$av{-dst};
}


# ======================================================================
#  1.6. Image Segmentation, Connected Components and Contour Retrieval
# ======================================================================

# ------------------------------------------------------------
#  CvConnectedComp - Connected component
# ------------------------------------------------------------
sub CvConnectedComp { croak "### TBD ###"; }


# ------------------------------------------------------------
#  FloodFill - Fills a connected component with given color
# ------------------------------------------------------------
sub FloodFill {
	my $self = shift;
	my %av = &argv([ -seed_point => undef,
					 -new_val => undef,
					 -lo_diff => scalar cvScalarAll(0),
					 -up_diff => scalar cvScalarAll(0),
					 -cmp => \0,
					 -flags => 4,
					 -mask => \0,
					 -image => $self,
				   ], @_);

	unless (blessed $av{-image} &&
			defined $av{-seed_point} &&
			defined $av{-new_val}) {
		chop(my $usage = <<"----"
usage:	Cv->FloodFill(
	-image => Input 1- or 3-channel, 8-bit or floating-point image.	It is
	        modified by the function unless CV_FLOODFILL_MASK_ONLY flag is
	        set (see below).
	-seed_point => The starting point.
	-new_val => New value of repainted domain pixels.
	-lo_diff => Maximal lower brightness/color difference between the
	        currently observed pixel and one of its neighbor belong to the
	        component or seed pixel to add the pixel to component. In case
	        of 8-bit color images it is packed value.
	-up_diff => Maximal upper brightness/color difference between the
	        currently observed pixel and one of its neighbor belong to the
	        component or seed pixel to add the pixel to component. In case
	        of 8-bit color images it is packed value. 
	-cmp => Pointer to structure the function fills with the information
	        about the repainted domain. 
	-flags => The operation flags.  Lower bits contain connectivity value,
	        4 (by default) or 8, used within the function. Connectivity
	        determines which neighbors of a pixel are considered. Upper bits
	        can be 0 or combination of the following flags:
	        * CV_FLOODFILL_FIXED_RANGE - if set the difference between the
	        current pixel and seed pixel is considered, otherwise difference
	        between neighbor pixels is considered (the range is floating).
			* CV_FLOODFILL_MASK_ONLY - if set, the function does not fill
	        the image (new_val is ignored), but the fills mask (that must be
	        non-NULL in this case). 
	-mask => Operation mask, should be singe-channel 8-bit image, 2 pixels
	        wider and 2 pixels taller than image. If not NULL, the function
	        uses and updates the mask, so user takes responsibility of
	        initializing mask content. Floodfilling can\'t go across non-zero
	        pixels in the mask, for example, an edge detector output can be
	        used as a mask to stop filling at edges. Or it is possible to
	        use the same mask in multiple calls to the function to make sure
	        the filled area do not overlap.
	        Note: because mask is larger than the filled image, pixel in
	        mask that corresponds to (x, Y) pixel in image will have
	        coordinates (x+1, Y+1).
	)
----
		 );
		croak $usage, " = ", &Dumper(\%av);
	}

	cvFloodFill(
		$av{-image},
		pack("i2", cvPoint($av{-seed_point})),
		pack("d4", cvScalar($av{-new_val})),
		pack("d4", cvScalar($av{-lo_diff})),
		pack("d4", cvScalar($av{-up_diff})),
		$av{-cmp},
		$av{-flags},
		$av{-mask},
		);
	$av{-image};
}


# ------------------------------------------------------------
#  FindContours - Finds contours in binary image
# ------------------------------------------------------------
sub FindContours {
	my $self = shift;
	use Cv::Contour;
	Cv::Contour->Find(-image => $self, @_);
}

# ------------------------------------------------------------
#  StartFindContours - Initializes contour scanning process
# ------------------------------------------------------------
sub StartFindContours { croak "### TBD ###"; }


# ------------------------------------------------------------
#  FindNextContour - Finds next contour in the image
# ------------------------------------------------------------
sub FindNextContour { croak "### TBD ###"; }


# ------------------------------------------------------------
#  SubstituteContour - Replaces retrieved contour
# ------------------------------------------------------------
sub SubstituteContour { croak "### TBD ###"; }


# ------------------------------------------------------------
#  EndFindContours - Finishes scanning process
# ------------------------------------------------------------
sub EndFindContours { croak "### TBD ###"; }


# ------------------------------------------------------------
#  PyrSegmentation - Does image segmentation by pyramids
#  (Cv::Image)
# ------------------------------------------------------------


# ------------------------------------------------------------
#  PyrMeanShiftFiltering - Does MeanShift image segmentation
# ------------------------------------------------------------
sub PyrMeanShiftFiltering { croak "### TBD ###"; }

# ------------------------------------------------------------
#  Watershed - Does watershed segmentation
# ------------------------------------------------------------
sub Watershed {
	my $self = shift;
	my %av = argv([ -markers => undef,
					-image => $self,
				  ], @_);

	unless (blessed $av{-markers} &&
			blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv::Image->Watershed(
	-image => The input 8-bit 3-channel image. 
	-markers => The input/output 32-bit single-channel image (map) of
	        markers. 
	)
----
		 );
		croak $usage, " = ", &Dumper(\%av);
	}
    cvWatershed($av{-image}, $av{-markers});
	$av{-markers};
}


# ======================================================================
#  1.7. Image and Contour moments
# ======================================================================

# ------------------------------------------------------------
#  Moments - Calculates all moments up to third order of a polygon or
#          rasterized shape
#  GetSpatialMoment - Retrieves spatial moment from moment state structure
#  GetCentralMoment - Retrieves central moment from moment state structure
#  GetNormalizedCentralMoment - Retrieves normalized central moment
#          from moment state structure
#  GetHuMoments - Calculates seven Hu invariants
#  (Cv::Moments)
# ------------------------------------------------------------
sub Moments {
	my $self = shift;
	use Cv::Moments;
	Cv::Moments->new(-arr => $self, @_);
}

# ======================================================================
#  1.8. Special Image Transforms
# ======================================================================

# ------------------------------------------------------------
#  HoughLines2 - Finds lines in binary image using Hough transform
#  (Cv::HoughLines2)
# ------------------------------------------------------------
sub HoughLines2 {
	my $self = shift;
	my %av = &argv([ -image => $self,
				   ], @_);
	use Cv::HoughLines2;
	Cv::HoughLines2->new(%av);
}


# ------------------------------------------------------------
#  HoughCircles - Finds circles in grayscale image using Hough transform
#  (Cv::HoughCircles)
# ------------------------------------------------------------
sub HoughCircles {
	my $self = shift;
	my %av = &argv([ -image => $self,
				   ], @_);
	use Cv::HoughCircles;
	Cv::HoughCircles->new(%av);
}


# ------------------------------------------------------------
#  DistTransform - Calculates distance to closest zero pixel for all
#  non-zero pixels of source image
# ------------------------------------------------------------
sub DistTransform {
	my $self = shift;
	my %av = &argv([ -distance_type => &CV_DIST_L2,
					 -mask_size => 3,
					 -mask => \0,
					 -labels => \0,
					 -src => $self,
					 -dst => undef,
				   ], @_);
	$av{-dst} ||= $av{-src}->new;
	unless (defined($av{-src}) &&
			$av{-src}->GetDepth == &IPL_DEPTH_8U &&
			$av{-src}->GetChannels == 1) {
		chop(my $usage = <<"----"
usage:	Cv->DistTransform(
	-distance_type => Type of distance; can be CV_DIST_L1, CV_DIST_L2,
	        CV_DIST_C or CV_DIST_USER.
	-mask_size => Size of distance transform mask; can be 3, 5 or 0. In case
	        of CV_DIST_L1 or CV_DIST_C the parameter is forced to 3, because
	        3×3 mask gives the same result as 5×5 yet it is faster. When
	        mask_size==0, a different non-approximate algorithm is used to
	        calculate distances.
	-mask => User-defined mask in case of user-defined distance, it consists
	        of 2 numbers (horizontal/vertical shift cost, diagonal shift
	        cost) in case of 3×3 mask and 3 numbers (horizontal/vertical
	        shift cost, diagonal shift cost, knight’s move cost) in case of
	        5×5 mask.
	-labels => The optional output 2d array of labels of integer type and
	        the same size as src and dst, can now be used only with
	        mask_size==3 or 5.
	-src => Source 8-bit single-channel (binary) image.
	-dst => Output image with calculated distances.
	        In most cases it should be 32-bit floating-point, single-channel
	        array of the same size as the input image. When distance_type ==
	        CV_DIST_L1, 8-bit, single-channel destination array may be also
	        used (in-place operation is also supported in this case). 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvDistTransform(
		$av{-src},
		$av{-dst},
		$av{-distance_type},
		$av{-mask_size},
		$av{-mask},
		$av{-labels},
		);
	$av{-dst};
}


# ------------------------------------------------------------
#  Inpaint - Inpaints the selected region in the image
# ------------------------------------------------------------

sub Inpaint {
    my $self = shift;
	my %av = argv([ -mask => \0,
					-dst => undef,
					-flags => undef,
					-inpaintRadius => undef,
					-src => $self,
				  ], @_);
	$av{-dst} ||= $av{-src}->new;
	unless (blessed($av{-src}) &&
			blessed($av{-dst})) {
		chop(my $usage = <<"----"
usage:	Cv->Inpaint(
	-src => The input 8-bit 1-channel or 3-channel image. 
	-mask => The inpainting mask, 8-bit 1-channel image. Non-zero pixels
	        indicate the area that needs to be inpainted. 
	-dst => The output image of the same format and the same size as input.
	-flags => The inpainting method, one of the following:
            CV_INPAINT_NS - Navier-Stokes based method.
            CV_INPAINT_TELEA - The method by Alexandru Telea [Telea04] 
	-inpaintRadius => The radius of circular neighborhood of each point
	        inpainted that is considered by the algorithm. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvInpaint(
		$av{-src},
		$av{-mask},
		$av{-dst},
		$av{-inpaintRadius},
		$av{-flags},
		);
	$av{-dst};
}

# ======================================================================
#  1.9. Histograms
# ======================================================================
# ------------------------------------------------------------
#  CvHistogram - Multi-dimensional histogram
#  CreateHist - Creates histogram
#  SetHistBinRanges - Sets bounds of histogram bins
#  ReleaseHist - Releases histogram
#  ClearHist - Clears histogram
#  MakeHistHeaderForArray - Makes a histogram out of array
#  QueryHistValue_*D - Queries value of histogram bin
#  GetHistValue_*D - Returns pointer to histogram bin
#  GetMinMaxHistValue - Finds minimum and maximum histogram bins
#  NormalizeHist - Normalizes histogram
#  ThreshHist - Thresholds histogram
#  CompareHist - Compares two dense histograms
#  CopyHist - Copies histogram
#  CalcHist - Calculates histogram of image(s)
#  CalcBackProject - Calculates back projection
#  CalcBackProjectPatch - Locates a template within image by histogram
#          comparison
#  CalcProbDensity - Divides one histogram by another
#  (Cv::Histogram)
# ------------------------------------------------------------
# ------------------------------------------------------------
#  EqualizeHist - Equalizes histogram of grayscale image
# ------------------------------------------------------------
sub EqualizeHist {
	my $self = shift;
	my %av = argv([ -dst => undef,
					-src => $self,
				  ], @_);

	unless (defined($av{-src})) {
		chop(my $usage = <<"----"
usage:	Cv->EqualizeHist(
    -dst => Pointer to destination histogram.
    -src => Source histogram.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new;
	cvEqualizeHist( $av{-src}, $av{-dst});
	$av{-dst};
}


# ======================================================================
#  1.10. Matching
# ======================================================================

# ------------------------------------------------------------
#  MatchTemplate - Compares template against overlapped image regions
# ------------------------------------------------------------
sub MatchTemplate {
	my $self = shift;
	my %av = argv([ -templ => undef,
					-result => undef,
					-method => &CV_TM_CCOEFF_NORMED,
					-image => $self,
				  ], @_);
	unless (blessed($av{-image}) &&
			blessed($av{-templ}) &&
			blessed($av{-result}) &&
			defined($av{-method})) {
		chop(my $usage = <<"----"
usage:	Cv->MatchTemplate(
	-image => Image where the search is running. It should be 8-bit or
	        32-bit floating-point. 
	-templ => Searched template; must be not greater than the source image
	        and the same data type as the image. 
	-result => A map of comparison results; single-channel 32-bit floating-
	        point. If image is W×H and templ is w×h then result must be
	        W-w+1×H-h+1. 
	-method => Specifies the way the template must be compared with image
	        regions (see below).
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $SZ = $av{-image}->GetSize;
	my $sz = $av{-templ}->GetSize;
	$av{-result} ||= $av{-image}->new(
		-size => [ $SZ->[0] - $sz->[0] + 1, $SZ->[1] - $sz->[1] + 1 ],
		-depth => &IPL_DEPTH_32F,
		);
	cvMatchTemplate(
		$av{-image},
		$av{-templ},
		$av{-result},
		$av{-method},
		);
	$av{-result};
}


# ------------------------------------------------------------
#  MatchShapes - Compares two shapes
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CalcEMD2 - Computes "minimal work" distance between two weighted
#          point configurations
# ------------------------------------------------------------


# ######################################################################
#  2. Structural Analysis
# ######################################################################

# ======================================================================
#  2.1. Contour Processing Functions
# ======================================================================

# ------------------------------------------------------------
#  ApproxChains - Approximates Freeman chain(s) with polygonal curve
#  StartReadChainPoints - Initializes chain reader
#  ReadChainPoint - Gets next chain point
#  ApproxPoly - Approximates polygonal curve(s) with desired precision
#  BoundingRect - Calculates up-right bounding rectangle of point set
#  ContourArea - Calculates area of the whole contour or contour section
#  ArcLength - Calculates contour perimeter or curve length
#  CreateContourTree - Creates hierarchical representation of contour
#  ContourFromContourTree - Restores contour from tree
#  MatchContourTrees - Compares two contours using their tree representations
#  (see Cv::Seq)
# ------------------------------------------------------------

# ======================================================================
#  2.2. Computational Geometry
# ======================================================================

# ------------------------------------------------------------
#  MaxRect - Finds bounding rectangle for two given rectangles
#  CvBox2D - Rotated 2D box
#  BoxPoints - Finds box vertices
#  (see Cv::CxCore)
# ------------------------------------------------------------
sub MaxRect { my $class = shift; cvMaxRect(@_); }
sub BoxPoints { my $class = shift; cvBoxPoints(@_); }

# ------------------------------------------------------------
#  PointSeqFromMat - Initializes point sequence header from a point
#          vector.
#  FitEllipse - Fits ellipse to set of 2D points
#  FitLine - Fits line to 2D or 3D point set
#  ConvexHull2 - Finds convex hull of point set
#  CheckContourConvexity - Tests contour convex
#  ConvexityDefects - Finds convexity defects of contour
#  PointPolygonTest - Point in contour test
#  MinAreaRect2 - Finds circumscribed rectangle of minimal area for
#          given 2D point set
#  MinEnclosingCircle - Finds circumscribed circle of minimal area for
#          given 2D point set
#  CalcPGH - Calculates pair-wise geometrical histogram for contour
#  (see Cv::Mat)
# ------------------------------------------------------------

sub FitEllipse {
	my $self = shift;
	my %av = &argv([ -points => $self,
					 -type => &CV_32FC2, # or CV_64FC2, ...
				   ], @_);
	unless (defined($av{-points}) &&
			ref $av{-points} eq 'ARRAY') {
		chop(my $usage = <<"----"
usage:	Cv->FitEllipse(
	-points => Sequence or array of points.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	return undef unless (scalar @{$av{-points}} >= 6);
	my $mat = Cv->CreateMat(
		-rows => 1,
		-cols => scalar @{$av{-points}},
		-type => $av{-type},
		);
	foreach my $i (0 .. $#{$av{-points}}) {
		$mat->SetD(-idx => [ $i ], -value => ${av{-points}}[$i]);
	}
	$mat->FitEllipse;
}

sub FitLine {
	my $self = shift;
	my %av = &argv([ -dist_type => &CV_DIST_L2,
					 -param => 0,
					 -reps => 0.01,
					 -aeps => 0.01,
					 -line => undef,
					 -points => $self,
					 -type => &CV_32FC2, # or CV_32FC3, ...
				   ], @_);
	$av{-line} ||= { };
	my $mat = Cv->CreateMat(
		-rows => 1,
		-cols => scalar @{$av{-points}},
		-type => $av{-type},
		);
	foreach my $i (0 .. $#{$av{-points}}) {
		$mat->SetD(-idx => [ $i ], -value => ${av{-points}}[$i]);
	}
	$mat->FitLine(
		-dist_type => $av{-dist_type},
		-param => $av{-dist_type},
		-reps => $av{-reps},
		-aeps => $av{-aeps},
		);
}

sub MinAreaRect2 {
	my $self = shift;
	my %av = &argv([ -points => $self,
					 -type => &CV_32FC2, # or CV_64FC2, ...
				   ], @_);
	$av{-line} ||= { };
	my $mat = Cv->CreateMat(
		-rows => 1,
		-cols => scalar @{$av{-points}},
		-type => $av{-type},
		);
	foreach my $i (0 .. $#{$av{-points}}) {
		$mat->SetD(-idx => [ $i ], -value => ${av{-points}}[$i]);
	}
	$mat->MinAreaRect2;
}

# ======================================================================
#  2.3. Planar Subdivisions
# ======================================================================

# ######################################################################
#  3. Motion Analysis and Object Tracking Reference
# ######################################################################

# ======================================================================
#  3.1. Accumulation of Background Statistics
# ======================================================================

# ------------------------------------------------------------
#  Acc - Adds frame to accumulator
# ------------------------------------------------------------
sub Acc {
	my $self = shift;
	my %av = &argv([ -image => undef,
					 -sum => $self,	# ACC
					 -mask => undef,
				   ], @_);
	unless (blessed $av{-image} &&
			blessed $av{-sum}) {
		chop(my $usage = <<"----"
usage:	Cv->Acc(
	-image => Input image, 1- or 3-channel, 8-bit or 32-bit floating point.
	        (each channel of multi-channel image is processed independently). 
	-sum => Accumulator of the same number of channels as input image, 32-bit
	        floating-point. 
	-mask => Optional operation mask.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvAcc(
		$av{-image},
		$av{-sum},
		$av{-mask} || \0,
		);
	$av{-sum};
}


# ------------------------------------------------------------
#  SquareAcc - Adds the square of source image to accumulator
# ------------------------------------------------------------

# ------------------------------------------------------------
#  MultiplyAcc - Adds product of two input images to accumulator
# ------------------------------------------------------------

# ------------------------------------------------------------
#  RunningAvg - Updates running average
# ------------------------------------------------------------
sub RunningAvg {
	my $self = shift;
	my %av = &argv([ -image => undef,
					 -alpha => undef,
					 -mask => \0,
					 -acc => $self,
				   ], @_);
	unless (blessed $av{-image} &&
			blessed $av{-acc}) {
		chop(my $usage = <<"----"
usage:	Cv->RunningAvg(
	-image => Input image, 1- or 3-channel, 8-bit or 32-bit floating point
	       (each channel of multi-channel image is processed independently). 
	-acc => Accumulator of the same number of channels as input image,
	        32-bit or 64-bit floating-point. 
	-alpha => Weight of input image. 
	-mask => Optional operation mask.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
    cvRunningAvg(
		$av{-image},
		$av{-acc},
		$av{-alpha},
		$av{-mask},
		);
	$av{-acc};
}


# ======================================================================
#  3.2. Motion Templates
# ======================================================================

# ------------------------------------------------------------
#  UpdateMotionHistory - Updates motion history image by moving silhouette
# ------------------------------------------------------------
sub UpdateMotionHistory {
	my $self = shift;
	my %av = &argv([ -mhi => undef,
					 -timestamp => undef,
					 -duration => undef,
					 -silhouette => $self,
				   ], @_);
	unless (defined($av{-silhouette}) &&
			defined($av{-mhi}) &&
			defined $av{-timestamp} &&
			defined $av{-duration}) {
		chop(my $usage = <<"----"
usage:	Cv->UpdateMotionHistory(
	-silhouette => Silhouette mask that has non-zero pixels where the
	        motion occurs.
	-mhi => Motion history image, that is updated by the function
	        (single-channel, 32-bit floating-point)
	-timestamp => Current time in milliseconds or other units. 
	-duration => Maximal duration of motion track in the same units as
            timestamp.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvUpdateMotionHistory(
		$av{-silhouette},
		$av{-mhi},
		$av{-timestamp},
		$av{-duration},
		);
	$av{-silhouette};
}

# ------------------------------------------------------------
#  CalcMotionGradient - Calculates gradient orientation of motion
#  history image
# ------------------------------------------------------------
sub CalcMotionGradient {
	my $self = shift;
	my %av = &argv([ -orientation => undef,
					 -delta1 => undef,
					 -delta2 => undef,
					 -aperture_size => 3,
					 -mask => \0,
					 -mhi => $self,
				   ], @_);
	unless (defined($av{-mhi}) && 
			defined($av{-mask}) &&
			defined($av{-orientation}) &&
			defined $av{-delta1} &&
			defined $av{-delta2} &&
			defined $av{-aperture_size}) {
		chop(my $usage = <<"----"
usage:	Cv->CalcMotionGradient(
	-mhi => Motion history image. 
	-mask => Mask image; marks pixels where motion gradient data is correct.
	        Output parameter.
	-orientation => Motion gradient orientation image; contains angles from
	        0 to ~360°.
	-delta1, -delta2 => The function finds minimum (m(x, y)) and maximum
	        (M(x, y)) mhi values over each pixel (x, y) neighborhood and
	        assumes the gradient is valid only if
	        min(delta1, delta2) <= M(x, y) - m(x, y) <= max(delta1, delta2).
	-aperture_size => Aperture size of derivative operators used by the
	        function: CV_SCHARR, 1, 3, 5 or 7 (see cvSobel).
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCalcMotionGradient(
		$av{-mhi},
		$av{-mask},
		$av{-orientation},
		$av{-delta1},
		$av{-delta2},
		$av{-aperture_size},
		);
	$av{-mhi};
}

# ------------------------------------------------------------
#  CalcGlobalOrientation - Calculates global motion orientation of
#  some selected region
# ------------------------------------------------------------
sub CalcGlobalOrientation {
	my $self = shift;
	my %av = &argv([ -orientation => undef,
					 -timestamp => undef,
					 -duration => undef,
					 -mask => \0,
					 -mhi => $self,
				   ], @_);
	unless (defined($av{-orientation}) &&
			#defined($av{-mask}) &&
			defined($av{-mhi}) &&
			defined $av{-timestamp} &&
			defined $av{-duration}) {
		chop(my $usage = <<"----"
usage:	Cv->CalcGlobalOrientation(
	-orientation => Motion gradient orientation image; calculated by the
	        function cvCalcMotionGradient.
	-mask => Mask image. It may be a conjunction of valid gradient mask,
	        obtained with cvCalcMotionGradient and mask of the region,
	        whose direction needs to be calculated.
	-mhi => Motion history image. 
	-timestamp => Current time in milliseconds or other units, it is better
	        to store time passed to cvUpdateMotionHistory before and reuse
	        it here, because running cvUpdateMotionHistory and
	        cvCalcMotionGradient on large images may take some time.
	-duration => Maximal duration of motion track in milliseconds, the same
	        as in cvUpdateMotionHistory.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCalcGlobalOrientation(
		$av{-orientation},
		$av{-mask},
		$av{-mhi},
		$av{-timestamp},
		$av{-duration},
		);
	$av{-mhi};
}


# ------------------------------------------------------------
#  SegmentMotion - Segments whole motion into separate moving parts
#  (Cv)
# ------------------------------------------------------------


# ======================================================================
#  3.3. Object Tracking
# ======================================================================

# ------------------------------------------------------------
#  MeanShift - Finds object center on back projection
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CamShift - Finds object center, size, and orientation
# ------------------------------------------------------------
sub CamShift {
	my $self = shift if blessed $_[0];
	my %av = &argv([ -window => undef,
				   ], @_);
	cvCamShift($self, pack("i4", cvRect($av{-window})));
}

# ------------------------------------------------------------
#  SnakeImage - Changes contour position to minimize its energy
# ------------------------------------------------------------



# ======================================================================
#  3.4. Optical Flow
# ======================================================================

# ------------------------------------------------------------
#  CalcOpticalFlowHS - Calculates optical flow for two images
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CalcOpticalFlowLK - Calculates optical flow for two images
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CalcOpticalFlowBM - Calculates optical flow for two images by block
#  matching method
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CalcOpticalFlowPyrLK - Calculates optical flow for a sparse feature
#          set using iterative Lucas-Kanade method in pyramids
# ------------------------------------------------------------
sub CalcOpticalFlowPyrLK {
	my $self = shift;
	my %av = &argv([ -prev => \0,
					 -curr => $self,
					 -prev_pyr => \0,
					 -curr_pyr => \0,
					 -prev_features => undef,
					 -curr_features => undef,
					 -win_size => undef,
					 -level => undef,
					 -status => undef,
					 -track_error => undef,
					 -criteria => undef,
					 -flags => undef,
				   ], @_);
	unless (blessed($av{-prev}) &&
			blessed($av{-curr}) &&
			blessed($av{-prev_pyr}) &&
			blessed($av{-curr_pyr}) &&
			ref $av{-prev_features} eq 'ARRAY' &&
			ref $av{-curr_features} eq 'ARRAY' &&
			defined($av{-win_size}) &&
			defined($av{-level}) &&
			ref $av{-criteria} eq 'ARRAY' &&
			defined($av{-flags})) {
		chop(my $usage = <<"----"
usage:	Cv->CalcOpticalFlowPyrLK(
	-prev => First frame, at time t. 
	-curr => Second frame, at time t + dt. 
	-prev_pyr => Buffer for the pyramid for the first frame. If the
	        pointer is not NULL , the buffer must have a sufficient
	        size to store the pyramid from level 1 to level \#level;
	        the total size of (image_width+8)*image_height/3 bytes is
	        sufficient.
	-curr_pyr => Similar to prev_pyr, used for the second frame. 
	-prev_features => Array of points for which the flow needs to be
	        found.
	-curr_features => Array of 2D points containing calculated new
	        positions of input features in the second image.
	-count => (auto) Number of feature points. 
	-win_size => Size of the search window of each pyramid level. 
	-level => Maximal pyramid level number. If 0 , pyramids are not
	        used (single level), if 1 , two levels are used, etc.
	-status => Array. Every element of the array is set to 1 if the
	        flow for the corresponding feature has been found, 0
	        otherwise.
	-track_error => Array of double numbers containing difference
	        between patches around the original and moved
	        points. Optional parameter; can be NULL .
	-criteria => Specifies when the iteration process of finding the
	        flow for each point on each pyramid level should be
	        stopped.  flags Miscellaneous flags:
	    * CV_LKFLOW_PYR_A_READY, pyramid for the first frame is
          pre-calculated before the call;
        * CV_LKFLOW_PYR_B_READY, pyramid for the second frame is
          pre-calculated before the call;
        * CV_LKFLOW_INITIAL_GUESSES, array B contains initial
          coordinates of features before the function call.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	cvCalcOpticalFlowPyrLK(
		$av{-prev},
		$av{-curr},
		$av{-prev_pyr},
		$av{-curr_pyr},
		$av{-prev_features},
		my $curr_features = [],
		pack("i2", cvSize($av{-win_size})),
		$av{-level},
		$av{-status} ||= [],
		$av{-track_error} ||= [],
		pack("i2d", cvTermCriteria($av{-criteria})),
		$av{-flags},
		);

	if (ref $av{-curr_features} eq 'ARRAY') {
		@{$av{-curr_features}} = ();
		foreach my $i (0 .. $#{$av{-prev_features}}) {
			if ($av{-status}->[$i]) {
				my ($x, $y) = cvPoint($curr_features->[$i]);
				push(@{$av{-curr_features}}, {
					prev => {
						'x' => $av{-prev_features}->[$i]{x},
						'y' => $av{-prev_features}->[$i]{y},
					},
					'x' => $x, 'y' => $y,
					track_error => $av{-track_error}->[$i],
					 });
			}
		}
	}
	scalar @{$av{-curr_features}};
}

# ======================================================================
#  3.5. Feature Matching
# ======================================================================

# ======================================================================
#  3.6. Estimators 
# ======================================================================

# ######################################################################
#  4. Pattern Recognition
# ######################################################################

# ======================================================================
#  4.1. Object Detection
# ======================================================================

# ------------------------------------------------------------
#  HaarDetectObjects - Detects objects in the image
#  (Cv::Image)
# ------------------------------------------------------------
sub HaarDetectObjects {
	my $self = shift;
	use Cv::HaarDetectObjects;
	Cv::HaarDetectObjects->new(-image => $self, @_);
}


# ######################################################################
#  5. Camera Calibration and 3D Reconstruction
# ######################################################################

# ======================================================================
#  5.1. Single and Stereo Camera Calibration
# ======================================================================

# ------------------------------------------------------------
#  ProjectPoints2 - Projects 3D points to image plane
# ------------------------------------------------------------

# ------------------------------------------------------------
#  FindHomography - Finds perspective transformation between two planes
# ------------------------------------------------------------
sub FindHomography {
	my $self = shift;
	my %av = &argv([ -src_points => undef,
					 -dst_points => undef,
					 -homography => undef,
					 -method => 0,
					 -ransacReprojThreshold => 0,
					 -mask => \0,
				   ], @_);
	unless (eval { $av{-src_points}->isa('Cv::Mat') } &&
			eval { $av{-dst_points}->isa('Cv::Mat') } &&
			eval { $av{-homography}->isa('Cv::Mat') } &&
			defined $av{-method} &&
			defined $av{-ransacReprojThreshold} &&
			(eval { $av{-mask}->isa('Cv::Mat') } ||
			 eval { ${$av{-mask}} == 0 })
		) {
		chop(my $usage = <<"----"
usage:	Cv->FindHomography(
	-src_points => Point coordinates in the original plane, 2xN, Nx2, 3xN or
	        Nx3 array (the latter two are for representation in homogeneous
	        coordinates), where N is the number of points. 
	-dst_points => Point coordinates in the destination plane, 2xN, Nx2, 3xN
	        or Nx3 array (the latter two are for representation in
	        homogeneous coordinates) 
	-homography => Output 3x3 homography matrix. 
	-method => The method used to computed homography matrix. One of:
	        0 - regular method using all the point pairs
	        CV_RANSAC - RANSAC-based robust method
	        CV_LMEDS - Least-Median robust method
	-ransacReprojThreshold => The maximum allowed reprojection error to
	        treat a point pair as an inlier. The parameter is only used in
	        RANSAC-based homography estimation. E.g. if dst_points
	        coordinates are measured in pixels with pixel-accurate
	        precision, it makes sense to set this parameter somewhere in the
	        range ~1..3. 
	-mask => The optional output mask set by a robust method (CV_RANSAC or
	        CV_LMEDS). 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvFindHomography(
		$av{-src_points},
		$av{-dst_points},
		$av{-homography},
		$av{-method},
		$av{-ransacReprojThreshold},
		$av{-mask},
		);
	$av{-homography};
}


# ------------------------------------------------------------
#  CalibrateCamera2 - Finds intrinsic and extrinsic camera parameters
#  using calibration pattern
# ------------------------------------------------------------
sub CalibrateCamera2 {
	my $self = shift;
	my %av = &argv([ -object_points => undef,
					 -image_points => undef,
					 -point_counts => undef,
					 -image_size => undef,
					 -intrinsic_matrix => undef,
					 -distortion_coeffs => undef,
					 -rotation_vectors => \0,
					 -translation_vectors => \0,
					 -flags => 0,
				   ], @_);
	unless (eval { $av{-object_points}->isa('Cv::Mat') } &&
			eval { $av{-image_points}->isa('Cv::Mat') } &&
			eval { $av{-point_counts}->isa('Cv::Mat') } &&
			eval { ref $av{-image_size} eq 'ARRAY' ||
				   ref $av{-image_size} eq 'HASH' } &&
			eval { $av{-intrinsic_matrix}->isa('Cv::Mat') } &&
			eval { $av{-distortion_coeffs}->isa('Cv::Mat') } &&
			(eval { $av{-rotation_vectors}->isa('Cv::Mat') } ||
			 eval { ${$av{-rotation_vectors}} == 0 }) &&
			(eval { $av{-translation_vectors}->isa('Cv::Mat') } ||
			 eval { ${$av{-translation_vectors}} == 0 }) &&
			defined $av{-flags}
		) {
		chop(my $usage = <<"----"
usage:	Cv->CalibrateCamera2(
	-object_points => The joint matrix of object points, 3xN or Nx3, where N
	        is the total number of points in all views.
	-image_points => The joint matrix of corresponding image points, 2xN or
	        Nx2, where N is the total number of points in all views.
	-points_count => Vector containing numbers of points in each particular
	        view, 1xM or Mx1, where M is the number of a scene views. 
	-image_size => Size of the image, used only to initialize intrinsic
            camera matrix. 
	-intrinsic_matrix => The output camera matrix 
	        A = [ [ fx 0 cx ], [ 0 fy cy ], [ 0 0 1 ] ].
	        If CV_CALIB_USE_INTRINSIC_GUESS and/or CV_CALIB_FIX_ASPECT_RATIO
	        are specified, some or all of fx, fy, cx, cy must be initialized. 
	-distortion_coeffs => The output vector of distortion coefficients, 4x1,
	        1x4, 5x1 or 1x5.
	-rotation_vectors => The output 3xM or Mx3 array of rotation vectors
	        (compact representation of rotation matrices, see cvRodrigues2).
	-translation_vectors => The output 3xM or Mx3 array of translation
	        vectors. 
	-flags => Different flags, may be 0 or combination of the following
	        values:
	    CV_CALIB_USE_INTRINSIC_GUESS -
	        intrinsic_matrix contains valid initial values of fx, fy, cx, cy
	        that are optimized further.  Otherwise, (cx, cy) is initially
	        set to the image center (image_size is used here), and focal
	        distances are computed in some least-squares fashion. Note, that
	        if intrinsic parameters are known, there is no need to use this
	        function. Use cvFindExtrinsicCameraParams2 instead.
	    CV_CALIB_FIX_PRINCIPAL_POINT -
	        The principal point is not changed during the global
	        optimization, it stays at the center and at the other location
	        specified (when CV_CALIB_FIX_FOCAL_LENGTH - Both fx and fy are
			fixed. CV_CALIB_USE_INTRINSIC_GUESS is set as well).
	    CV_CALIB_FIX_ASPECT_RATIO -
	        The optimization procedure consider only one of fx and fy as
	        independent variable and keeps the aspect ratio fx/fy the same
	        as it was set initially in intrinsic_matrix. In this case the
	        actual initial values of (fx, fy) are either taken from the
	        matrix (when CV_CALIB_USE_INTRINSIC_GUESS is set) or estimated
	        somehow (in the latter case fx, fy may be set to arbitrary
			values, only their ratio is used).
	    CV_CALIB_ZERO_TANGENT_DIST -
	        Tangential distortion coefficients are set to zeros and do not
	        change during the optimization.
	    CV_CALIB_FIX_K1 -
	        The 0-th distortion coefficient (k1) is fixed (to 0 or to the
	        initial passed value if CV_CALIB_USE_INTRINSIC_GUESS is passed)
	    CV_CALIB_FIX_K2 -
	        The 1-st distortion coefficient (k2) is fixed (see above)
	    CV_CALIB_FIX_K3 - The 4-th distortion coefficient (k3) is fixed
            (see above)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCalibrateCamera2(
		$av{-object_points},
		$av{-image_points},
		$av{-point_counts},
		pack("i2", cvSize($av{-image_size})),
		$av{-intrinsic_matrix},
		$av{-distortion_coeffs},
		$av{-rotation_vectors},
		$av{-translation_vectors},
		$av{-flags},
		);
}

sub Calibration {
	my $self = shift;
	my %av = &argv([-images => undef,
					-chess => undef,
					-chess_size => undef,
				  ], @_);
	#print STDERR Data::Dumper->Dump([\%av], [qw(av)]);
	my $sz = ${$av{-images}}[0]->GetSize;
	my $mapx = Cv->CreateImage($sz, &IPL_DEPTH_32F, 1);
	my $mapy = Cv->CreateImage($sz, &IPL_DEPTH_32F, 1);
	cvCalibration($av{-images},
				  $av{-chess},
				  $av{-chess_size},
				  $mapx,
				  $mapy,
		);
	{ 'x' => $mapx, 'y' => $mapy};
}

# ------------------------------------------------------------
#  CalibrationMatrixValues - Finds intrinsic and extrinsic camera
#  parameters using calibration pattern
# ------------------------------------------------------------

# ------------------------------------------------------------
#  FindExtrinsicCameraParams2 - Finds extrinsic camera parameters for
#  particular view
# ------------------------------------------------------------
sub FindExtrinsicCameraParams2 {
	my $self = shift;
	my %av = &argv([ -object_points => undef,
					 -image_points => undef,
					 -intrinsic_matrix => undef,
					 -distortion_coeffs => undef,
					 -rotation_vector => undef,
					 -translation_vector => undef,
				   ], @_);
	unless ( defined $av{-object_points} &&
			 defined $av{-image_points} &&
			 defined $av{-intrinsic_matrix} &&
			 defined $av{-distortion_coeffs} &&
			 defined $av{-rotation_vector} &&
			 defined $av{-translation_vector}
			 ) {
		chop(my $usage = <<"----"
usage:	Cv->FindExtrinsicCameraParams2(
	-object_points => The array of object points, 3xN or Nx3, where N
	is the number of points in the view. 
	-image_points => The array of corresponding image points, 2xN or
	Nx2, where N is the number of points in the view. 
	-intrinsic_matrix => The camera matrix (A) [fx 0 cx; 0 fy cy; 0 0 1]. 
	-distortion_coeffs => The vector of distortion coefficients, 4x1,
	1x4, 5x1 or 1x5. If it is NULL, the function assumes that all the
	distortion coefficients are 0\'s. 
	-rotation_vector => The output 3x1 or 1x3 rotation vector (compact
    representation of a rotation matrix, see cvRodrigues2). 
	-translation_vector => The output 3x1 or 1x3 translation vector. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvFindExtrinsicCameraParams2(
		$av{-object_points},
		$av{-image_points},
		$av{-intrinsic_matrix},
		$av{-distortion_coeffs},
		$av{-rotation_vector},
		$av{-translation_vector},
		0,						# useExtrinsicGuess for OpenCV 2.0
		);
}


# ------------------------------------------------------------
#  StereoCalibrate - Calibrates stereo camera
# ------------------------------------------------------------
sub StereoCalibrate {
	my $self = shift;
	my %av = &argv([ -object_points => undef,
					 -image_points1 => undef,
					 -image_points2 => undef,
					 -point_counts => undef,
					 -camera_matrix1 => undef, -dist_coeffs1 => undef,
					 -camera_matrix2 => undef, -dist_coeffs2 => undef,
					 -image_size => undef,
					 -R => undef, -T => undef, -E => \0, -F => \0,
					 -term_crit => scalar cvTermCriteria(
						  -type => &CV_TERMCRIT_ITER + &CV_TERMCRIT_EPS,
						  -max_iter => 30, -epsilon => 1e-6),
					 -flags => &CV_CALIB_FIX_INTRINSIC,
				   ], @_);
	unless (blessed $av{-object_points} &&
			blessed $av{-image_points1} && blessed $av{-image_points2} &&
			blessed $av{-point_counts} &&
			blessed $av{-camera_matrix1} && blessed $av{-dist_coeffs1} &&
			blessed $av{-camera_matrix2} && blessed $av{-dist_coeffs2} &&
			defined $av{-image_size} &&
			blessed $av{-R} && blessed $av{-T} &&
			(blessed $av{-E} || ref $av{-E} && ${$av{-E}} == 0) &&
			(blessed $av{-F} || ref $av{-F} && ${$av{-F}} == 0) &&
			defined $av{-term_crit} &&
			defined $av{-flags}) {
		chop(my $usage = <<"----"
usage:	Cv->StereoCalibrate(
	-object_points => The joint matrix of object points, 3xN or Nx3, where N
	        is the total number of points in all views. 
	-image_points1 => The joint matrix of corresponding image points in the
	        views from the 1st camera, 2xN or Nx2, where N is the total
	        number of points in all views. 
	-image_points2 => The joint matrix of corresponding image points in the
	        views from the 2nd camera, 2xN or Nx2, where N is the total
	        number of points in all views. 
	-point_counts => Vector containing numbers of points in each view, 1xM
	        or Mx1, where M is the number of views. 
	-camera_matrix1, -camera_matrix2 => The input/output camera matrices
	        [fxk 0 cxk; 0 fyk cyk; 0 0 1]. If CV_CALIB_USE_INTRINSIC_GUESS
	        or CV_CALIB_FIX_ASPECT_RATIO are specified, some or all of the
	        elements of the matrices must be initialized. 
	-dist_coeffs1, -dist_coeffs2 => The input/output vectors of distortion
	        coefficients for each camera, 4x1, 1x4, 5x1 or 1x5. 
	-image_size => Size of the image, used only to initialize intrinsic
	        camera matrix. 
	-R => The rotation matrix between the 1st and the 2nd cameras\'
	        coordinate systems 
	-T => The translation vector between the cameras\' coordinate systems. 
	-E => The optional output essential matrix 
	-F => The optional output fundamental matrix 
	-term_crit => Termination criteria for the iterative optimiziation
	        algorithm. 
	-flags => Different flags, may be 0 or combination of the following
	        values:
          CV_CALIB_FIX_INTRINSIC - If it is set, camera_matrix1,2, as
	        well as dist_coeffs1,2 are fixed, so that only extrinsic
	        parameters are optimized.
          CV_CALIB_USE_INTRINSIC_GUESS - The flag allows the function to
	        optimize some or all of the intrinsic parameters, depending on
	        the other flags, but the initial values are provided by the user
          CV_CALIB_FIX_PRINCIPAL_POINT - The principal points are fixed
	        during the optimization.
          CV_CALIB_FIX_FOCAL_LENGTH - fxk and fyk are fixed
          CV_CALIB_FIX_ASPECT_RATIO - fyk is optimized, but the ratio
	        fxk/fyk is fixed.
          CV_CALIB_SAME_FOCAL_LENGTH - Enforces fx0=fx1 and fy0=fy1.
	      CV_CALIB_ZERO_TANGENT_DIST - Tangential distortion coefficients
	        for each camera are set to zeros and fixed there.
          CV_CALIB_FIX_K1 - The 0-th distortion coefficients (k1) are fixed
          CV_CALIB_FIX_K2 - The 1-st distortion coefficients (k2) are fixed
          CV_CALIB_FIX_K3 - The 4-th distortion coefficients (k3) are fixed
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvStereoCalibrate(
		$av{-object_points},
		$av{-image_points1},
		$av{-image_points2},
		$av{-point_counts},
		$av{-camera_matrix1},
		$av{-dist_coeffs1},
		$av{-camera_matrix2},
		$av{-dist_coeffs2},
		pack("i2", cvSize($av{-image_size})),
		$av{-R},
		$av{-T},
		$av{-E},
		$av{-F},
		pack("i2d", cvTermCriteria($av{-term_crit})),
		$av{-flags},
		);
}

# ------------------------------------------------------------
#  StereoRectify - Computes rectification transform for stereo camera
# ------------------------------------------------------------
sub StereoRectify {
	my $self = shift;
	my %av = &argv([ -camera_matrix1 => undef,
					 -camera_matrix2 => undef,
					 -dist_coeffs1 => undef,
					 -dist_coeffs2 => undef,
					 -image_size => undef,
					 -R => undef,
					 -T => undef,
					 -R1 => undef,
					 -R2 => undef,
					 -P1 => undef,
					 -P2 => undef,
					 -Q => \0,
					 -flags => &CV_CALIB_ZERO_DISPARITY,
					 -new_image_size => scalar cvSize(0, 0), # Cv 2.1
					 -valid_pix_ROI1 => undef, # Cv 2.1
					 -valid_pix_ROI2 => undef, # Cv 2.1
					 ], @_);
	unless (blessed $av{-camera_matrix1} &&
			blessed $av{-camera_matrix2} &&
			blessed $av{-dist_coeffs1} &&
			blessed $av{-dist_coeffs2} &&
			defined $av{-image_size} &&
			blessed $av{-R} &&
			blessed $av{-T} &&
			blessed $av{-R1} &&
			blessed $av{-R2} &&
			blessed $av{-P1} &&
			blessed $av{-P2} &&
			(blessed $av{-Q} || ref $av{-Q} && ${$av{-Q}} == 0) &&
			defined $av{-flags}) {
		chop(my $usage = <<"----"
usage:	Cv->StereoRectify(
	-camera_matrix1, -camera_matrix2 => The camera matrices
	        [fxk 0 cxk; 0 fyk cyk; 0 0 1]. 
	-dist_coeffs1, -dist_coeffs2 => The vectors of distortion coefficients
	        for each camera, 4x1, 1x4, 5x1 or 1x5. 
	-image_size => Size of the image used for stereo calibration. 
	-R => The rotation matrix between the 1st and the 2nd cameras\'
	        coordinate systems 
	-T => The translation vector between the cameras\' coordinate systems. 
	-R1, -R2 => 3x3 Rectification transforms (rotation matrices) for the
	        first and the second cameras, respectively 
	-P1, -P2 => 3x4 Projection matrices in the new (rectified) coordinate
	    systems 
	-Q => The optional output disparity-to-depth mapping matrix, 4x4, see
	        cvReprojectImageTo3D. 
	-flags => The operation flags; may be 0 or CV_CALIB_ZERO_DISPARITY. If
	        the flag is set, the function makes the principal points of each
	        camera have the same pixel coordinates in the rectified views.
	        And if the flag is not set, the function can shift one of the
	        image in horizontal or vertical direction (depending on the
	        orientation of epipolar lines) in order to maximise the useful
	        image area.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvStereoRectify(
		$av{-camera_matrix1},
		$av{-camera_matrix2},
		$av{-dist_coeffs1},
		$av{-dist_coeffs2},
		pack("i2", cvSize($av{-image_size})),
		$av{-R},
		$av{-T},
		$av{-R1},
		$av{-R2},
		$av{-P1},
		$av{-P2},
		$av{-Q},
		$av{-flags},
		pack("i2", cvSize($av{-new_image_size})),
		my $roi1,				# Cv 2.1
		my $roi2,				# Cv 2.1
		);

	if (&CV_MAJOR_VERSION >= 2 && &CV_MINOR_VERSION >= 1) {
		if (ref $av{-valid_pix_ROI1}) {
			my ($x, $y, $width, $height) = unpack("i4", $roi1);
			if (ref $av{-valid_pix_ROI1} eq 'ARRAY') {
				@{$av{-valid_pix_ROI1}} =
					($x, $y, $width, $height);
			} elsif (ref $av{-valid_pix_ROI1} eq 'HASH') {
				%{$av{-valid_pix_ROI1}} =
					('x' => $x, 'y' => $y,
					 'width' => $width,
					 'height' => $height);
			}
		}
		if (ref $av{-valid_pix_ROI2}) {
			my ($x, $y, $width, $height) = unpack("i4", $roi2);
			if (ref $av{-valid_pix_ROI2} eq 'ARRAY') {
				@{$av{-valid_pix_ROI2}} =
					($x, $y, $width, $height);
			} elsif (ref $av{-valid_pix_ROI2} eq 'HASH') {
				%{$av{-valid_pix_ROI2}} =
					('x' => $x, 'y' => $y,
					 'width' => $width,
					 'height' => $height);
			}
		}
	}
}



# ------------------------------------------------------------
#  StereoRectifyUncalibrated - Computes rectification transform for
#  uncalibrated stereo camera
# ------------------------------------------------------------
sub StereoRectifyUncalibrated {
	my $self = shift;
	my %av = &argv([ -points1 => undef,
					 -points2 => undef,
					 -F => undef,
					 -image_size => undef,
					 -H1 => undef,
					 -H2 => undef,
					 -threshold => 5,
				   ], @_);
	unless (blessed $av{-points1} &&
			blessed $av{-points2} &&
			blessed $av{-F} &&
			defined $av{-image_size} &&
			blessed $av{-H1} &&
			blessed $av{-H2} &&
			defined $av{-threshold}) {
		chop(my $usage = <<"----"
usage:	Cv->StereoRectifyUncalibrated(
	-points1, -points2 => The 2 arrays of corresponding 2D points. 
	-F => Fundamental matrix. It can be computed using the same set of point
	        pairs points1 and points2 using cvFindFundamentalMat 
	-image_size => Size of the image. 
	-H1, -H2 => The rectification homography matrices for the first and for
	        the second images. 
	-threshold => Optional threshold used to filter out the outliers. If the
	        parameter is greater than zero, then all the point pairs that do
	        not comply the epipolar geometry well enough (that is, the
			points for which fabs(points2[i]T*F*points1[i])>threshold) are
	        rejected prior to computing the homographies.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvStereoRectifyUncalibrated(
		$av{-points1},
		$av{-points2},
		$av{-F},
		pack("i2", cvSize($av{-image_size})),
		$av{-H1},
		$av{-H2},
		$av{-threshold},
		);
}


# ------------------------------------------------------------
#  Rodrigues2 - Converts rotation matrix to rotation vector or vice versa
# ------------------------------------------------------------


# ------------------------------------------------------------
#  Undistort2 - Transforms image to compensate lens distortion
# ------------------------------------------------------------
sub Undistort2 {
	my $self = shift;
	my %av = &argv([ -intrinsic_matrix => undef,
					 -distortion_coeffs => undef,
					 -new_camera_matrix => \0, # Cv 2.1
					 -dst => undef,
					 -src => $self,
				   ], @_);
	unless (blessed($av{-src}) &&
			defined($av{-intrinsic_matrix}) &&
			defined($av{-distortion_coeffs})) {
		chop(my $usage = <<"----"
usage:	Cv->Undistort2(
	-dst => The output (corrected) image. 
	-intrinsic_matrix => The camera matrix (A) [fx 0 cx; 0 fy cy; 0 0 1]. 
	-distortion_coeffs => The vector of distortion coefficients,
	4x1, 1x4, 5x1 or 1x5. 
	-src => The input (distorted) image. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-dst} ||= $av{-src}->new;
	cvUndistort2(
		$av{-src},
		$av{-dst},
		$av{-intrinsic_matrix},
		$av{-distortion_coeffs},
		$av{-new_camera_matrix},
		);
	$av{-dst};
}

# ------------------------------------------------------------
#  InitUndistortMap - Computes undistortion map
# ------------------------------------------------------------
sub InitUndistortMap {
	my $self = shift;
	my %av = &argv([ -camera_matrix => undef,
					 -dist_coeffs => undef,
					 -mapx => undef,
					 -mapy =>undef,
				   ], @_);
	unless (defined($av{-camera_matrix}) &&
			defined($av{-dist_coeffs}) &&
			blessed($av{-mapx}) &&
			blessed($av{-mapy})) {
		chop(my $usage = <<"----"
usage:	Cv->InitUndistortMap(
	-camera_matrix => The camera matrix A = [ fx 0 cx; 0 fy cy; 0 0 1 ]. 
	-distortion_coeffs => The vector of distortion coefficients, 4x1, 1x4,
	        5x1 or 1x5. 
	-mapx => The output array of x-coordinates of the map. 
	-mapy => The output array of Y-coordinates of the map.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvInitUndistortMap(
		$av{-camera_matrix},
		$av{-dist_coeffs},
		$av{-mapx},
		$av{-mapy},
		);
}


# ------------------------------------------------------------
#  InitUndistortRectifyMap - Computes undistortion+rectification
#  transformation map a head of stereo camera
# ------------------------------------------------------------
sub InitUndistortRectifyMap {
	my $self = shift;
	my %av = &argv([ -camera_matrix => undef,
					 -dist_coeffs => undef,
					 -R => undef,
					 -new_camera_matrix => undef,
					 -mapx => undef,
					 -mapy =>undef,
				   ], @_);
	unless (blessed($av{-camera_matrix}) &&
			blessed($av{-dist_coeffs}) &&
			blessed($av{-R}) &&
			blessed($av{-new_camera_matrix}) &&
			blessed($av{-mapx}) &&
			blessed($av{-mapy})) {
		chop(my $usage = <<"----"
usage:	Cv->InitUndistortRectifyMap(
	-camera_matrix => The camera matrix
	        A = [ fx 0 cx; 0 fy cy; 0 0 1 ]. 
	-distortion_coeffs => The vector of distortion coefficients, 4x1, 1x4,
	        5x1 or 1x5. 
	-R => The rectification transformation in object space (3x3 matrix). R1
	        or R2, computed by cvStereoRectify can be passed here. If the
	        parameter is NULL, the identity matrix is used. 
	-new_camera_matrix => The new camera matrix
	        A\' = [ fx\' 0 cx\'; 0 fy\' cy\'; 0 0 1 ]. 
	-mapx => The output array of x-coordinates of the map. 
	-mapy => The output array of Y-coordinates of the map.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvInitUndistortRectifyMap(
		$av{-camera_matrix},
		$av{-dist_coeffs},
		$av{-R},
		$av{-new_camera_matrix},
		$av{-mapx},
		$av{-mapy},
		);
}


# ------------------------------------------------------------
#  UndistortPoints - Computes the ideal point coordinates from the
#  observed point coordinates
# ------------------------------------------------------------
sub UndistortPoints {
	my $self = shift;
	my %av = &argv([ -src => undef,
					 -dst => undef,
					 -camera_matrix => undef,
					 -dist_coeffs => undef,
					 -R => \0,
					 -P => \0
				   ], @_);
	unless (blessed($av{-src}) &&
			blessed($av{-dst}) &&
			blessed($av{-camera_matrix}) &&
			blessed($av{-dist_coeffs}) &&
			(blessed($av{-R}) || ref $av{-R} && ${$av{-R}} == 0) &&
			(blessed($av{-P}) || ref $av{-P} && ${$av{-P}} == 0)) {
		chop(my $usage = <<"----"
usage:	Cv->UndistortPoints(
	-src => The observed point coordinates. 
	-dst => The ideal point coordinates, after undistortion and reverse
	        perspective transformation.
	-camera_matrix => The camera matrix A = [fx 0 cx; 0 fy cy; 0 0 1]. 
	-distortion_coeffs => The vector of distortion coefficients, 4x1, 1x4,
	        5x1 or 1x5. 
	-R => The rectification transformation in object space (3x3 matrix). R1
	        or R2, computed by cvStereoRectify can be passed here. If the
	        parameter is NULL, the identity matrix is used. 
	-P => The new camera matrix (3x3) or the new projection matrix (3x4). P1
	        or P2, computed by cvStereoRectify can be passed here. If the
	        parameter is NULL, the identity matrix is used.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvUndistortPoints(
		$av{-src},
		$av{-dst},
		$av{-camera_matrix},
		$av{-dist_coeffs},
		$av{-R},
		$av{-P},
		);
}

# ------------------------------------------------------------
#  FindChessboardCorners - Finds positions of internal corners of the
#  chessboard
# ------------------------------------------------------------
sub FindChessboardCorners {
	my $self = shift;
	my %av = &argv([ -pattern_size => undef,
					 -corners => [ ],
					 -corner_count => 0,
					 -flags => &CV_CALIB_CB_ADAPTIVE_THRESH,
					 -image => $self,
				   ], @_);
	unless (blessed $av{-image} &&
			defined $av{-pattern_size} &&
			defined $av{-corners} &&
			defined $av{-flags}) {
		chop(my $usage = <<"----"
usage:	Cv->FindChessboardCorners(
	-image => Source chessboard view; it must be 8-bit grayscale or color
	        image.
	-pattern_size => The number of inner corners per chessboard row and
	        column.
	-corners => The output array of corners detected.
	-corner_count => The output corner counter. If it is not NULL, the
	        function stores there the number of corners found.
	-flags => Various operation flags, can be 0 or a combination of the
	        following values:
	        CV_CALIB_CB_ADAPTIVE_THRESH - use adaptive thresholding to
	        convert the image to black-n-white, rather than a fixed
	        threshold level (computed from the average image brightness).
	        CV_CALIB_CB_NORMALIZE_IMAGE - normalize the image using
	        cvNormalizeHist before applying fixed or adaptive thresholding.
	        CV_CALIB_CB_FILTER_QUADS - use additional criteria (like contour
	        area, perimeter, square-like shape) to filter out false quads
	        that are extracted at the contour retrieval stage.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $r = cvFindChessboardCorners(
		$av{-image},
		pack("i2", cvSize($av{-pattern_size})),
		$av{-corners},
		my $corner_count,
		$av{-flags},
		);
	if (ref $av{-corner_count} eq 'SCALAR') {
		${$av{-corner_count}} = $corner_count;
	}
	$r;
}


# ------------------------------------------------------------
#  DrawChessBoardCorners - Renders the detected chessboard corners
# ------------------------------------------------------------
sub DrawChessboardCorners {
	my $self = shift;
	my %av = &argv([ -pattern_size => undef,
					 -corners => [ ],
					 -count => undef,
					 -pattern_was_found => undef,
					 -image => $self,
				   ], @_);
	$av{-count} ||= scalar @{$av{-corners}};
	unless (blessed $av{-image} &&
			defined $av{-pattern_size} &&
			defined $av{-corners} &&
			defined $av{-count} &&
			defined $av{-pattern_was_found}) {
		chop(my $usage = <<"----"
usage:	Cv->DrawChessboardCorners(
	-image => The destination image; it must be 8-bit color image.
	-pattern_size => The number of inner corners per chessboard row and
	        column.
	-corners => The array of corners detected.
	-count => The number of corners.
	-pattern_was_found => Indicates whether the complete board was
	        found (!= 0) or not (=0). One may just pass the return value
	        cvFindChessboardCorners here.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvDrawChessboardCorners(
		$av{-image},
		pack("i2", cvSize($av{-pattern_size})),
		$av{-corners},
		$av{-count},
		$av{-pattern_was_found},
		);
	$av{-image};
}

# ======================================================================
#  5.2. Pose Estimation
# ======================================================================

# ======================================================================
#  5.3. Epipolar Geometry, Stereo Correspondence
# ======================================================================

# ------------------------------------------------------------
#  FindFundamentalMat - Calculates fundamental matrix from
#  corresponding points in two images
# ------------------------------------------------------------
sub FindFundamentalMat {
	my $self = shift;
	my %av = &argv([ -points1 => undef,
					 -points2 => undef,
					 -fundamental_matrix => undef,
					 -method => &CV_FM_RANSAC,
					 -param1 => 3.00,
					 -param2 => 0.99,
					 -status => \0,
				   ], @_);
	unless (blessed $av{-points1} &&
			blessed $av{-points2} &&
			blessed $av{-fundamental_matrix} &&
			defined $av{-method} &&
			defined $av{-param1} &&
			defined $av{-param2} &&
			defined $av{-status}) {
		chop(my $usage = <<"----"
usage:	Cv->FindFundamentalMat(
	-points1 => Array of the first image points of 2xN, Nx2, 3xN or Nx3 size
	        (where N is number of points). Multi-channel 1xN or Nx1 array is
	        also acceptable. The point coordinates should be floating-point
	        (single or double precision) 
	-points2 => Array of the second image points of the same size and format
	        as points1 
	-fundamental_matrix => The output fundamental matrix or matrices. The
	        size should be 3x3 or 9x3 (7-point method may return up to 3
	        matrices). 
	-method => Method for computing the fundamental matrix 
	        CV_FM_7POINT - for 7-point algorithm. N == 7 
	        CV_FM_8POINT - for 8-point algorithm. N >= 8 
	        CV_FM_RANSAC - for RANSAC algorithm. N > 8 
	        CV_FM_LMEDS - for LMedS algorithm. N > 8 
	-param1 => The parameter is used for RANSAC method only. It is the
	        maximum distance from point to epipolar line in pixels, beyond
	        which the point is considered an outlier and is not used for
	        computing the final fundamental matrix. Usually it is set
	        somewhere from 1 to 3. 
	-param2 => The parameter is used for RANSAC or LMedS methods only. It
	        denotes the desirable level of confidence of the fundamental
	        matrix estimate. 
	-status => The optional output array of N elements, every element of
	        which is set to 0 for outliers and to 1 for the "inliers", i.e.
	        points that comply well with the estimated epipolar geometry.
	        The array is computed only in RANSAC and LMedS methods. For
	        other methods it is set to all 1\'s.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvFindFundamentalMat(
		$av{-points1},
		$av{-points2},
		$av{-fundamental_matrix},
		$av{-method},
		$av{-param1},
		$av{-param2},
		$av{-status},
		);
}


# ------------------------------------------------------------
#  ComputeCorrespondEpilines - For points in one image of stereo pair
#  computes the corresponding epilines in the other image
# ------------------------------------------------------------
sub ComputeCorrespondEpilines {
	my $self = shift;
	my %av = &argv([ -points => undef,
					 -which_image => undef,
					 -fundamental_matrix => undef,
					 -correspondent_lines => undef,
				   ], @_);
	unless (blessed $av{-points} &&
			defined $av{-which_image} &&
			blessed $av{-fundamental_matrix} &&
			blessed $av{-correspondent_lines}) {
		chop(my $usage = <<"----"
usage:	Cv->ComputeCorrespondEpilines(
	-points => The input points. 2xN, Nx2, 3xN or Nx3 array (where N number
	        of points). Multi-channel 1xN or Nx1 array is also acceptable. 
	-which_image => Index of the image (1 or 2) that contains the points 
	-fundamental_matrix => Fundamental matrix 
	-correspondent_lines => Computed epilines, 3xN or Nx3 array
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvComputeCorrespondEpilines(
		$av{-points},
		$av{-which_image},
		$av{-fundamental_matrix},
		$av{-correspondent_lines},
		);
}


# ------------------------------------------------------------
#  ConvertPointsHomogeneous - Convert points to/from homogeneous
#  coordinates
# ------------------------------------------------------------



# ------------------------------------------------------------
#  CvStereoBMState - The structure for block matching stereo
#          correspondence algorithm
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CreateStereoBMState - Creates block matching stereo correspondence
#          structure
#  ReleaseStereoBMState - Releases block matching stereo
#          correspondence structure
#  FindStereoCorrespondenceBM - Computes the disparity map using block
#          matching algorithm
#  (Cv::StereoBMState)
# ------------------------------------------------------------


# ------------------------------------------------------------
#  CvStereoGCState - The structure for graph cuts-based stereo
#  correspondence algorithm
# ------------------------------------------------------------


# ------------------------------------------------------------
#  CreateStereoGCState - Creates the state of graph cut-based stereo
#  correspondence algorithm
# ------------------------------------------------------------


# ------------------------------------------------------------
#  ReleaseStereoGCState - Releases the state structure of the graph
#  cut-based stereo correspondence algorithm
# ------------------------------------------------------------


# ------------------------------------------------------------
#  FindStereoCorrespondenceGC - Computes the disparity map using graph
#  cut-based algorithm
# ------------------------------------------------------------


# ------------------------------------------------------------
#  ReprojectImageTo3D - Reprojects disparity image to 3D space
# ------------------------------------------------------------


# ######################################################################
# ### HighGUI ##########################################################
# ######################################################################

# ------------------------------------------------------------
#  cvSaveImage - Saves an image to the file
# ------------------------------------------------------------
sub SaveImage {
	my $self = shift;
	my %av = &argv([ -filename => undef,
					 -image => $self,
				   ], @_);
	unless (defined($av{-filename}) &&
			blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv::Image->SaveImage(
	-filename => Name of the file. 
	-image => Image to be saved.
	)
----
		 );
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSaveImage($av{-filename}, $av{-image});
	$self;
}

sub save {
	my $self = shift;
	$self->SaveImage(@_);
}


1;
