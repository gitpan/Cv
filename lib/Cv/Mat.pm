# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Mat;

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
use Cv::Arr;

our @ISA = qw(Cv::Arr);

our $VERSION = '0.03';

# Preloaded methods go here.

# ------------------------------------------------------------
#  CreateMat - Creates new matrix
# ------------------------------------------------------------
sub CreateMat {
    my $self = shift;
	my %av = &argv([ -rows => undef,
					 -cols => undef,
					 -type => undef,
				   ], @_);
	$av{-cols} ||= 1 if $av{-rows};
	if (my $phys = cvCreateMat($av{-rows}, $av{-cols}, $av{-type})) {
		bless $phys;
	} else {
		undef;
	}
}

sub new {
    my $self = shift;
	my %av = &argv([ -rows => undef,
					 -cols => undef,
					 -type => undef,
				   ], @_);
	if (blessed($self)) {
		$av{-rows} ||= $self->rows;
		$av{-cols} ||= $self->cols;
		$av{-type} ||= $self->GetElemType;
	}
	$self->CreateMat($av{-rows}, $av{-cols}, $av{-type});
}

sub DESTROY {
	my $self = shift;
	cvReleaseMat($self);
}

sub cols {
	my $self = shift;
	$self->SUPER::width(@_);
}

sub rows {
	my $self = shift;
	$self->SUPER::height(@_);
}

sub total {
	my $self = shift;
	$self->rows(@_) * $self->cols(@_);
}

sub refcount {
	my $self = shift;
	CvMat_refcount($self);
}

# ------------------------------------------------------------
#  CreateMat - Creates new matrix
# ------------------------------------------------------------

# ------------------------------------------------------------
#  ReleaseMat - Deallocates matrix
# ------------------------------------------------------------

# ------------------------------------------------------------
#  Mat - Initializes matrix header (light-weight variant)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CloneMat - Creates matrix copy
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CreateMatND - Creates multi-dimensional dense array
# ------------------------------------------------------------

# ------------------------------------------------------------
#  ReleaseMatND - Deallocates multi-dimensional array
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CloneMatND - Creates full copy of multi-dimensional array
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CreateSparseMat - Creates sparse array
# ------------------------------------------------------------

# ------------------------------------------------------------
#  ReleaseSparseMat - Deallocates sparse array
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CloneSparseMat - Creates full copy of sparse array
# ------------------------------------------------------------


# ######################################################################
#  2. Structural Analysis
# ######################################################################

# ======================================================================
#  2.1. Contour Processing Functions
# ======================================================================

# ------------------------------------------------------------
#  (X) ApproxChains - Approximates Freeman chain(s) with polygonal curve
# ------------------------------------------------------------
sub ApproxChains {
	croak "### XXX ###";
}

# ------------------------------------------------------------
#  (X) StartReadChainPoints - Initializes chain reader
# ------------------------------------------------------------
sub StartReadChainPoints {
	croak "### XXX ###";
}

# ------------------------------------------------------------
#  (X) ReadChainPoint - Gets next chain point
# ------------------------------------------------------------
sub ReadChainPoint {
	croak "### XXX ###";
}

