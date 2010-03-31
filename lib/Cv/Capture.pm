# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Capture;
use lib qw(blib/lib blib/arch);

use 5.008000;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);
use File::Basename;
use Data::Dumper;

BEGIN {
	$Data::Dumper::Terse = 1;
}

use Cv::Constant;
use Cv::CxCore qw(:all);
use Cv::Image;

our @ISA = qw(Cv::Image);

our $VERSION = '0.02';

our %FLIPBOOK = ();

our %PROPERTIES = (
	'pos_msec'      => &CV_CAP_PROP_POS_MSEC,
	'pos_frames'    => &CV_CAP_PROP_POS_FRAMES,
	'pos_avi_ratio' => &CV_CAP_PROP_POS_AVI_RATIO,
	# 'frame_width'   => &CV_CAP_PROP_FRAME_WIDTH,
	'width'         => &CV_CAP_PROP_FRAME_WIDTH,
	# 'frame_height'  => &CV_CAP_PROP_FRAME_HEIGHT,
	'height'        => &CV_CAP_PROP_FRAME_HEIGHT,
	'fps'           => &CV_CAP_PROP_FPS,
	'fourcc'        => &CV_CAP_PROP_FOURCC,
	'frame_count'   => &CV_CAP_PROP_FRAME_COUNT,
	'format'        => &CV_CAP_PROP_FORMAT,
	'mode'          => &CV_CAP_PROP_MODE,
	'brightness'    => &CV_CAP_PROP_BRIGHTNESS,
	'contrast'      => &CV_CAP_PROP_CONTRAST,
	'saturation'    => &CV_CAP_PROP_SATURATION,
	'hue'           => &CV_CAP_PROP_HUE,
	'gain'          => &CV_CAP_PROP_GAIN,
	'convert_rgb'   => &CV_CAP_PROP_CONVERT_RGB,
);

# Preloaded methods go here.

# ======================================================================
#  Video I/O functions
# ======================================================================

# ------------------------------------------------------------
#  CvCapture - Video capturing structure
# ------------------------------------------------------------

# ------------------------------------------------------------
#  cvCreateFileCapture - Initializes capturing video from file
# ------------------------------------------------------------
=xxx
sub new {
    my $class = shift;
	if (defined $_[0]) {
		if (blessed $class) {
			Cv::Image::new($class, @_); # XXXXX
		} elsif ($_[0] =~ /^-/) {
			my %av = &argv(@_);
			if (defined $av{-index}) {
				CreateCameraCapture($class, @_);
			} elsif (defined $av{-filename}) {
				CreateFileCapture($class, @_);
			} else {
				undef;
			}
		} elsif ($_[0] =~ /^\d/) {
			CreateCameraCapture($class, @_);
		} elsif (-f $_[0] || -d $_[0]) {
			CreateFileCapture($class, @_);
		} else {
			undef;
		}
	} else {
		undef;
	}
}
=cut

