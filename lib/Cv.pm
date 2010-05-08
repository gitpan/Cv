# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

# ######################################################################
#
#      @@@@@  @@   @@
#     @        @   @
#     @        @   @
#     @         @ @
#      @@@@@     @
#
# ######################################################################

=head1 NAME

Cv - helps you to make something around computer vision.

=head1 SYNOPSIS

 use Cv;
 
 my $image = Cv->LoadImage("/path/to/image", CV_LOAD_IMAGE_COLOR);
 $image->ShowImage("image");
 Cv->WaitKey;


=head1 DESCRIPTION

C<Cv> is a Perl interface to OpenCV computer vision library that
originally developed by Intel. I am making this module, to use the
computer vision more easily like a slogan of perl I<"Easy things should
be easy, hard things should be possible.">

C<Cv> is developing as follows. I am not coming satisfactorily. I am
learning Perl and OpenCV. I hope to grow it to an interesting module.

=over 4

=item *

The memory is deallocated by destroying the object. 

=item *

The function name is usually formed by omitting cv prefix.

=item * 

The argument of the function is a named argument that is always
preceded by a hyphen.  Please see an OpenCV reference manual
http://opencv.willowgarage.com/documentation/ about a name of an
argument.

=item *

You can also use positional arguments, but you can be confused because
different from prototype of C in order of arguments.

 # C prototype
 IplImage* cvLoadImage(const char* filename, int iscolor=CV_LOAD_IMAGE_COLOR)

 # Named argument
 my $image = Cv->LoadImage(-filename => $filename,
                           -iscolor => CV_LOAD_IMAGE_COLOR);

 # Optional arguments enable you to omit arguments for some parameters.
 my $image = Cv->LoadImage(-filename => $filename);

 # Positional arguments
 my $image = Cv->LoadImage($filename, CV_LOAD_IMAGE_COLOR);

=back


=head1 SAMPLES

The following samples demonstrates how to use C<Cv>.

=head2 Images and Arrays

Functions of accessing elements and sub-arrays. And C<IplImage>
processing.

=over 4

=item * 

Most functions return C<-dst> that is the object.  Excludes the return
value is used, like a C<GetD>, etc.

=item * 

The object is created with the same attribute of C<-src> if you don't
specify C<-dst>.

=back

 my $image = Cv->LoadImage("/path/to/image", CV_LOAD_IMAGE_COLOR);
 $image->SetImageROI([0, 0, $image->width/2, $image->width/2]);
 my $gray = $image->CvtColor(CV_RGB2GRAY);
 $image->ResetImageROI;
 $gray->ShowImage("gray");
 Cv->WaitKey;

The next function is usable.

 AbsDiff AbsDiffS Acc AdaptiveThreshold Add AddS AddWeighted Affine And
 AndS BoxPoints CalcGlobalOrientation CalcMotionGradient
 CalcOpticalFlowPyrLK CalibrateCamera2 Calibration CamShift Canny Ceil
 Circle Cmp CmpS ComputeCorrespondEpilines Convert ConvertScale
 ConvertScaleAbs Copy CopyMakeBorder CrossProduct CvConnectedComp
 CvtColor CvtScale CvtScaleAbs DFT Dilate DistTransform Div
 DrawChessboardCorners Ellipse EllipseBox EndFindContours EqualizeHist
 Erode Error Exp ExtractSURF FillConvexPoly FillPoly Filter2D
 FindChessboardCorners FindContours FindCornerSubPix
 FindExtrinsicCameraParams2 FindFundamentalMat FindNextContour
 FitEllipse FitLine Flip FloodFill Floor GEMM Get1D Get2D Get3D GetCol
 GetCols GetD GetDimSize GetDims GetElemType GetOptimalDFTSize
 GetReal1D GetReal2D GetReal3D GetRealD GetRectSubPix GetRow GetRows
 GetSize GetSubRect GoodFeaturesToTrack HaarDetectObjects HoughCircles
 HoughLines2 InRange InRangeS InitUndistortMap InitUndistortRectifyMap
 Inpaint Integral Invert KMeans2 LUT Laplace Line Load LoadCascade Log
 MatMul MatMulAdd MatchTemplate Max MaxRect MaxS Merge Min MinAreaRect2
 MinMaxLoc MinS Moments MorphologyEx Mul Norm Normalize Not Or OrS
 PolyLine Pow PutText PyrDown PyrMeanShiftFiltering PyrUp Rectangle
 Reduce Remap Resize Round RunningAvg SURFParams Scale ScaleAdd Set
 Set1D Set2D Set3D SetD SetIdentity SetReal1D SetReal2D SetReal3D
 SetRealD SetZero ShowImage Smooth Sobel Split StartFindContours
 StereoCalibrate StereoRectify StereoRectifyUncalibrated Sub SubRS SubS
 SubstituteContour Threshold Undistort2 UndistortPoints
 UpdateMotionHistory Watershed Xor XorS Zero height show width