# ------------------------------------------------------------
#  ApproxPoly - Approximates polygonal curve(s) with desired precision
# ------------------------------------------------------------
sub ApproxPoly {
	my $self = shift;
	my %av = argv([	-method => &CV_POLY_APPROX_DP,
					-parameter => undef,
					-parameter2 => 0,
					-src_seq => $self,
					-header_size => undef, # XXXXX $self->{header_size},
					-storage => \0,
				  ], @_);
	unless (defined($av{-points})) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->ApproxPoly(
	-src_seq => Sequence of array of points. 
	-header_size => Header size of approximated curve[s]. 
	-storage => Container for approximated contours. If it is NULL, the
	        input sequences\' storage is used. 
	-method => Approximation method; only CV_POLY_APPROX_DP is supported,
	        that corresponds to Douglas-Peucker algorithm. 
	-parameter => Method-specific parameter; in case of CV_POLY_APPROX_DP
	        it is a desired approximation accuracy. 
	-parameter2 => If case if src_seq is sequence it means whether the
	        single sequence should be approximated or all sequences on the
	        same level or below src_seq (see cvFindContours for description
	        of hierarchical contour structures). And if src_seq is array
	        (CvMat*) of points, the parameter specifies whether the curve
	        is closed (parameter2!=0) or not (parameter2=0).
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvApproxPoly(
		$av{-src_seq},
		$av{-header_size},
		$av{-storage},
		$av{-method},
		$av{-parameter},
		$av{-parameter2},
		), 'Cv::Seq';
}


# ------------------------------------------------------------
#  BoundingRect - Calculates up-right bounding rectangle of point set
# ------------------------------------------------------------
sub BoundingRect {
	my $self = shift;
	my %av = &argv([ -update => 0,
					 -points => $self,
				   ], @_);
	unless (defined($av{-points})) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->BoundingRect(
	-points => Either a 2D point set, represented as a sequence (CvSeq*,
	        CvContour*) or vector (CvMat*) of points, or 8-bit single-
	        channel mask image (CvMat*, IplImage*), in which non-zero
	        pixels are considered. 
	-update => The update flag. Here is list of possible combination of the
	        flag values and type of contour:
	         * points is CvContour*, update=0: the bounding rectangle is
	           not calculated, but it is read from rect field of the
	           contour header.
	         * points is CvContour*, update=1: the bounding rectangle is
	           calculated and written to rect field of the contour header.
	           For example, this mode is used by cvFindContours.
	         * points is CvSeq* or CvMat*: update is ignored, the bounding
	           rectangle is calculated and returned. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my ($x, $y, $width, $height) =
		unpack("d4", cvBoundingRect($av{-points}, $av{-update}));
	my $rect = {
		'x' => $x,
		'y' => $y,
		'width' => $width,
		'height' => $height,
	};
}

# ------------------------------------------------------------
#  ContourArea - Calculates area of the whole contour or contour section
# ------------------------------------------------------------
sub ContourArea {
	my $self = shift;
	my %av = argv([ -slice => &CV_WHOLE_SEQ,
					-contour => $self,
					-oriented => 0,	# Cv 2.1
				  ], @_);
	unless (defined($av{-contour}) &&
			defined($av{-slice})) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->ContourArea(
	-contour => Contour (Sequence or array of vertices).
	-slice => Starting and ending points of the curve, by default the
	        whole curve length is calculated.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvContourArea(
		$av{-contour},
		pack("i2", cvSlice($av{-slice})),
		$av{-oriented},
		);
}

# ------------------------------------------------------------
#  ArcLength, ContourPerimeter - Calculates contour perimeter or curve
#  length
# ------------------------------------------------------------
sub ArcLength {
	my $self = shift;
	my %av = argv([ -slice => &CV_WHOLE_SEQ,
					-is_closed => -1,
					-curve => $self,
				  ], @_);

	unless (defined($av{-curve})) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->ArcLength(
	-curve => Sequence or array of the curve points. 
	-slice => Starting and ending points of the curve, by default the whole
	        curve length is calculated.
	-is_closed => Indicates whether the curve is closed or not. There are 3
	        cases:
	         * is_closed = 0 - the curve is assumed to be unclosed.
	         * is_closed > 0 - the curve is assumed to be closed.
	         * is_closed < 0 - if curve is sequence, the flag
	        CV_SEQ_FLAG_CLOSED of ((CvSeq*)curve)->flags is checked to
	        determine if the curve is closed or not, otherwise (curve is
	        represented by array (CvMat*) of points) it is assumed to be
	        unclosed.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvArcLength(
		$av{-curve},
		pack("i2", cvSlice($av{-slice})),
		$av{-is_closed});
}


sub ContourPerimeter {
	my $self = shift;
	my %av = argv([ -curve => $self,
				  ], @_);
	$av{-curve}->ArcLength(-is_closed => 1);
}


# ------------------------------------------------------------
# (X) CreateContourTree - Creates hierarchical representation of contour
# ------------------------------------------------------------
sub CreateContourTree { croak "### TBD ###"; }

# ------------------------------------------------------------
# (X) ContourFromContourTree - Restores contour from tree
# ------------------------------------------------------------
sub ContourFromContourTree { croak "### TBD ###"; }

# ------------------------------------------------------------
# (X) MatchContourTrees - Compares two contours using their tree representations
# ------------------------------------------------------------
sub MatchContourTrees { croak "### TBD ###"; }


# ======================================================================
#  2.2. Computational Geometry
# ======================================================================

# ------------------------------------------------------------
#  CvBox2D - Rotated 2D box
#  MaxRect - Finds bounding rectangle for two given rectangles
#  BoxPoints - Finds box vertices
#  (Cv::CxCore)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  PointSeqFromMat - Initializes point sequence header from a point vector
# ------------------------------------------------------------
sub PointSeqFromMat {
	my $self = shift;
	my %av = &argv([ -seq_kind => undef,
					 -mat => $self,
					 -contour_header => undef,
					 -block => undef,
				   ], @_);
	unless (defined($av{-src_kind}) &&
			defined($av{-mat}) &&
			defined($av{-contour_header}) &&
			defined($av{-block})) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->PointSeqFromMat(
	-seq_kind => Type of the point sequence:
	        point set (0), a curve (CV_SEQ_KIND_CURVE), closed curve
	        (CV_SEQ_KIND_CURVE + CV_SEQ_FLAG_CLOSED) etc.
	-mat => Input matrix. It should be continuous 1-dimensional vector of
	        points, that is, it should have type CV_32SC2 or CV_32FC2.
	-contour_header => Contour header, initialized by the function. 
	-block => Sequence block header, initialized by the function.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvPointSeqFromMat(
		$av{-seq_kind},
		$av{-mat},
		$av{-contour_header},
		$av{-block},
		), 'Cv::Seq::Point';
}

# ------------------------------------------------------------
#  FitEllipse - Fits ellipse to set of 2D points
# ------------------------------------------------------------
sub FitEllipse2 {
	my $self = shift;
	my %av = &argv([ -points => $self,
				   ], @_);
	unless (defined($av{-points})) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->FitEllipse2(
	-points => Sequence or array of points.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	return undef unless ($av{-points}->total >= 6);
	my ($x, $y, $width, $height, $angle) =
		unpack("f5", cvFitEllipse2($av{-points}));
	my $rect = {
		center => { 'x' => $x,
					'y' => $y,
		},
		size => { 'width' => $width,
				  'height' => $height,
		},
		angle => $angle,
	};
}

sub FitEllipse {
	my $self = shift;
	$self->FitEllipse2(@_);
}

# ------------------------------------------------------------
#  FitLine - Fits line to 2D or 3D point set
# ------------------------------------------------------------
sub FitLine {
	my $self = shift;
	my %av = &argv([ -dist_type => &CV_DIST_L2,
					 -param => 0,
					 -reps => 0.01,
					 -aeps => 0.01,
					 -line => undef,
					 -points => $self,
				   ], @_);
	$av{-line} ||= { };
	unless (defined($av{-points}) &&
			defined($av{-dist_type}) &&
			defined($av{-param}) &&
			defined($av{-reps}) && defined($av{-aeps}) &&
			defined($av{-line}) &&
			(ref $av{-line} eq 'HASH' || ref $av{-line} eq 'ARRAY')) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Mat->FitLine(
	-points => Sequence or array of 2D or 3D points with 32-bit  integer or
	        floating-point coordinates.
	-dist_type => The distance used for fitting (see the discussion).
	-param => Numerical parameter (C) for some types of distances, if 0 then
	        some optimal value is chosen.
	-reps, -aeps => Sufficient accuracy for radius (distance between the
	        coordinate origin and the line) and angle, respectively, 0.01
	        would be a good defaults for both.
	-line => The output line parameters. In case of 2d fitting it is array
	        of 4 floats (vx, vy, x0, y0) where (vx, vy) is a normalized
	        vector collinear to the line and (x0, y0) is some point on the
	        line. In case of 3D fitting it is array of 6 floats (vx, vy, vz,
			x0, y0, z0) where (vx, vy, vz) is a normalized vector collinear
	        to the line and (x0, y0, z0) is some point on the line.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $d = cvFitLine(
		$av{-points},
		$av{-dist_type},
		$av{-param},
		$av{-reps}, $av{-aeps},
		my $line = [],
		);
	if (ref $av{-line} eq 'ARRAY') {
		if ($d == 2 || $d == 3) {
			foreach my $i (0 .. $d * 2) {
				$av{-line}->[$i] = $line->[$i];
			}
		} else {
			goto usage;
		}
	} elsif (ref $av{-line} eq 'HASH') {
		if ($d == 2) {
			$av{-line}->{vx} = $line->[0];
			$av{-line}->{vy} = $line->[1];
			$av{-line}->{x0} = $line->[2];
			$av{-line}->{y0} = $line->[3];
		} elsif ($d == 3) {
			$av{-line}->{vx} = $line->[0];
			$av{-line}->{vy} = $line->[1];
			$av{-line}->{vz} = $line->[2];
			$av{-line}->{x0} = $line->[3];
			$av{-line}->{y0} = $line->[4];
			$av{-line}->{z0} = $line->[5];
		} else {
			goto usage;
		}
	} else {
		goto usage;
	}
	$av{-line};
}

# ------------------------------------------------------------
#  ConvexHull2 - Finds convex hull of point set
# ------------------------------------------------------------
sub ConvexHull2 {
	my $self = shift;
	my %av = &argv([ -points => $self,
					 -storage => \0,
					 -orientation => &CV_CLOCKWISE,
					 -return_points => 0,
				   ], @_);
	unless (blessed $av{-points} &&
			(&CV_IS_SEQ($av{-points}) && $av{-return_points} ||
			 &CV_IS_MAT($av{-points}))) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->ConvexHull2(
	-points => Sequence or array of 2D points with 32-bit integer or
	        floating-point coordinates.
	-storage => The destination array (CvMat*) or memory storage
	        (CvMemStorage*) that will store the convex hull.  If it is
	        array, it should be 1d and have the same number of elements as
	        the input array/sequence. On output the header is modified: the
	        number of columns/rows is truncated down to the hull size.
	-orientation => Desired orientation of convex hull: CV_CLOCKWISE or
	        CV_COUNTER_CLOCKWISE.
	-return_points => If non-zero, the points themselves will be stored in
	        the hull instead of indices if hull_storage is array, or
	        pointers if hull_storage is memory storage.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $phys = cvConvexHull2(
			$av{-points},
			$av{-storage},
			$av{-orientation},
			$av{-return_points},
		)) {
		bless $phys, 'Cv::Seq::Point';
	} else {
		undef;
	}
}


# ------------------------------------------------------------
#  CheckContourConvexity - Tests contour convex
# ------------------------------------------------------------
sub CheckContourConvexity {
	my $self = shift;
	my %av = &argv([ -contour => $self,
				   ], @_);
	unless (blessed $av{-contour}) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->CheckContourConvexity(
	-contour => Tested contour (sequence or array of points).
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCheckContourConvexity(
		$av{-contour},
		);
}

# ------------------------------------------------------------
#  ConvexityDefects - Finds convexity defects of contour
# ------------------------------------------------------------
sub ConvexityDefects {
	my $self = shift;
	my %av = &argv([ -contour => $self,
					 -convexhull => undef,
					 -storage => \0,
				   ], @_);
	unless (blessed $av{-contour} &&
			defined $av{-convexhull} &&
			defined $av{-storage}) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->ConvexityDefects(
	-contour => Input contour. 
	-convexhull => Convex hull obtained using cvConvexHull2 that should
	        contain pointers or indices to the contour points, not the hull
	        points themselves, i.e. return_points parameter in cvConvexHull2
	        should be 0. 
	-storage => Container for output sequence of convexity defects. If it is
	        NULL, contour or hull (in that order) storage is used.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvConvexityDefects(
		$av{-contour},
		$av{-convexhull},
		$av{-storage},
		), 'Cv::Seq::ConvexityDefect'; # XXXXX
}


# ------------------------------------------------------------
#  PointPolygonTest - Point in contour test
# ------------------------------------------------------------
sub PointPolygonTest {
	my $self = shift;
	my %av = &argv([ -pt => undef,
					 -measure_dist => undef,
					 -contour => $self,
				   ], @_);
	unless (blessed $av{-contour} &&
			defined $av{-pt} &&
			defined $av{-measure_dist}) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->PointPolygonTest(
	-contour => Input contour. 
	-pt => The point tested against the contour. 
	-measure_dist => If it is non-zero, the function estimates distance from
	        the point to the nearest contour edge.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvPointPolygonTest(
		$av{-contour},
		pack("d2", cvPoint($av{-pt})),
		$av{-measure_dist},
		);
}

# ------------------------------------------------------------
#  MinAreaRect2 - Finds circumscribed rectangle of minimal area for
#                 given 2D point set
# ------------------------------------------------------------
sub MinAreaRect2 {
	my $self = shift;
	my %av = &argv([ -points => $self,
					 -storage => \0,
				   ], @_);
	unless (defined($av{-points})) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->MinAreaRect2(
	-points => Sequence or array of points. 
	-storage => Optional temporary memory storage.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my ($x, $y, $width, $height, $angle) =
		unpack("f5", cvMinAreaRect2($av{-points}, $av{-storage}));
	my $rect = {
		center => { 'x' => $x,
					'y' => $y, },
		size => { 'width' => $width,
				  'height' => $height, },
		angle => $angle,
	};
}

# ------------------------------------------------------------
#  MinEnclosingCircle - Finds circumscribed circle of minimal area for
#                       given 2D point set
# ------------------------------------------------------------
sub MinEnclosingCircle {
	my $self = shift;
	my %av = &argv([ -points => $self,
					 #-center => undef,
					 #-radius => undef,
				   ], @_);
	unless (defined($av{-points})) {
		chop(my $usage = <<"----"
usage:	Cv::Mat->MinEnclosingCircle(
	-points => Sequence or array of 2D points. 
	-center => Output parameter. The center of the enclosing circle. 
	-radius => Output parameter. The radius of the enclosing circle.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvMinEnclosingCircle($av{-points});
}

# ------------------------------------------------------------
#  CalcPGH - Calculates pair-wise geometrical histogram for contour
# ------------------------------------------------------------
sub CalcPGH {
	my $self = shift;
	my %av = &argv([ -contour => $self,
					 -hist => undef,
				   ], @_);
	cvCalcPGH(
		$av{-contour},
		$av{-hist},
		);
	$self;
}


1;
