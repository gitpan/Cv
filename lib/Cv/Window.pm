# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Window;

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

our $VERSION = '0.04';

# Preloaded methods go here.

# ======================================================================
#  Simple GUI
# ======================================================================

our %WINDOWS = ();

sub window_name {
	my %av = @_;
	if (blessed($av{-name} ||= $av{-window_name})) {
		$av{-name} = $av{-name}->name;
	}
	$av{-name};
}

# ------------------------------------------------------------
#  cvNamedWindow - Creates window
# ------------------------------------------------------------
sub new {
    my $class = shift;
	my %av = argv([ -name => undef,
					-flags => &CV_WINDOW_AUTOSIZE,
				  ], @_);
	$av{-name} ||= $av{-window_name} || __PACKAGE__;
	unless (defined($av{-name}) && defined($av{-flags})) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Window->new(
	-name => Name of the window which is used as window identifier and
	        appears in the window caption. 
	-flags => Flags of the window. Currently the only supported flag is
	        CV_WINDOW_AUTOSIZE. If it is set, window size is automatically
	        adjusted to fit the displayed image (see cvShowImage), while
	        user can not change the window size manually.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $self = undef;
	if (cvGetWindowHandle($av{-name})) {
		$self = $WINDOWS{$av{-name}}{self};
	} else {
		cvNamedWindow($av{-name}, $av{-flags});
		if (my $handle = cvGetWindowHandle($av{-name})) {
			$self = bless $handle, blessed $class || $class;
			$WINDOWS{$av{-name}} = { self => $self };
		}
	}
	#print STDERR Data::Dumper->Dump([\%WINDOWS], [qw($WINDOWS)]);
	$self;
	
}


# ------------------------------------------------------------
#  cvDestroyWindow - Destroys a window
# ------------------------------------------------------------
sub DestroyWindow {
	my $self = shift;
	my %av = argv([ -name => $self,
				  ], @_);
	$av{-name} = window_name(%av);
	unless (defined $av{-name}) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Window->DestryWindow(
	-name => Name of the window to be destroyed.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if (defined $WINDOWS{$av{-name}}) {
		my $window = $WINDOWS{$av{-name}};
		if (defined $window->{trackbar}) {
			foreach (keys %{$window->{trackbar}}) {
				my $trackbar = $window->{trackbar}{$_};
				#print STDERR Data::Dumper->Dump([$trackbar], [qw($trackbar)]);
				cvReleaseTrackbar($trackbar);
			}
		}
		delete $WINDOWS{$av{-name}};
	}
	cvDestroyWindow($av{-name});
	$self;
}


sub DESTROY {
	my $self = shift;
	# print STDERR Data::Dumper->Dump([\%WINDOWS], [qw($WINDOWS)]);
	$self->DestroyWindow;
}


# ------------------------------------------------------------
#  cvDestroyAllWindows - Destroys all the HighGUI windows
# ------------------------------------------------------------
sub DestroyAllWindows {
	my $self = shift;
	cvDestroyAllWindows();
}

# ------------------------------------------------------------
#  cvResizeWindow - Sets window size
# ------------------------------------------------------------
sub ResizeWindow {
    my $self = shift;
	my %av = argv([ -width => undef,
					-height => undef,
					-name => $self,
				  ], @_);

	if (defined($av{-size})) {
		unless (defined($av{-width}) && defined($av{-height})) {
			($av{-width}, $av{-height}) = cvSize($av{-size});
		}
	}
	$av{-name} = window_name(%av);
	unless (defined($av{-name}) &&
			defined($av{-width}) && defined($av{-height})) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Window->ResizeWindow(
	-name => Name of the window to be resized.
	-width => New width
	-height => New height
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvResizeWindow(
		$av{-name},
		$av{-width},
		$av{-height},
		);
	$self;
}


# ------------------------------------------------------------
#  cvMoveWindow - Sets window position
# ------------------------------------------------------------
sub MoveWindow {
    my $self = shift;
	my %av = argv([ -x => undef,
					-y => undef,
					-name => $self,
				  ], @_);
	if (defined($av{-pt})) {
		unless (defined($av{-x}) && defined($av{-y})) {
			($av{-x}, $av{-y}) = cvPoint($av{-pt});
		}
	}
	$av{-name} = window_name(%av);
	unless (defined($av{-name}) &&
			defined($av{-x}) && defined($av{-y})) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Window->MoveWindow(
	-name => Name of the window to be moved.
	-x => New x coordinate of top-left corner 
	-y => New Y coordinate of top-left corner
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvMoveWindow(
		$av{-name},
		$av{-x},
		$av{-y},
		);
	$self;
}

# ------------------------------------------------------------
#  cvGetWindowHandle - Gets window handle by name
# ------------------------------------------------------------
sub GetWindowHandle {
    my $self = shift;
	my %av = argv([ -name => $self,
				  ], @_);
	$av{-name} = window_name(%av);
	unless (defined($av{-name})) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Window->GetWindowHandle(
	-name => Name of the window.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetWindowHandle($av{-name});
}

# ------------------------------------------------------------
#  cvGetWindowName - Gets window name by handle
# ------------------------------------------------------------
sub GetWindowName {
    my $self = shift;
	my %av = argv([	-window_handle => $self,
				  ], @_);
	$av{-window_handle} ||= $av{-handle};
	#print STDERR Data::Dumper->Dump([\%av], [qw($av)]);
	if (my $name = cvGetWindowName($av{-window_handle})) {
		return $name;
	}
	unless (blessed($av{-window_handle})) {
	  usage:
		chop(my $usage = <<"----"
usage:	Cv::Window->GetWindowName(
	-window_handle => Handle of the window.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvGetWindowName($av{-window_handle});
}

sub name {
	my $self = shift;
	$self->GetWindowName(@_);
}


# ------------------------------------------------------------
#  cvShowImage - Shows the image in the specified window
# ------------------------------------------------------------
sub ShowImage {
	my $self = shift;
	my %av = argv([ -image => undef,
					-name => $self,
				  ], @_);
	$av{-name} = window_name(%av);
	unless (blessed($av{-image}) &&
			defined($av{-name})) {
		chop(my $usage = <<"----"
usage:	Cv::Window->ShowImage(
	-name => Name of the window. 
	-image => Image to be shown.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvShowImage($av{-name}, $av{-image});
	$self;
}

sub show {
	my $self = shift;
	$self->ShowImage(@_);
}


# ------------------------------------------------------------
#  cvCreateTrackbar - Creates the trackbar and attaches it to the
#                     specified window
# ------------------------------------------------------------
sub CreateTrackbar {
	my $self = shift;
	my %av = argv([ -trackbar_name => undef,
					-value => 0,
					-count => 100,
					-on_change => undef,
					-window_name => $self,
				  ], @_);
	$av{-trackbar_name} ||= $av{-name}; delete $av{-name};
	$av{-on_change} ||= $av{-callback};
	$av{-on_change} ||= \0;
	$av{-window_name} = window_name(%av);
	unless (defined $av{-trackbar_name} &&
			defined $av{-window_name} &&
			defined $av{-value} &&
			defined $av{-count}) {
		chop(my $usage = <<"----"
usage:	Cv::Window->CreateTrackbar(
	-trackbar_name, -name => Name of created trackbar. 
	-window_name => Name of the window which will be used as a parent for
	        created trackbar.
	-value => Pointer to the integer variable, which value will reflect the
	        position of the slider. Upon the creation the slider position is
	        defined by this variable.
	-count => Maximal position of the slider. Minimal position is always 0. 
	-on_change, -callback => Pointer to the function to be called every time
	        the slider changes the position. This function should be
	        prototyped as void Foo(int); Can be NULL if callback is not
	        required.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	$WINDOWS{$av{-window_name}}{trackbar}{$av{-trackbar_name}} =
		cvCreateTrackbar(
			$av{-trackbar_name},
			$av{-window_name},
			ref $av{-value}? $av{-value} : \$av{-value},
			$av{-count},
			$av{-on_change},
		);
	$self;
}


# ------------------------------------------------------------
#  cvGetTrackbarPos - Retrieves trackbar position
# ------------------------------------------------------------
sub GetTrackbarPos {
	my $self = shift;
	my %av = argv([ -trackbar_name => undef,
					-window_name => $self,
				  ], @_);
	$av{-trackbar_name} ||= $av{-name}; delete $av{-name};
	$av{-window_name} = window_name(%av);
	unless (defined $av{-trackbar_name} &&
			defined $av{-window_name}) {
		chop(my $usage = <<"----"
usage:	Cv::Window->GetTrackbarPos(
	-trackbar_name, -name => Name of created trackbar. 
	-window_name => Name of the window which will the parent of trackbar.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if ($WINDOWS{$av{-window_name}}{trackbar}{$av{-trackbar_name}}) {
		cvGetTrackbarPos(
			$av{-trackbar_name},
			$av{-window_name},
			);
	} else {
		-1;
	}
}

# ------------------------------------------------------------
#  cvSetTrackbarPos - Sets trackbar position
# ------------------------------------------------------------
sub SetTrackbarPos {
	my $self = shift;
	my %av = argv([ -trackbar_name => undef,
					-pos => undef,
					-window_name => $self,
				  ], @_);
	$av{-trackbar_name} ||= $av{-name}; delete $av{-name};
	$av{-window_name} = window_name(%av);
	unless (defined $av{-trackbar_name} &&
			defined $av{-window_name} &&
			defined $av{-pos}) {
		chop(my $usage = <<"----"
usage:	Cv::Window->SetTrackbarPos(
	-trackbar_name, -name => Name of created trackbar. 
	-window_name => Name of the window which will the parent of trackbar.
	-pos => New position.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	if ($WINDOWS{$av{-window_name}}{trackbar}{$av{-trackbar_name}}) {
		cvSetTrackbarPos(
			$av{-trackbar_name},
			$av{-window_name},
			$av{-pos},
			);
		0;
	} else {
		-1;
	}
}

# ------------------------------------------------------------
#  cvSetMouseCallback - Assigns callback for mouse events
# ------------------------------------------------------------
sub SetMouseCallback {
	my $self = shift;
	my %av = &argv([ -callback => undef,
					 -param => \0,
					 -name => $self,
				   ], @_);
	$av{-callback} ||= $av{-on_mouse};
	$av{-name} = window_name(%av);
	unless (defined $av{-name} &&
			defined $av{-param} &&
			defined $av{-callback}) {
		chop(my $usage = <<"----"
usage:	Cv::Window->SetMouseCallback(
	-window_name => Name of the window. 
	-on_mouse, -callback => Pointer to the function to be called every
	        time mouse event occurs in the specified window. This function
	        should be prototyped as
	          void Foo(int event, int x, int Y, int flags, void* param);
	        where event is one of CV_EVENT_*, x and Y are coordinates of
	        mouse pointer in image coordinates (not window coordinates),
	        flags is a combination of CV_EVENT_FLAG, and param is a user-
	        defined parameter passed to the cvSetMouseCallback function
	        call.
	-param => User-defined parameter to be passed to the callback function. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvSetMouseCallback(
		$av{-name},
		$av{-callback},
		$av{-param},
		);
	$self;
}

# ------------------------------------------------------------
#  cvWaitKey - Waits for a pressed key
# ------------------------------------------------------------
sub WaitKey {
	my $self = shift;
	my %av = &argv([ -delay => 0,
				   ], @_);
	unless (defined $av{-delay}) {
		chop(my $usage = <<"----"
usage:	Cv::Window->WaitKey(
	-delay => Delay in milliseconds.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
    cvWaitKey($av{-delay});
}

# ======================================================================
#  Loading and Saving Images
# ======================================================================

# ------------------------------------------------------------
#  cvLoadImage - Loads an image from file
#  cvSaveImage - Saves an image to the file
#  (see Cv::CxCore)
# ------------------------------------------------------------

# ======================================================================
#  Video I/O functions
# ======================================================================

# ------------------------------------------------------------
#  CvCapture - Video capturing structure
#  cvCreateFileCapture - Initializes capturing video from file
#  cvCreateCameraCapture - Initializes capturing video from camera
#  cvReleaseCapture - Releases the CvCapture structure
#  cvGrabFrame - Grabs frame from camera or file
#  cvRetrieveFrame - Gets the image grabbed with cvGrabFrame
#  cvQueryFrame - Grabs and returns a frame from camera or file
#  cvGetCaptureProperty - Gets video capturing properties
#  cvSetCaptureProperty - Sets video capturing properties
#  cvCreateVideoWriter - Creates video file writer
#  cvReleaseVideoWriter - Releases video file writer
#  cvWriteFrame - Writes a frame to video file
#  (see Cv::Capture)
# ------------------------------------------------------------

# ======================================================================
#  Utility and System Functions
# ======================================================================

# ------------------------------------------------------------
#  cvInitSystem - Initializes HighGUI
# ------------------------------------------------------------

# ------------------------------------------------------------
#  cvConvertImage - Converts one image to another with optional
#  vertical flip
# ------------------------------------------------------------

1;