=head2 GUI

Basic GUI functions (Window, Trackbar, Mouse).

 my $img = Cv->CreateImage([320, 240], 8, 3)->Zero;
 my $win = Cv->NamedWindow("Window");
 
 my $value = 0;
 $win->CreateTrackbar(
     -trackbar_name => "value",
     -value => \$value,
     -count => 100,
     -on_change => \&on_change,
     );

 $win->SetMouseCallback(-callback => \&on_mouse, -param => 123);
 
 $win->ShowImage($img);
 $img->WaitKey;
 
 sub on_change {
     print "[on_change]: value = $value\n";
 }

 sub on_mouse {
     print "[on_mouse]: event = $_[0], x = $_[1], y = $_[2], flags = $_[3], param = $_[4]\n";
 }

Text rendering functions.

 my $image = Cv->CreateImage(-size => [ 320, 240 ], -depth => 8, -channels => 3);
 $image->Set(-value => [ 0, 0, 0 ]);
 my $text = "Hello, OpenCV";
 my $font = Cv->InitFont(
     -font_face => CV_FONT_HERSHEY_COMPLEX,
     -hscale    => 0.5,
     -vscale    => 0.5,
     -shear     => 0,
     -thickness => 1,
     -line_type => 16,
     );
 $font->PutText(-img => $image, -text => $text, -org => [100, 100]);

=head2 Matrix and Sequence

The following sample is minaria.c attached to OpenCV samples.  This
sample displays a minimum rectangle and a minimum circle that encloses
all the points.

 my $ARRAY = 1;                    # 1: Cv:Mat, 0: Cv::Seq
 
 my $win = Cv->NamedWindow(-name => "rect & circle", -flags => 1);
 my $img = Cv->new(-size => [ 500, 500 ], -depth => 8, -channels => 3);
 my $mem = Cv->CreateMemStorage;
 
 while (1) {
     my $p = undef;
     my $count = rand(100) + 1;
 
     if ($ARRAY) {
         $p = Cv->CreateMat(
             -rows => 1,
             -cols => $count,
             -type => CV_32SC2,    # as cvPoint
             );
     } else {
         use Cv::Seq::Point;
         $p = Cv::Seq::Point->new(
             -seq_flags => CV_SEQ_KIND_GENERIC | CV_32SC2,
             -storage => $mem,
             );
     }
 
     foreach (0 .. $count - 1) {
         my $pt = cvPoint(
             -x => rand($img->width/2)  + $img->width/4,
             -y => rand($img->height/2) + $img->height/4,
             );
         if ($ARRAY) {
             $p->SetD(-idx => $_, -value => $pt);
         } else {
             $p->Push(-element => $pt);
         }
     }
 
     $img->Zero;
     foreach (0 .. $count - 1) {
         my $pt;
         if ($ARRAY) {
             $pt = $p->GetD(-idx => $_);
         } else {
             $pt = $p->GetSeqElem(-index => $_);
         }
         $img->Circle(
             -center => $pt,
             -radius => 2,
             -color => CV_RGB(255, 0, 0),
             -thickness => CV_FILLED,
             -line_type => CV_AA,
             -shift => 0,
             );
     }
 
     my @b = Cv->BoxPoints(-box => $p->MinAreaRect2());
     foreach ([ $b[0], $b[1] ], [ $b[1], $b[2] ],
              [ $b[2], $b[3] ], [ $b[3], $b[0] ]) {
         $img->Line(
             -pt1 => $_->[0],
             -pt2 => $_->[1],
             -color => CV_RGB(0, 255, 0),
             -thickness => 1,
             -line_type => CV_AA,
             -shift => 0,
             );
     }
 
     $img->Circle(
         -circle => $p->MinEnclosingCircle(),
         -color => CV_RGB(255, 255, 0),
         -thickness => 1,
         -line_type => CV_AA,
         -shift => 0,
         );
 
     $win->ShowImage(-image => $img);
     my $key = $win->WaitKey;
     $key &= 0x7f if $key >= 0;
     last if $key == 27 || $key == ord('q') || $key == ord('Q'); # 'ESC'
 }

