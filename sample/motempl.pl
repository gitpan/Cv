#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use lib qw(blib/lib blib/arch);
use strict;

my $m = Motempl->new;
if (@ARGV == 0) {
	$m->motempl(0);
} else {
	$m->motempl($_) for @ARGV;
}


package Motempl;

use strict;
use Cv;
use List::Util qw(min max);
use Time::HiRes qw(gettimeofday);
use Data::Dumper;

# various tracking parameters (in seconds)
use constant {
	MHI_DURATION   => 1,
};

use constant {
	MAX_TIME_DELTA => MHI_DURATION * 0.5,
	MIN_TIME_DELTA => MHI_DURATION * 0.05,
};

sub new {
	my $class = shift;
	my $self = bless {}, $class;

	$self->{window} = Cv->NamedWindow("Motion", 1);
	$self;
}

sub motempl {
	my $self = shift;
	my $argv = shift;
	my $capture = $argv =~ /^\d$/ ?
		Cv->CreateCameraCapture($argv) : Cv->CreateFileCapture($argv);
	die "$0: Could not initialize capturing...\n" unless $capture;

	$self->{fps} = 30;
	$self->{ts} = 0;
	$self->{lastts} = 0;

	delete $self->{motion};
	delete $self->{mask};
	delete $self->{mhi};
	delete $self->{orient};
	delete $self->{segmask};
	delete $self->{lastgray};

	while (my $image = $capture->QueryFrame) {
		#$image->ShowImage('Source');
		#$self->{ts} = &gettimeofday; # get current time in seconds
		$self->{ts} += 1/$self->{fps}; # get current time in seconds
		my $gray = $image->CvtColor(CV_BGR2GRAY); # convert frame to grayscale
		if ($self->{lastgray}) {
			next if $self->similar($gray, $self->{lastgray});
			my $motion = $self->update_mhi($gray, 30);
			$motion->ShowImage("Motion");
		}
		$self->{lastgray} = $gray;
		my $c =  $self->waitkey;
		next if $c < 0;
		exit(0) if ($c & 0x7f) == 27 || ($c & 0x7f) == ord('q');
		last if ($c & 0x7f) == ord('n');
	}
}


sub update_mhi {
	my $self = shift;
    my $gray = shift;			# input video frame
    my $diff_threshold = shift;

	# resultant motion picture
	my $dst     = $self->{motion}  ||= $gray->new(-channels => 3)->Zero;

	# temporary images
	my $mask    = $self->{mask}    ||= $gray->new;
	my $mhi     = $self->{mhi}     ||= $gray->new(-depth => IPL_DEPTH_32F)->Zero;
	my $orient  = $self->{orient}  ||= $mhi->new;
	my $segmask = $self->{segmask} ||= $mhi->new;

	# get difference between frames and threshold it
	my $binary = $gray->AbsDiff($self->{lastgray}, $gray->new)
		->Threshold(-threshold => $diff_threshold, -max_value => 1)
		->UpdateMotionHistory(-mhi => $mhi, -timestamp => $self->{ts},
							  -duration => MHI_DURATION);

    # convert MHI to blue 8u image
	$mhi->ConvertScale(
		-dst => $mask, -scale => 255/MHI_DURATION,
		-shift => (MHI_DURATION - $self->{ts})*255/MHI_DURATION);

    $dst->Zero;
    $dst->Merge($mask);

    # calculate motion gradient orientation and valid orientation mask
    $mhi->CalcMotionGradient(
		-mask => $mask, -orientation => $orient,
		-delta1 => MAX_TIME_DELTA, -delta2 => MIN_TIME_DELTA,
		-aperture_size => 3);

	my $storage = Cv->CreateMemStorage(0);

    # segment motion: get sequence of motion components segmask is
    # marked motion components map. It is not used further
	my $seq = Cv->SegmentMotion(
		-mhi => $mhi, 
		-seg_mask => $segmask,
		-timestamp => $self->{ts},
		-seg_thresh => MAX_TIME_DELTA,
		-storage => $storage,
		);

    # iterate through the motion components,
    # One more iteration (i == -1) corresponds to the whole image
    # (global motion)
	for (my $i = -1; $i < $seq->total; $i++) {
		my $comp_rect;
		my $color;
		my $magnitude;

		if ($i < 0) { # case of the whole image
			$comp_rect = { 'x' => 0, 'y' => 0,
						   'width' => $mhi->width, 'height' => $mhi->height };
			$color = CV_RGB(255, 255, 255);
			$magnitude = 100;
		} else { # i-th motion component
			next unless my $cc = $seq->GetSeqElem(-index => $i);
			#print STDERR Data::Dumper->Dump([$cc], [qw($cc)]);
			$comp_rect = $cc->{rect};
			next if ($comp_rect->{width} + $comp_rect->{height} < 100);
			$color = CV_RGB(255, 0, 0);
			$magnitude = 30;
		}
		
		# select component ROI
		$binary->SetImageROI($comp_rect);
		$mhi->SetImageROI($comp_rect);
		$orient->SetImageROI($comp_rect);
		$mask->SetImageROI($comp_rect);
		
		# calculate orientation
		my $angle = $mhi->CalcGlobalOrientation(
			-orientation => $orient, -mask => $mask,
			-timestamp => $self->{ts}, -duration => MHI_DURATION);
		$angle = 360.0 - $angle;  # adjust for images with top-left origin
		
		my $count = $binary->Norm(-norm_type => CV_L1);
		$binary->ResetImageROI;
		$mhi->ResetImageROI;
		$orient->ResetImageROI;
		$mask->ResetImageROI;
		
		# check for the case of little motion
		next if ($count < $comp_rect->{width} * $comp_rect->{height} * 0.05);
		
		# draw a clock with arrow indicating the direction
		my $center = { 'x' => $comp_rect->{x} + $comp_rect->{width}  / 2,
					   'y' => $comp_rect->{y} + $comp_rect->{height} / 2 };
		$dst->Circle(
			-center => $center, -radius => $magnitude * 1.2,
			-color => $color, -thickness => 3, -line_type => CV_AA);
		$dst->Line(
			-pt1 => $center,
			-pt2 => [ $center->{x} + $magnitude * cos($angle*CV_PI/180),
					  $center->{y} - $magnitude * sin($angle*CV_PI/180) ],
			-color => $color, -thickness => 3, -line_type => CV_AA);
	}
	$dst;
}


sub waitkey {
	my $self = shift;
    my $pause = 0; my $x = 0;
    do {
		my $dt = $self->{ts} - $self->{lastts};
		$x = Cv->WaitKey(min(max($dt*1000, 10), 1000));
		if ($x >= 0) {
			if ($pause) {
				$pause = 0;
			} elsif (($x & 0x7f) == 0x20) {
				$pause = 1;
			}
		}
    } while ($pause);
    $self->{lastts} = $self->{ts};
    $x;
}


sub similar {
	my $self = shift;
	my $curr = shift;
	my $last = shift;
	return 0 unless $last;
	my $a = $curr->PyrDown;
	my $b = $last->PyrDown;
	my $c = $a->Sub($b)->Canny(50, 50);
	my $c1 = $c->new(-size => [$c->width, 1], -depth => IPL_DEPTH_32F);
	my $c2 = $c1->new(-size => [1, 1]);
	my $d = $c->Reduce($c1)->Reduce($c2)->GetD([0, 0])->[0];
	$d < 10000;
}
