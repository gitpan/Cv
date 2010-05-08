# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Seq;

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
use Cv::Mat;
use Cv::Seq::Reader;

our @ISA = qw(Cv::Mat);

our $VERSION = '0.03';

# Preloaded methods go here.

# ======================================================================
#  3.2. Sequences
# ======================================================================

# ------------------------------------------------------------
#  CvSeq - Growable sequence of elements
# ------------------------------------------------------------

# ------------------------------
#  flags - miscellaneous flags
# ------------------------------

# ------------------------------
#  header_size - size of sequence header
# ------------------------------
sub header_size {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->header_size(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	CvSeq_header_size($av{-seq});
}

# ------------------------------
#  h_next - next sequence
# ------------------------------
sub h_next {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->h_next(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $seq = CvSeq_h_next($av{-seq})) {
		bless $seq, blessed $av{-seq};
	} else {
		undef;
	}
}


# ------------------------------
#  h_prev - previous sequence
# ------------------------------
sub h_prev {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->h_prev(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $seq = CvSeq_h_prev($av{-seq})) {
		bless $seq, blessed $av{-seq};
	} else {
		undef;
	}
}


# ------------------------------
#  v_next - 2nd next sequence
# ------------------------------
sub v_next {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->v_next(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $seq = CvSeq_v_next($av{-seq})) {
		bless $seq, blessed $av{-seq};
	} else {
		undef;
	}
}


# ------------------------------
#  v_prev - 2nd previous sequence
# ------------------------------
sub v_prev {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->v_prev(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $seq = CvSeq_v_prev($av{-seq})) {
		bless $seq, blessed $av{-seq};
	} else {
		undef;
	}
}


# ------------------------------
#  total - number of elements
# ------------------------------
sub total {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->total(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	CvSeq_total($av{-seq});
}


# ------------------------------
#  elem_size - size of sequence element in bytes
# ------------------------------
sub elem_size {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->elem_size(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	CvSeq_elem_size($av{-seq});
}


# ------------------------------------------------------------
#  CreateSeq - Creates sequence
# ------------------------------------------------------------
sub new {
    my $class = shift;
	my %av = &argv([ -seq_flags => undef,
					 -header_size => 0,
					 -elem_size => 0,
					 -storage => undef,
				   ], @_);
	$av{-seq_flags} ||= $av{-flags};
	unless (defined $av{-seq_flags} &&
			$av{-header_size} > 0 &&
			$av{-elem_size} > 0 &&
			blessed $av{-storage}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->new(
	-seq_flags => Flags of the created sequence. If the sequence is not
	        passed to any function working with a specific type of
	        sequences, the sequence value may be set to 0, otherwise the
	        appropriate type must be selected from the list of predefined
	        sequence types. 
	-header_size => Size of the sequence header; must be greater or equal
	        to sizeof(CvSeq). If a specific type or its extension is
	        indicated, this type must fit the base type header. 
	-elem_size => Size of the sequence elements in bytes. The size must be
	        consistent with the sequence type. For example, for a sequence
	        of points to be created, the element type CV_SEQ_ELTYPE_POINT
	        should be specified and the parameter elem_size must be equal to
	        sizeof(CvPoint). 
	-storage => Sequence location.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	bless cvCreateSeq(
		$av{-seq_flags},
		$av{-header_size},
		$av{-elem_size},
		$av{-storage},
		), $class;
}

sub DESTROY {
}


# ------------------------------------------------------------
#  SetSeqBlockSize - Sets up sequence block size
# ------------------------------------------------------------


# ------------------------------------------------------------
#  SeqPush - Adds element to sequence end
# ------------------------------------------------------------
sub Push {
	my $self = shift;
	my %av = &argv([ -element => undef,
					 -seq => $self,
				   ], @_);
	unless (defined $av{-element} &&
			blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->Push(
	-element => Added element. (packed)
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSeqPush($av{-seq}, $av{-element});
}


# ------------------------------------------------------------
#  SeqPop - Removes element from sequence end
# ------------------------------------------------------------
sub Pop {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->Pop(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSeqPop($av{-seq});
}


# ------------------------------------------------------------
#  SeqPushFront - Adds element to sequence beginning
# ------------------------------------------------------------
sub Unshift {
	my $self = shift;
	my %av = &argv([ -element => undef,
					 -seq => $self,
				   ], @_);
	unless (defined $av{-element} &&
			blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->Unshift(
	-element => Added element. (packed)
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSeqPushFront($av{-seq}, $av{-element});
}

# ------------------------------------------------------------
#  SeqPopFront - Removes element from sequence beginning
# ------------------------------------------------------------
sub Shift {
	my $self = shift;
	my %av = &argv([ -seq => $self,
				   ], @_);
	unless (blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->Shift(
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSeqPopFront($av{-seq});
}

# ------------------------------------------------------------
#  SeqPushMulti - Pushes several elements to the either end of sequence
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SeqPopMulti - Removes several elements from the either end of sequence
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SeqInsert - Inserts element in sequence middle
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SeqRemove - Removes element from sequence middle
# ------------------------------------------------------------
sub SeqRemove {
	my $self = shift;
	my %av = &argv([ -index => 0,
					 -seq => $self,
				   ], @_);
	unless (defined $av{-index} &&
			blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->SeqRemove(
	-index => Index of element.
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSeqRemove(
		$av{-seq},
		$av{-index},
		);
}


# ------------------------------------------------------------
#  ClearSeq - Clears sequence
# ------------------------------------------------------------

# ------------------------------------------------------------
#  GetSeqElem - Returns pointer to sequence element by its index
# ------------------------------------------------------------
sub GetSeqElem {
	my $self = shift;
	my %av = &argv([ -index => 0,
					 -seq => $self,
				   ], @_);
	unless (defined $av{-index} &&
			blessed $av{-seq}) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->GetSeqElem(
	-index => Index of element.
	-seq => Sequence.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetSeqElem(
		$av{-seq},
		$av{-index},
		);
}


# ------------------------------------------------------------
#  SeqElemIdx - Returns index of concrete sequence element
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CvtSeqToArray - Copies sequence to one continuous block of memory
# ------------------------------------------------------------
sub CvtSeqToArray {
	my $self = shift;
	my %av = &argv([ -elements => [ ],
					 -slice => &CV_WHOLE_SEQ,
					 -seq => $self,
				   ], @_);
	unless (ref $av{-elements} eq 'ARRAY' &&
			defined($av{-slice}) &&
			blessed($av{-seq})) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->CvtSeqToArray(
	-seq => Sequence.
	-elements => Pointer to the destination array that must be large enough.
	        It should be a pointer to data, not a matrix header. 
	-slice => The sequence part to copy to the array.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCvtSeqToArray(
		$av{-seq},
		$av{-elements},
		pack("i2", cvSlice($av{-slice})),
		);
	$av{-elements};
}

# ------------------------------------------------------------
#  MakeSeqHeaderForArray - Constructs sequence from array
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SeqSlice - Makes separate header for the sequence slice
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CloneSeq - Creates a copy of sequence
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SeqRemoveSlice - Removes sequence slice
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SeqInsertSlice - Inserts array in the middle of sequence
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SeqInvert - Reverses the order of sequence elements
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SeqSort - Sorts sequence element using the specified comparison function
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SeqSearch - Searches element in sequence
# ------------------------------------------------------------

# ------------------------------------------------------------
#  StartAppendToSeq - Initializes process of writing data to sequence
# ------------------------------------------------------------

# ------------------------------------------------------------
#  StartWriteSeq - Creates new sequence and initializes writer for it
# ------------------------------------------------------------

# ------------------------------------------------------------
#  EndWriteSeq - Finishes process of writing sequence
# ------------------------------------------------------------

# ------------------------------------------------------------
#  FlushSeqWriter - Updates sequence headers from the writer state
# ------------------------------------------------------------

# ------------------------------------------------------------
#  StartReadSeq - Initializes process of sequential reading from sequence
# ------------------------------------------------------------
sub StartReadSeq {
	my $self = shift;
	Cv::Seq::Reader->new(-seq => $self, @_);
}

# ------------------------------------------------------------
#  GetSeqReaderPos - Returns the current reader position
# ------------------------------------------------------------

# ------------------------------------------------------------
#  SetSeqReaderPos - Moves the reader to specified position
# ------------------------------------------------------------

# ######################################################################
#  2. Structural Analysis
# ######################################################################

# ======================================================================
#  2.1. Contour Processing Functions
# ======================================================================

# ------------------------------------------------------------
#  ApproxChains - Approximates Freeman chain(s) with polygonal curve
# ------------------------------------------------------------
sub ApproxChains {
	my $self = shift;
	my %av = argv([ -src_seq => undef,
					-storage => undef,
					-method => &CV_CHAIN_APPROX_SIMPLE,
					-parameter => 0,
					-minimal_perimeter => 0,
					-recursive => 0,
				  ], @_);
	bless cvApproxChains(
		$av{-src_seq},
		$av{-storage},
		$av{-method},
		$av{-parameter},
		$av{-minimal_perimeter},
		$av{-recursive},
		), blessed $self || $self;
}


# ------------------------------------------------------------
#  StartReadChainPoints - Initializes chain reader
# ------------------------------------------------------------
sub StartReadChainPoints { croak "### TBD ###"; }

# ------------------------------------------------------------
#  ReadChainPoint - Gets next chain point
# ------------------------------------------------------------
sub ReadChainPoint { croak "### TBD ###"; }

# ------------------------------------------------------------
#  ApproxPoly - Approximates polygonal curve(s) with desired precision
# ------------------------------------------------------------
sub ApproxPoly {
	my $self = shift;
	my %av = argv([	-method => &CV_POLY_APPROX_DP,
					-parameter => undef,
					-parameter2 => 0,
					-src_seq => $self,
					-header_size => undef,
					-storage => undef,
				  ], @_);
	unless (blessed($av{-src_seq})) {
		chop(my $usage = <<"----"
usage:	Cv::Seq->ApproxPoly(
	-src_seq => Sequence of array of points. 
	-header_size => Header size of approximated curve[s]. 
	-storage => Container for approximated contours. If it is NULL, the
	        input sequences\' storage is used. 
	-method => Approximation method; only CV_POLY_APPROX_DP is supported,
	        that corresponds to Douglas-Peucker algorithm. 
	-parameter => Method-specific parameter; in case of CV_POLY_APPROX_DP it
	        is a desired approximation accuracy. 
	-parameter2 => If case if src_seq is sequence it means whether the
	        single sequence should be approximated or all sequences on the
	        same level or below src_seq (see cvFindContours for description
	        of hierarchical contour structures). And if src_seq is array
	        (CvMat*) of points, the parameter specifies whether the curve is
	        closed (parameter2!=0) or not (parameter2=0). 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$av{-header_size} ||= $av{-src_seq}->header_size,
	bless cvApproxPoly(
		$av{-src_seq},
		$av{-header_size},
		$av{-storage} || \0,
		$av{-method},
		$av{-parameter},
		$av{-parameter2},
		), blessed $self || $self;
}


# ------------------------------------------------------------
#  BoundingRect - Calculates up-right bounding rectangle of point set
#  ContourArea - Calculates area of the whole contour or contour section
#  ArcLength - Calculates contour perimeter or curve length
#  (Cv::Mat)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CreateContourTree - Creates hierarchical representation of contour
# ------------------------------------------------------------
sub CreateContourTree { croak "### TBD ###"; }

# ------------------------------------------------------------
#  ContourFromContourTree - Restores contour from tree
# ------------------------------------------------------------
sub ContourFromContourTree { croak "### TBD ###"; }

# ------------------------------------------------------------
#  MatchContourTrees - Compares two contours using their tree representations
# ------------------------------------------------------------
sub MatchContourTrees { croak "### TBD ###"; }


# ======================================================================
#  2.2. Computational Geometry
# ======================================================================

# ------------------------------------------------------------
#  MaxRect - Finds bounding rectangle for two given rectangles
#  CvBox2D - Rotated 2D box
#  (Cv::CxCore)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  PointSeqFromMat - Initializes point sequence header from a point vector
#  BoxPoints - Finds box vertices
#  FitEllipse - Fits ellipse to set of 2D points
#  FitLine - Fits line to 2D or 3D point set
#  ConvexHull2 - Finds convex hull of point set
#  CheckContourConvexity - Tests contour convex
#  ConvexityDefects - Finds convexity defects of contour
#  PointPolygonTest - Point in contour test
#  MinAreaRect2 - Finds circumscribed rectangle of minimal area for
#                 given 2D point set
#  MinEnclosingCircle - Finds circumscribed circle of minimal area for
#                       given 2D point set
#  CalcPGH - Calculates pair-wise geometrical histogram for contour
#  (Cv::Mat)
# ------------------------------------------------------------


1;