=head2 Capture

The following sample capture and displays the image from camera.

 my $capture = Cv->CreateCameraCapture(0);
 die "can't create capture" unless $capture;

 while (my $frame = $capture->QueryFrame) {
     $frame->ShowImage;
     Cv->WaitKey(33);
 }

=head2 Histograms

The following sample displays the histogram of each RGB of three
channel color image.

 my @planes = map { Cv->new(scalar $img->GetSize, $img->depth, 1) } (0..2);
 $img->Split(-dst => \@planes);
 
 my @hists = map {
     Cv->CreateHist(-sizes => [256], -type => CV_HIST_ARRAY)
         ->Calc(-images => [$_])
     } @planes;
 
 my ($width, $height) = (256, 200);
 my @himages = map { Cv->new([$width, $height], 8, 3)->Zero->Not } (0..2);
 my @mm = map { $_->GetMinMaxHistValue } @hists;
 
 map {
     $hists[$_]->ScaleHist(-scale => $height/$mm[$_]->{max}{val})
         if $mm[$_]->{max}{val};
 } (0..2);
 
 my $bin = Cv->Round($width/256);
 for my $i (0..255) {
     my ($x, $y) = ($i*$bin, $height);
     my $pt1 = [$x, $y];
     my @pt2 = map { [$x+$bin, $y - $hists[$_]->QueryHistValue([$i])] } (0..2);
     $himages[0]->Rectangle($pt1, $pt2[0], [$i, 0, 0] );
     $himages[1]->Rectangle($pt1, $pt2[1], [0, $i, 0] );
     $himages[2]->Rectangle($pt1, $pt2[2], [0, 0, $i] );
 }
 
 $dst = Cv->new([$width, $height*3], 8, 3);
 for (0..2) {
     my $roi = [0, $height*$_, $width, $height];
     $himages[$_]->Copy($dst->SetImageROI($roi));
 }
 $dst->ResetImageROI;
 $dst->ShowImage('Histogram');
 $img->ShowImage('Image');
 Cv->WaitKey(1000);

The next function is usable. 

 CalcBackProject CalcBackProjectPatch CalcHist CalcPGH ClearHist
 CompareHist CopyHist GetMinMaxHistValue NormalizeHist QueryHistValue
 ReleaseHist ScaleHist ThreshHist

=head2 FileStorage

The following samples are examples that save data by cvWrite.

 my $filename = "/path/to/file";
 my $fs = Cv->OpenFileStorage(-filename => $filename,
                              -flags => CV_STORAGE_WRITE);
 my $mat = Cv->CreateMat(3, 3, CV_32F);
 $mat->SetIdentity;
 $fs->Write("MAT", $mat);

The following samples are examples that save data by cvWrite.

 my $fs = Cv->OpenFileStorage(-filename => $filename,
                              -flags => CV_STORAGE_READ);
 my $param = $fs->GetFileNodeByName("MAT");
 my $ = $fs->Read($param);

Sorry. Only the following function can be used still. 

 Write Read GetFileNodeByName

=head2 Contour

