#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;
use Getopt::Std;
use Data::Dumper;

# Background average sample code done with averages and done with codebooks
# (adapted from the OpenCV book sample)
# 
# NOTE: To get the keyboard to work, you *have* to have one of the video windows be active
#       and NOT the consule window.
#
# Gary Bradski Oct 3, 2008.
# 
# /* *************** License:**************************
#   Oct. 3, 2008
#   Right to use this code in any way you want without warrenty, support or any guarentee of it working.
#
#   BOOK: It would be nice if you cited it:
#   Learning OpenCV: Computer Vision with the OpenCV Library
#     by Gary Bradski and Adrian Kaehler
#     Published by O'Reilly Media, October 3, 2008
# 
#   AVAILABLE AT: 
#     http://www.amazon.com/Learning-OpenCV-Computer-Vision-Library/dp/0596516134
#     Or: http://oreilly.com/catalog/9780596516130/
#     ISBN-10: 0596516134 or: ISBN-13: 978-0596516130    
# ************************************************** */

my %opts;
&getopts('n::', \%opts) or die;

# VARIABLES for CODEBOOK METHOD:

my $model;
my $NCHANNELS = 3;
my @ch = (1, 1, 1); # This sets what channels should be adjusted for background bounds

# USAGE:  ch9_background startFrameCollection# endFrameCollection#
# [movie filename, else from camera]
# If from AVI, then optionally add HighAvg, LowAvg, HighCB_Y LowCB_Y
# HighCB_U LowCB_U HighCB_V LowCB_V

my $filename;
my $rawImage;
my $yuvImage;					# yuvImage is for codebook method
my $ImaskCodeBook;
my $ImaskCodeBookCC;
my $capture = undef;

my $nframes = 0;
my $nframesToLearnBG = 300;


#my $model = Cv::BGCodebook->new;
my $model = Cv->CreateBGCodeBookModel;

# Set color thresholds to default values
$model->modMin(3, 3, 3);
$model->modMax(10, 10, 10);
$model->cbBounds(10, 10, 10);

my $pause = 0;
my $singlestep = 0;

$nframesToLearnBG = $opts{n} if ($opts{n});

if (@ARGV == 0) {
	print STDERR "Capture from camera\n";
	$capture = Cv->CreateCameraCapture(0);
} elsif (@ARGV == 1 && $ARGV[0] =~ /^\d$/) {
	$capture = Cv->CreateCameraCapture($ARGV[0]);
} else {
	print STDERR "Capture from file $filename\n";
	$capture = Cv->CreateFileCapture($ARGV[0]);
}

unless ($capture) {
	print STDERR "Can not initialize video capturing\n\n";
	&help;
	exit 0;
}

# MAIN PROCESSING LOOP:
while (1) {
	unless ($pause) {
		$rawImage = $capture->QueryFrame;
		++$nframes;
		last unless ($rawImage);
	}

	$pause = 1 if ($singlestep);
	
	# First time:
	if ($nframes == 1 && $rawImage) {
		# CODEBOOK METHOD ALLOCATION
		$yuvImage = $rawImage->CloneImage;
		$ImaskCodeBook = Cv->CreateImage( [$rawImage->GetSize], IPL_DEPTH_8U, 1 );
		$ImaskCodeBookCC = Cv->CreateImage( [$rawImage->GetSize], IPL_DEPTH_8U, 1 );
		$ImaskCodeBook->Set(-value => cvScalar(255));
	}

	# If we've got an rawImage and are good to go:                
	if ($rawImage) {
		# YUV For codebook method
		$rawImage->CvtColor(-dst => $yuvImage, -code => CV_BGR2YCrCb);

		# This is where we build our background model
		$model->BGCodeBookUpdate(-image => $yuvImage)
			if (!$pause && $nframes-1 < $nframesToLearnBG);
		$model->BGCodeBookClearStale(-staleThresh => $model->t/2)
			if ( $nframes-1 == $nframesToLearnBG);
		
		#Find the foreground if any
		if ($nframes-1 >= $nframesToLearnBG) {
			# Find foreground by codebook method
			$model->BGCodeBookDiff(-image => $yuvImage,
								   -fgmask => $ImaskCodeBook);

			# This part just to visualize bounding boxes and centers if desired
			$ImaskCodeBook->Copy(-dst => $ImaskCodeBookCC);	
			#Cv::BGCodebook->SegmentFGMask(-fgmask => $ImaskCodeBookCC);
			$model->SegmentFGMask(-fgmask => $ImaskCodeBookCC);
		}

		# Display
		$rawImage->ShowImage("Raw");
		$ImaskCodeBook->ShowImage("ForegroundCodeBook");
		$ImaskCodeBookCC->ShowImage("CodeBook_ConnectComp");
	}
	
	# User input:
	my $c = Cv->WaitKey(10) & 0xFF;
	$c = lc $c;

	# End processing on ESC, q or Q
	last if ($c == 27 || $c == ord('q'));

	#Else check for user input
	if ($c == ord('h')) {
            &help;
	} elsif ($c == ord('p')) {
            $pause = !$pause;
	} elsif ($c == ord('s')) {
            $singlestep = !$singlestep;
            $pause = 0;
	} elsif ($c == ord('r')) {
            $pause = 0;
            $singlestep = 0;
	} elsif ($c == ord(' ')) {
            $model->BGCodeBookClearStale(-staleThresh => 0);
            $nframes = 0;
	} elsif ($c == ord('y') || $c == ord('0') || # CODEBOOK PARAMS
			 $c == ord('u') || $c == ord('1') ||
			 $c == ord('v') || $c == ord('2') ||
			 $c == ord('a') || $c == ord('3') ||
			 $c == ord('b')	) {
            $ch[0] = ($c == ord('y') || $c == ord('0') ||
					  $c == ord('a') || $c == ord('3') );
            $ch[1] = ($c == ord('u') || $c == ord('1') ||
					  $c == ord('a') || $c == ord('3') || $c == ord('b'));
            $ch[2] = ($c == ord('v') || $c == ord('2') ||
					  $c == ord('a') || $c == ord('3') || $c == ord('b'));
            print STDERR "CodeBook YUV Channels active: $ch[0], $ch[1], $ch[2]\n";
	} elsif (
        $c == ord('i') || #modify max classification bounds (max bound goes higher)
        $c == ord('o') || #modify max classification bounds (max bound goes lower)
        $c == ord('k') || #modify min classification bounds (min bound goes lower)
        $c == ord('l')  #modify min classification bounds (min bound goes higher)
		) {
		my @ptr = $c == ord('i') || $c == ord('o') ? $model->modMax : $model->modMin;
		for (my $n = 0; $n < $NCHANNELS; $n++) {
			if ($ch[$n]) {
				my $v = $ptr[$n] + ($c == ord('i') || $c == ord('l') ? 1 : -1);
				$ptr[$n] = CV_CAST_8U($v);
			}
			print STDERR "$ptr[$n],";
		}
		printf STDERR " CodeBook %s Side\n", $c == ord('i') || $c == ord('o') ? "High" : "Low";
	}
}		

exit 0;

sub help {
    print STDERR
		"\nLearn background and find foreground using simple average and average difference learning method:\n",
        "\nUSAGE:\nbgfg_codebook [--nframes=300] [movie filename, else from camera]\n",
        "***Keep the focus on the video windows, NOT the consol***\n\n",
        "INTERACTIVE PARAMETERS:\n",
        "\tESC,q,Q  - quit the program\n",
        "\th	- print this help\n",
        "\tp	- pause toggle\n",
        "\ts	- single step\n",
        "\tr	- run mode (single step off)\n",
        "=== AVG PARAMS ===\n",
        "\t-    - bump high threshold UP by 0.25\n",
        "\t=    - bump high threshold DOWN by 0.25\n",
        "\t[    - bump low threshold UP by 0.25\n",
        "\t]    - bump low threshold DOWN by 0.25\n",
        "=== CODEBOOK PARAMS ===\n",
        "\ty,u,v- only adjust channel 0(y) or 1(u) or 2(v) respectively\n",
        "\ta	- adjust all 3 channels at once\n",
        "\tb	- adjust both 2 and 3 at once\n",
        "\ti,o	- bump upper threshold up,down by 1\n",
        "\tk,l	- bump lower threshold up,down by 1\n",
        "\tSPACE - reset the model\n",
		;
}