sub CreateFileCapture {
    my $class = shift;
	my %av = &argv([ -filename => undef,
					 -pattern => [ "*.bmp", "*.BMP",
								   "*.jpg", "*.JPG",
								   "*.png", "*.PNG",
					 ],
				   ], @_);
	$av{-filename} ||= $av{-name}; delete $av{-name};
	unless (defined $av{-filename}) {
		chop(my $usage = <<"----"
usage:	Cv::Capture->CreateFileCapture (
	-filename => Name of the video file.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $self = undef;
	if (-d $av{-filename}) {
		$av{-flags} ||= &CV_LOAD_IMAGE_COLOR;
		if (my $files = list($av{-filename}, $av{-pattern})) {
			if (@$files > 0) {
				if (my $image = cvLoadImage($files->[0], $av{-flags})) {
					$self = bless $image, $class;
					$FLIPBOOK{$self} = {
						files => $files,
						flags => $av{-flags},
					};
				}
			}
		}
	} elsif (-d $av{-filename}) {
		if (my $phys = cvCreateFileCapture($av{-index})) {
			$self = bless $phys, $class;
		}
	} else {
		croak "can\'t CreateFileCapture $av{-filename}";
	}
	$self;
}

sub list { 
	my $dir = shift;
	my $i = length($dir);
	my @files = ();
	foreach (@_) {
		if (ref $_) {
			push(@files, list($dir, @{$_}));
		} else {
			push(@files, map { $_->[0] } sort { $a->[1] <=> $b->[1] } map {
				basename($_) =~ /\d+/; [ $_, $& ];
				 } glob("$dir/$_"));
		}
	}
	wantarray ? @files : \@files;
}

# ------------------------------------------------------------
#  cvCreateCameraCapture - Initializes capturing video from camera
# ------------------------------------------------------------
sub CreateCameraCapture {
    my $class = shift;
	my %av = &argv([ -index => 0,
				   ], @_);
	if (my $phys = cvCreateCameraCapture($av{-index})) {
		bless $phys, $class;
	} else {
		undef;
	}
}


# ------------------------------------------------------------
#  cvReleaseCapture - Releases the CvCapture structure
# ------------------------------------------------------------
sub DESTROY {
	my $self = shift;
	if ($FLIPBOOK{$self}) {
		delete $FLIPBOOK{$self};
		cvReleaseImage($self);
	} else {
		cvReleaseCapture($self);
	}
}

# ------------------------------------------------------------
#  cvGrabFrame - Grabs frame from camera or file
# ------------------------------------------------------------
sub GrabFrame {
	my $self = shift;
	my %av = &argv([ -capture => $self,
				   ], @_);
	unless (blessed $av{-capture}) {
		chop(my $usage = <<"----"
usage:	Cv::FileCapture->GrabFrame (
	-capture => video capturing structure.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $flipbook = $FLIPBOOK{$av{-capture}}) {
		$flipbook->{filename} = shift(@{$flipbook->{files}});
	} else {
		cvGrabFrame($av{-capture});
	}
}

# ------------------------------------------------------------
#  cvRetrieveFrame - Gets the image grabbed with cvGrabFrame
# ------------------------------------------------------------
sub RetrieveFrame {
	my $self = shift;
	my %av = &argv([ -capture => $self,
				   ], @_);
	unless (blessed $av{-capture}) {
		chop(my $usage = <<"----"
usage:	Cv::FileCapture->RetrieveFrame (
	-capture => video capturing structure.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (my $flipbook = $FLIPBOOK{$av{-capture}}) {
		if ($flipbook->{filename}) {
			if (my $image = Cv->LoadImage(
					-filename => $flipbook->{filename},
					-flags => $flipbook->{flags})) {
				Cv->Copy(-src => $image, -dst => $self);
			}
			$self;
		} else {
			undef;
		}
	} else {
		use Cv::Image::Ghost;
		bless cvRetrieveFrame($av{-capture}), 'Cv::Image::Ghost';
	}
}

# ------------------------------------------------------------
#  cvQueryFrame - Grabs and returns a frame from camera or file
# ------------------------------------------------------------
sub QueryFrame {
	my $self = shift;
	my %av = &argv([ -capture => $self,
				   ], @_);
	unless (blessed $av{-capture}) {
		chop(my $usage = <<"----"
usage:	Cv::FileCapture->QueryFrame (
	-capture => video capturing structure.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if ($FLIPBOOK{$av{-capture}}) {
		$av{-capture}->GrabFrame &&
			$av{-capture}->RetrieveFrame;
	} else {
		use Cv::Image::Ghost;
		bless cvQueryFrame($av{-capture}), 'Cv::Image::Ghost';
	}
}

# ------------------------------------------------------------
#  cvGetCaptureProperty - Gets video capturing properties
# ------------------------------------------------------------
sub GetProperty {
	my $self = shift;
	my %av = &argv([ -property_id => undef,
					 -capture => $self,
				   ], @_);
	unless (defined($av{-capture}) &&
			defined $av{-property_id}) {
		chop(my $usage = <<"----"
usage:	Cv::cvGetCaptureProperty(
	-capture => video capturing structure.
	-property_id => property identifier.
	)
----
			 );
		croak $usage, " = ", &Dumper(\%av);
	}
	my $id = lc $av{-property_id};
	$id = (defined $PROPERTIES{$id})? $PROPERTIES{$id} : $id;
	cvGetCaptureProperty($av{-capture}, $id);
}

# ------------------------------------------------------------
#  cvSetCaptureProperty - Sets video capturing properties
# ------------------------------------------------------------
sub SetProperty {
	my $self = shift;
	my %av = &argv([ -property_id => undef,
					 -value => undef,
					 -capture => $self,
				   ], @_);
	unless (defined($av{-capture}) &&
			defined $av{-property_id} &&
			defined $av{-value}) {
		chop(my $usage = <<"----"
usage:	Cv::cvSetCaptureProperty(
	-capture => video capturing structure.
	-property_id => property identifier.
	-value => value of the property.
	)
----
			 );
		croak $usage, " = ", &Dumper(\%av);
	}
	my $id = lc $av{-property_id};
	$id = (defined $PROPERTIES{$id})? $PROPERTIES{$id} : $id;
	cvSetCaptureProperty($av{-capture}, $id, $av{-value});
}

# ------------------------------------------------------------
#  cvCreateVideoWriter - Creates video file writer
# ------------------------------------------------------------

# ------------------------------------------------------------
#  cvReleaseVideoWriter - Releases video file writer
# ------------------------------------------------------------

# ------------------------------------------------------------
#  cvWriteFrame - Writes a frame to video file
# ------------------------------------------------------------

1;