The following sample finds the contours, and  does highlight display.

 my $storage = Cv->CreateMemStorage;
 my $gray = $image->CvtColor(CV_RGB2GRAY);
 my $canny = $gray->PyrDown->PyrUp->Canny(-dst => $gray->new);
 for (my $contour = $canny->FindContours(-storage => $storage);
      $contour; $contour = $contour->h_next) {
   $contour->Draw(-image => $image, -max_level => 0, -thickness => 3,
                  -external_color => [ rand(255), rand(255), rand(255) ],
                  -hole_color => CV_RGB(255, 255, 255));
   $image->ShowImage("contour");
   last if Cv->WaitKey(100) >= 0;
 }


=head2 RNG

The following sample sets and displays a random value to all pixels. 

 my $rng = Cv->RNG(-1);
 my $img = Cv->CreateImage([ 320, 240 ], IPL_DEPTH_8U, 3);
 for (0..10) {
     $rng->RandArr(
         -arr => $img,
         -dist_type => CV_RAND_NORMAL,
         -param1 => scalar cvScalarAll(0),
         -param2 => scalar cvScalarAll(255),
     );
     $img->NamedWindow->ShowImage;
     Cv->WaitKey(100);
 }

Random number generator. 

=head2 Experimental

The following are experimental. See sample code, please.

=over 4

=item * Hough

HoughCircles, HoughLines, HoughLines2

=item * Moments

Accessing Moments and HuMoments structure

=item * ConvKernel

create a structuring element in the morphological operations

=item * BGCodebook

The codebook background model

=item * HaarDetectObjects

Detects objects in the image

=item * StereoBMState

The structure for block matching stereo correspondence algorithm

=item * Kalman

Allocates Kalman filter structure

=item * MotionHistory

Segments whole motion into separate moving parts

=back

=head1 EXPORT

=over 4

=item Cv::Constant

CV_*, IPL_*

=item Cv::CxCore

cvBox, cvBox2D, cvBoxPoints, cvCeil, cvFloor, cvIndex, cvMaxRect,
cvPoint, cvRealScalar, cvRect, cvRound, cvScalar, cvScalarAll, cvSize,
cvSlice, cvTermCriteria, CV_RGB, CV_MAJOR_VERSION, CV_MINOR_VERSION,
CV_SUBMINOR_VERSION, CV_VERSION,

=back

=cut

package Cv;

use 5.008008;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);

use Cv::Constant;
use Cv::CxCore qw(:all);
use Cv::Image;

use Data::Dumper;

BEGIN {
	$Data::Dumper::Terse = 1;
}

require Exporter;
our @ISA = qw(Exporter Cv::Image);

our @EXPORT = (
	@Cv::Constant::EXPORT,
	@Cv::CxCore::EXPORT,
	);

our %EXPORT_TAGS = (
	'all' => [
		@{$Cv::Constant::EXPORT_TAGS{'all'}},
		@{$Cv::CxCore::EXPORT_TAGS{'all'}},
	],
	);

our @EXPORT_OK = (
	@{ $EXPORT_TAGS{'all'} },
	);

our $VERSION = '0.03';

# Preloaded methods go here.

# ------------------------------------------------------------
#  CreateImage - Creates an image header and allocates the image data.
#  (see Cv::Image)
# ------------------------------------------------------------
sub new {
	my $class = shift;
	$class->SUPER::new(@_);
}

# ------------------------------------------------------------
#  CreateMat - Creates new matrix
#  (see Cv::Mat)
# ------------------------------------------------------------
sub CreateMat {
	my $self = shift;
	use Cv::Mat;
	Cv::Mat->new(@_);
#	Cv::Mat->CreateMat(@_);
}

# ------------------------------------------------------------
#  CreateSeq - Creates sequence
#  (see Cv::Seq)
# ------------------------------------------------------------
sub CreateSeq {
	my $self = shift;
	use Cv::Seq;
	Cv::Seq->new(@_);
}

# ------------------------------------------------------------
#  CreateMemStorage - Creates memory storage
#  (see Cv::MemoryStorage)
# ------------------------------------------------------------
sub CreateMemStorage {
	my $self = shift;
	use Cv::MemStorage;
	Cv::MemStorage->new(@_);
}

# ------------------------------------------------------------
#  OpenFileStorage - Opens file storage for reading or writing data
#  (see Cv::FileStorage)
# ------------------------------------------------------------
sub OpenFileStorage {
	my $self = shift;
	use Cv::FileStorage;
	Cv::FileStorage->new(@_);
}

# ------------------------------------------------------------
#  CreateHist - Creates histogram
#  (see Cv::Hisutogram)
# ------------------------------------------------------------
sub CreateHist {
	my $self = shift;
	use Cv::Histogram;
	Cv::Histogram->new(@_);
}

# ------------------------------------------------------------
#  CreateStructuringElementEx - create a structuring element in the
#  morphological operations
#  (see Cv::ConvKernel)
#  ------------------------------------------------------------
sub CreateStructuringElementEx {
	my $self = shift;
	use Cv::ConvKernel;
	Cv::ConvKernel->new(@_);
}

# ------------------------------------------------------------
#  RNG - Initializes random number generator state
#  (see Cv::RNG)
# ------------------------------------------------------------
sub RNG {
	my $self = shift;
	use Cv::RNG;
	Cv::RNG->new(@_);
}

# ------------------------------------------------------------
#  InitFont - Initializes font structure
#  (see Cv::Text)
# ------------------------------------------------------------
sub InitFont {
	my $self = shift;
	use Cv::Text;
	Cv::Text->new(@_);
}

# ------------------------------------------------------------
#  cvCreateFileCapture - Initializes capturing video from file
#  cvCreateCameraCapture - Initializes capturing video from camera
#  (Cv::Capture)
# ------------------------------------------------------------
sub CreateFileCapture {
	my $self = shift;
	use Cv::Capture;
	Cv::Capture->CreateFileCapture(@_);
}

sub CreateCameraCapture {
    my $self = shift;
	use Cv::Capture;
	Cv::Capture->CreateCameraCapture(@_);
}

# ------------------------------------------------------------
#  cvCreateBGCodeBookModel - 
# ------------------------------------------------------------
sub CreateBGCodeBookModel {
    my $self = shift;
	use Cv::BGCodebook;
	Cv::BGCodebook->new(@_);
}

# ----------------------------------------------------------------------
#  CreateKalman - Allocates Kalman filter structure
# ----------------------------------------------------------------------
sub CreateKalman {
	my $self = shift;
	use Cv::Kalman;
	Cv::Kalman->new(@_);
}

# ------------------------------------------------------------
#  SegmentMotion - Segments whole motion into separate moving parts
# ------------------------------------------------------------
sub SegmentMotion {
	my $self = shift;
	use Cv::MotionHistory;
	Cv::MotionHistory->SegmentMotion(@_);
}

# ------------------------------------------------------------
#  CreateSubdivDelaunay2D - Creates empty Delaunay triangulation
# ------------------------------------------------------------
sub CreateSubdivDelaunay2D {
	my $self = shift;
	use Cv::Subdiv2D;
	Cv::Subdiv2D->CreateDelaunay(@_);
}


sub Subdiv2DEdge {
	my $self = shift;
	use Cv::Subdiv2D::Edge;
	Cv::Subdiv2D::Edge->new(@_);
}


# ------------------------------------------------------------
#  CreateStereoBMState - Creates block matching stereo correspondence
#          structure
# ------------------------------------------------------------
sub CreateStereoBMState {
	my $self = shift;
	use Cv::StereoBMState;
	Cv::StereoBMState->new(@_);
}


1;
__END__

=head1 BUGS

=over 4

=item *

All functions of OpenCV cannot be used. 

=item *

To use, Some functions need modules other than Cv, to use it.
(Ex. Cv::Seq::Point etc.)

=item *

I am still considering of interface of the arguments.  So, these might
be changed.

=item *

CvCopyHist of OpenCV2.0 cannot return a correct object. 

=back

=head1 SEE ALSO

http://sourceforge.net/projects/opencvlibrary/

=head1 AUTHOR

Yuta Masuda, E<lt>yuta.masuda@newdaysys.co.jpE<gt>

=head1 LICENCE

Copyright (c) 2010 by Masuda Yuta.

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut
