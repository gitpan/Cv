# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Image;
use lib qw(blib/lib blib/arch);

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

our @ISA = qw(Cv::Mat);

our $VERSION = '0.02';

# Preloaded methods go here.

# ######################################################################
# ### CxCORE ###########################################################
# ######################################################################

# ######################################################################
#  2. Operations on Arrays
# ######################################################################

# ======================================================================
#  2.1. Initialization
# ======================================================================

# ------------------------------------------------------------
#   CreateImage - Creates header and allocates data
# ------------------------------------------------------------
sub CreateImage {
	my $self = shift;
	my %av = &argv([ -size => undef,
					 -depth => undef,
					 -channels => undef,
					 -origin => &IPL_ORIGIN_TL,
				   ], @_);
	unless (defined $av{-size} &&
			defined $av{-depth} &&
			defined $av{-channels}) {
		chop(my $usage = <<"----"
usage:	Cv->CreateImage(
	-size => Image width and height,
	-depth => Bit depth of image elements,
	-channels => Number of channels per element(pixel),
	-origin => IPL_ORIGIN_TL or IPL_ORIGIN_BL (default: IPL_ORIGIN_TL)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $phys = cvCreateImage(
			pack("i2", cvSize($av{-size})),
			$av{-depth},
			$av{-channels})) {
		my $image = bless $phys;
		$Cv::Arr::IMAGES{$image} = { };
		$image->SetOrigin(-origin => $av{-origin});
	} else {
		undef;
	}
}


sub new {
	my $self = shift;
	my %av = &argv([ -size => undef,
					 -depth => undef,
					 -channels => undef,
					 -origin => undef,
					 -image => $self,
				   ], @_);
	if (blessed($av{-image})) {
		$av{-size}     ||= scalar $av{-image}->GetSize;
		$av{-depth}    ||= $av{-image}->GetDepth;
		$av{-channels} ||= $av{-image}->GetChannels;
		$av{-origin}   ||= $av{-image}->GetOrigin;
	}
	$av{-image}->CreateImage(
		-size =>     $av{-size}     || [ 320, 240 ],
		-depth =>    $av{-depth}    || 8,
		-channels => $av{-channels} || 3,
		-origin =>   $av{-origin}   || 0,
		);
}

sub SetImageData {
	my $self = shift;
    my $data = shift;
    IplImage_set_imagedata($self, $data);
	$self;
}

sub GetImageData {
	my $self = shift;
    IplImage_get_imagedata($self);
}



#  GetDepth - Return pixel depth in bits
sub GetDepth {
    my $self = shift;
	IplImage_depth($self);
}

sub depth {
	my $self = shift;
	$self->GetDepth;
}


#  GetChannels - Return Number of channels per pixel
sub GetChannels {
    my $self = shift;
	IplImage_nChannels($self);
}

sub nChannels {
	my $self = shift;
	$self->GetChannels;
}

sub channels {
	my $self = shift;
	$self->GetChannels;
}


#  SetOrigin - set origin of the image, 0 - top-left, 1 - bottom-left
sub SetOrigin {
	my $self = shift;
	my %av = &argv([ -origin => &IPL_ORIGIN_TL,
					 -image => $self,
				   ], @_);
	
	unless (blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->SetOrigin(
	-image => Image to set origin, (default: \$self)
	-origin => IPL_ORIGIN_TL or IPL_ORIGIN_BL (default: IPL_ORIGIN_TL)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}

	IplImage_set_origin(
		$av{-image},
		$av{-origin});

	$av{-image};
}


#  GetOrigin - Return origin of the image
sub GetOrigin {
	my $self = shift;
	my %av = &argv([ -image => $self,
				   ], @_);
	unless (blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->GetOrigin(
	-image => Image to set origin, (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	IplImage_get_origin($av{-image});
}

sub origin {
	my $self = shift;
	$self->GetOrigin;
}

sub DESTROY {
	my $self = shift;
	$self->ReleaseImage;
}


# ------------------------------------------------------------
#   ReleaseImage - Releases header and image data
# ------------------------------------------------------------
sub ReleaseImage {
	my $self = shift;
	my %av = &argv([ -image => $self,
				   ], @_);
	unless (blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->ReleaseImage(
	-image => Pointer to the header of the deallocated image.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	delete $Cv::Arr::IMAGES{$av{-image}};
	cvReleaseImage($av{-image});
}


# ------------------------------------------------------------
#   CloneImage - Makes a full copy of image
# ------------------------------------------------------------
sub CloneImage {
	my $self = shift;
	my %av = &argv([ -image => $self,
				   ], @_);

	unless (blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->CloneImage(
	-image => Original Image (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $phys = cvCloneImage($av{-image})) {
		# my $image = bless $phys, blessed $self || $self;
		my $image = bless $phys;
		$Cv::Arr::IMAGES{$image} = { };
		$image;
	} else {
		undef;
	}
}

sub clone {
	my $self = shift;
	$self->CloneImage(@_);
}


# ------------------------------------------------------------
#   SetImageCOI - Sets channel of interest to given value
# ------------------------------------------------------------
sub SetImageCOI {
	my $self = shift;
	my %av = &argv([ -coi => 0,
					 -image => $self,
				   ], @_);
	unless (blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->SetImageCOI(
	-image => Image header, (default: \$self)
	-coi => Channel of interest
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSetImageCOI($av{-image}, $av{-coi});
	$av{-image};
}

sub ResetImageCOI {
	my $self = shift;
	cvSetImageCOI($self, 0);
}

# ------------------------------------------------------------
#   GetImageCOI - Returns index of channel of interest
# ------------------------------------------------------------
sub GetImageCOI {
	my $self = shift;
	my %av = &argv([ -image => $self,
				   ], @_);
	unless (blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->GetImageCOI(
	-image => Image header (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetImageCOI($av{-image});
}


# ------------------------------------------------------------
#   SetImageROI - Sets image ROI to given rectangle
# ------------------------------------------------------------
sub SetImageROI {
	my $self = shift;
	my %av = &argv([ -rect => undef,
					 -image => $self,
				   ], @_);
	unless (blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->SetImageROI(
	-image => Image header, (default: \$self)
	-rect => ROI rectangle (reset ROI unless -rect)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if ($av{-rect}) {
		cvSetImageROI(
			$av{-image},
			pack("i4",  cvRect($av{-rect})),
			);
	} else {
		cvResetImageROI(
			$av{-image},
			);
	}
	$av{-image};
}


# ------------------------------------------------------------
#   ResetImageROI - Releases image ROI
# ------------------------------------------------------------
sub ResetImageROI {
	my $self = shift;
	my %av = &argv([ -image => $self,
				   ], @_);
	unless (blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->ResetImageROI(
	-image => Image header (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvResetImageROI($av{-image});
	$av{-image};
}


# ------------------------------------------------------------
#   GetImageROI - Returns image ROI coordinates
# ------------------------------------------------------------
sub GetImageROI {
	my $self = shift;
	my %av = &argv([ -image => $self,
				   ], @_);
	unless (blessed($av{-image})) {
		chop(my $usage = <<"----"
usage:	Cv->GetImageROI(
	-image => Image header, (default: \$self)
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my ($x, $y, $width, $height) =
		unpack("i4", cvGetImageROI($av{-image}));
	my $retval = {
		'x' => $x,
		'y' => $y,
		'width' => $width,
		'height' => $height,
	};
}


# ######################################################################
# ### CV ###############################################################
# ######################################################################

# ######################################################################
#  1. Image Processing
# ######################################################################

# ------------------------------------------------------------
#   Does image segmentation by pyramids
# ------------------------------------------------------------
sub PyrSegmentation {
	my $self = shift;
	my %av = &argv([ -level => undef,
					 -threshold1 => undef,
					 -threshold2 => undef,
					 -comp => undef, # XXXXX
					 -storage => undef,
					 -dst => undef,
					 -src => $self,
				   ], @_);

	$av{-dst} ||= $av{-src}->new;
	use Cv::MemStorage;
	$av{-storage} ||= Cv::MemStorage->new;
	unless (defined $av{-level} &&
			defined $av{-threshold1} &&
			defined $av{-threshold2} &&
			defined($av{-src}) && $av{-src}) {
		chop(my $usage = <<"----"
usage:	Cv->PyrSegmentation(
	-src => The source image. 
	-dst => The destination image. 
	-storage => Storage; stores the resulting sequence of connected 
	        components. 
	-comp => Pointer to the output sequence of the segmented components. 
	-level => Maximum level of the pyramid for the segmentation. 
	-threshold1 => Error threshold for establishing the links. 
	-threshold2 => Error threshold for the segments clustering.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvPyrSegmentation(
		$av{-src}, $av{-dst},
		$av{-storage}, $av{-comp} || my $comp,
		$av{-level}, $av{-threshold1}, $av{-threshold2},
		);
	$av{-dst};
}


# ######################################################################
# ### HighGUI ##########################################################
# ######################################################################

# ======================================================================
#  Simple GUI
# ======================================================================
# ------------------------------------------------------------
#  cvNamedWindow - Creates window
# ------------------------------------------------------------
sub NamedWindow {
	my $self = shift;
	use Cv::Window;
	my $window = Cv::Window->new(@_);
	my $class = blessed $self;
	if (!defined($class) || $class eq 'Cv::Window') {
		$window;
	} else {
		$Cv::Arr::IMAGES{$self}{window} = $window;
		$self;
	}
}


# ------------------------------------------------------------
#  cvDestroyWindow - Destroys a window
# ------------------------------------------------------------
sub DestroyWindow {
	my $self = shift;
	my %av = &argv([ -name => undef,
					 -image => $self,
				   ], @_);
	$av{-name} ||= $Cv::Arr::IMAGES{$self}{window};
	if (blessed $av{-name}) {
		my $name = $av{-name};
		delete $av{-name};
		$name->DestroyWindow;
	} else {
		carp "can\'t use DestroyWindow";
	}
}

# ======================================================================
#  Loading and Saving Images (from HighGUI)
# ======================================================================

# ------------------------------------------------------------
#  cvLoadImage - Loads an image from file
# ------------------------------------------------------------
sub LoadImage {
	my $self = shift;
	my %av = &argv([ -filename => undef,
					 -flags => &CV_LOAD_IMAGE_COLOR,
				   ], @_);
	unless (defined $av{-filename} &&
			defined $av{-flags}) {
		chop(my $usage = <<"----"
usage:	Cv::Image->LoadImage(
	-filename => Name of file to be loaded,
	-flags => Specifies colorness and depth of the loaded image
	)
----
		 );
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $phys = cvLoadImage($av{-filename}, $av{-flags})) {
		bless $phys, blessed $self || $self;
	} else {
		undef;
	}
}


sub load {
	my $self = shift;
	$self->LoadImage(@_);
}


# ------------------------------------------------------------
#  cvSaveImage - Saves an image to the file
#  (Cv::Arr)
# ------------------------------------------------------------

# ------------------------------------------------------------
#  cvWaitKey - Waits for a pressed key
# ------------------------------------------------------------
sub WaitKey {
	my $self = shift;
	use Cv::Window;
	Cv::Window->WaitKey(@_);
}


1;
