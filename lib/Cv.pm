# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv;

use 5.008008;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);

our $VERSION = '0.10';

require XSLoader;
XSLoader::load('Cv', $VERSION);

sub assoc {
	my $family = shift;
	my $short = shift;
	my @names;
	if ($short =~ /^[a-z]/) {
		(my $caps = $short) =~ s/^[a-z]/\U$&/;
		(my $upper = $short) =~ s/^[a-z]+/\U$&/;
		@names = ($caps, "cv$caps", $upper, "cv$upper");
	} else {
		@names = ("cv$short");
	}
	foreach (@names) {
		return join('::', $family, $_) if $family->can($_);
	}
	return undef;
}

sub alias {
	my $family = shift;
	my $real = shift;
	return unless my $alias = shift;
	my %subr = ();
	if ($alias ne $real) {
		$subr{$alias} = $real;
	}
	if ($alias =~ s/^[A-Z][a-z]+/\L$&/) {
		$subr{$alias} = $real;
	} elsif ($alias =~ s/^[A-Z]+$/\L$&/) {
		$subr{$alias} = $real;
	}
	foreach (sort { lc $a cmp lc $b } keys %subr) {
		next if $family->can($_);
		my $defn = join('::', $family, $_);
		my $subr = $subr{$_} =~ /::/ ?
			$subr{$_} : join('::', $family, $subr{$_});
		no warnings;
		no strict 'refs';
		*$defn = \&$subr;
	}
}

sub aliases {
	my ($family) = caller(0);
	for (@_) {
		my $real = shift(@$_);
		my $assoc = $real;
		$assoc =~ s/.*:://;
		$assoc =~ s/^cv//;
		unshift(@$_, $assoc) if $assoc;
		alias($family, $real, $_) for @$_;
	}
}

use Cv::Constant;
use Cv::BGCodeBookModel;
use Cv::Capture;
use Cv::Contour;
use Cv::ConvKernel;
use Cv::FileStorage;
use Cv::Flipbook;
use Cv::Font;
use Cv::Histogram;
use Cv::Image;
use Cv::Kalman;
use Cv::Mat;
use Cv::MatND;
use Cv::MemStorage;
use Cv::Moments;
use Cv::RNG;
use Cv::Seq;
use Cv::SeqReader;
use Cv::SparseMat;
use Cv::StereoBMState;
use Cv::String;
use Cv::Subdiv2D;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
	'all' => [
		(map { @{ $Cv::Constant::EXPORT_TAGS{$_} } }
		 grep { $_ <= cvVersion() } keys %Cv::Constant::EXPORT_TAGS),

		qw(

CV_PI
CV_RGB
CV_WHOLE_SEQ
cvMSERParams
cvPoint
cvPoint2D32f
cvPoint2D64f
cvPoint3D32f
cvPoint3D64f
cvRealScalar
cvRect
cvRound
cvSURFParams
cvScalar
cvScalarAll
cvSize
cvSize2D32f
cvTermCriteria
cvVersion

)]);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

sub AUTOLOAD {
    our $AUTOLOAD;
    (my $short = $AUTOLOAD) =~ s/.*:://;
	if (my $real = assoc(__PACKAGE__, $short)) {
		no strict "refs";
		if ($real =~ /::cv/) {
			*$AUTOLOAD = sub {
				shift unless defined $_[0] && ref $_[0] && blessed $_[0];
				goto &$real;
			};
		} else {
			*$AUTOLOAD = \&$real;
		}
		# print STDERR "AUTOLOAD: $AUTOLOAD = $real\n";
		goto &$AUTOLOAD;
	}
    croak "&Cv::constant not defined" if $short eq 'constant';
    my ($error, $val) = constant($short);
    if ($error) { croak $error; }
    {
		no strict 'refs';
	    *$AUTOLOAD = sub { $val };
    }
    goto &$AUTOLOAD;
}

# Preloaded methods go here.

sub HasGUI {
	return 0 unless defined $ENV{DISPLAY};
	if ($^O eq 'cygwin') {
		1;
	} else {
		if (fork) {
			wait;
			$? == 0;
		} else {
			open(STDERR, ">/dev/null");
			cvNamedWindow('Cv');
			cvDestroyWindow('Cv');
			exit(0);
		}
	}
}

sub HasQt {
	Cv->can('cvFontQt');
}

sub FitEllipse {
	my $class = shift;
	if (ref $_[0] eq 'ARRAY') {
		my $stor = Cv::MemStorage->new;
		my $points = Cv::Seq::Point->new(&CV_32SC2, $stor);
		$points->Push(@_ > 1 ? @_ : @{$_[0]});
		$points->FitEllipse;
	} elsif (blessed $_[0] && $_[0]->isa('Cv::Arr')) {
		(bless \@_, 'Cv::Arr')->FitEllipse;
	} else {
		croak "usage: FitEllipse([src0, src1, ...])"
	}
}

sub Merge {
	my $class = shift;
	if (ref $_[0] eq 'ARRAY') {
		(bless $_[0], 'Cv::Arr')->Merge(@_[1 .. $#_]);
	} elsif (blessed $_[0] && $_[0]->isa('Cv::Arr')) {
		(bless \@_, 'Cv::Arr')->Merge;
	} else {
		croak "usage: Merge([src0, src1, ...], dst)"
	}
}

sub MinAreaRect {
	my $class = shift;
	my $stor = pop if blessed $_[-1] && $_[-1]->isa('Cv::MemStorage');
	$stor ||= Cv::MemStorage->new;
	my $points = Cv::Seq::Point->new(&CV_32SC2, $stor);
	$points->Push(@_ > 1 ? @_ : @{$_[0]});
	$points->minAreaRect($stor);
}

sub MinEnclosingCircle {
	my $class = shift;
	my $stor = Cv::MemStorage->new;
	my $points = Cv::Seq::Point->new(&CV_32SC2, $stor);
	$points->Push(@_ > 1 ? @_ : @{$_[0]});
	$points->minEnclosingCircle(my $center, my $radius);
	wantarray? ($center, $radius) : [$center, $radius];
}

sub CaptureFromFlipbook {
	my $class = shift;
	Cv::Flipbook->new(@_);
}

1;
__END__

=head1 NAME

Cv - helps you to make something around computer vision.

=head1 SYNOPSIS

 use Cv;
 my $image = Cv->LoadImage("/path/to/image", CV_LOAD_IMAGE_COLOR);
 $image->ShowImage("image");
 Cv->WaitKey;


=head1 DESCRIPTION

C<Cv> is the Perl interface to the OpenCV computer vision library that
originally developed by Intel. I'm making this module to use the
computer vision more easily like a slogan of perl I<"Easy things
should be easy, hard things should be possible.">

The features are as follows.

=over 4

=item *

C<Cv> was made along the online reference manual of C in the OpenCV
documentation.  For details, please refer to the
http://opencv.willowgarage.com/.

=item *

You can use C<CreateSomething()> as a constructors.

 my $img = Cv->CreateImage([ 320, 240 ], IPL_DEPTH_8U, 3);
 my $mat = Cv->CreateMat([ 240, 320 ], CV_8UC3);

=item *

You can also use C<new> as a constructor. But be careful when you use
it because the arguments are same as CreateMat().

 my $img = Cv::Image->new([ 240, 320 ], CV_8UC3);
 my $img2 = $img->new;

=item *

The OpenCV has a type C<IplImage*> for handling an image object, and
types C<CvMat*>, C<CvMatND*> and C<CvSparseMat*> for a matrix object.
These types are mapped as blessed reference of C<Cv::Image>,
C<Cv::Mat>, C<Cv::MatND> and C<Cv::SparseMat>.  The type of structures
like C<CvSize> and C<CvPoint> are mapped as an array.  For details,
please refer to the typemap.

=item *

You have to call cvReleaseImage() when you'll destroy the image object
in the OpenCV application programs.  But in the C<Cv>, you don't have
to call cvReleaseImage() because Perl calls C<DESTROY> for cleanup.
So the subroutine C<DESTROY> has often been defined as an alias of
cvReleaseImage(), cvReleaseMat(), ... and cvReleaseSomething().

Some functions, eg. cvQueryFrame() return a reference but that cannot
be destroyed. In this case, the reference is blessed with
C<Cv::Somthing::Ghost>, and identified. And disable destroying.

=item *

You can use name of method, omitting "cv" from the OpenCV function
name, and also use lowercase name beginning. For example, you can call
C<cvCreateMat()> as:

 my $mat = Cv->CreateMat(240, 320, CV_8UC3);
 my $mat = Cv->createMat(240, 320, CV_8UC3);


=item *

When you omit the destination image or matrix (often named "dst"),
C<Cv> creates new destination if possible.

 my $dst = $src->Add($src2);

=item *

Some functions in the OpenCV can handle inplace that use source image
as destination one.  To tell requesting inplace, you can use C<\0> as
C<NULL> for the destination.

 my $dst = $src->Flip(\0);

=item *

cvAddS() and cvAdd() are integrated into Add().  Because we can
identify them.

 my $dst = $src->Add($src2);        # calling cvAdd()
 my $dst = $src->Add([ 1, 2, 3 ]);  # cvAddS()

C<cvGet1D()> and C<cvGet2D()> are integrated.

 my $val = $src->Get($idx1);        # calling cvGet1D()
 my $val = $src->Get($idx1, $idx2); # cvGet2D()

=item *

cvFillConvexPoly() handles the array of points C<CvPoint>.  The
function also needs the number of elements separately.  Because the
array of the language C is only a pointer to the beginning of it.  In
the Perl, the array unlike in C, we can know the number of elements.
So, you don't need to pass the number of elements for
cvFindCornerSubPix(), cvCreateMatND() and so, too.


=item *

cvMinMaxLoc() stores values in given variables.

 $src->MinMaxLoc(my $min, my $max);

In the Perl, you would think that even when multiple values returned
to the caller might be more natural to use the return value like
C<localtime> and C<stat>.  But we chose to along the OpenCV
documentation.

=item *

We have a configuration to use C<Inline C>.  This makes it easy to
test and extend a variety. How easy is as follows.

 use Cv::Config;
 use Inline C => Config => %Cv::Config::C;

=back


=head1 SAMPLES

We rewrite some OpenCV samples in C<Cv>, and put them in sample/.

 gfg_codebook.pl calibration.pl camshiftdemo.pl capture.pl contours.pl
 convexhull.pl delaunay.pl demhist.pl dft.pl distrans.pl drawing.pl
 edge.pl facedetect.pl fback_c.pl ffilldemo.pl find_obj.pl
 fitellipse.pl houghlines.pl image.pl inpaint.pl kalman.pl kmeans.pl
 laplace.pl lkdemo.pl minarea.pl morphology.pl motempl.pl
 mser_sample.pl polar_transforms.pl pyramid_segmentation.pl squares.pl
 stereo_calib.pl tiehash.pl watershed.pl

=head1 BUGS

=over 4

=item *

If you want to use new features of the OpenCV longer continue to
progress, please add them to the xs.  If you can place xs code in the
package C<Cv> or C<Cv::Arr>, you don't need to consider about
adjusting the names, e.g. omitting "cv", lowercase name beginning,
because C<AUTOLOAD> works in these packages.  In other places, you can
use C<Cv::aliases>.

=item *

If you want to use new constants, you can put it package
C<Cv::Constant>.

=item *

In the version 0.07, we decided to remove keyword parameter.  Because
of that has large overhead. In this version, we decided to remove
C<Cv::TieHash> and C<Cv::TieArr>, too.  See C<sample/tiehash.pl>.

=item *

On cygwin, it is necessary to compile OpenCV. 

=back

=head1 SEE ALSO

http://sourceforge.net/projects/opencvlibrary/

=head1 AUTHOR

Yuta Masuda, E<lt>yuta.masuda@newdaysys.co.jpE<gt>

=head1 LICENCE

Copyright (c) 2010, 2011 by Masuda Yuta.

All rights reserved. This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut
