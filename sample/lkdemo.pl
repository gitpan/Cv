#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use strict;
use lib qw(blib/lib blib/arch);
use Cv;

my $image = undef;
my $grey = undef;
my $prev_grey = undef;
my $pyramid = undef;
my $prev_pyramid = undef;

my $win_size = [ 10, 10 ];
my $MAX_COUNT = 500;
my $points = [];
my $prev_points = [];

my $add_remove_pt = 0;
my $pt;


sub on_mouse {
	my ($event, $x, $y, $flags, $param) = @_;
    return unless $image;
	$y = $image->height - $y if ($image->origin);
	if ($event == CV_EVENT_LBUTTONDOWN) {
        $pt = { 'x' => $x, 'y' => $y };
        $add_remove_pt = 1;
    }
}


my $capture = undef;
if (@ARGV == 0) {
	$capture = Cv->CreateCameraCapture(0);
} elsif (@ARGV == 1 && $ARGV[0] =~ /^\d$/) {
	$capture = Cv->CreateCameraCapture($ARGV[0]);
} else {
	$capture = Cv->CreateFileCapture($ARGV[0]);
}
die "$0: Could not initialize capturing...\n"
	unless $capture;

# print a welcome message, and the OpenCV version
printf("Welcome to lkdemo, using OpenCV version %s (%d.%d.%d)\n",
	   CV_VERSION, CV_MAJOR_VERSION, CV_MINOR_VERSION, CV_SUBMINOR_VERSION);

print ("Hot keys: \n",
	   "\tESC - quit the program\n",
	   "\tr - auto-initialize tracking\n",
	   "\tc - delete all the points\n",
	   "\tn - switch the \"night\" mode on/off\n",
	   "To add/remove a feature point click it\n");

Cv->NamedWindow(-name => "LkDemo")
	->SetMouseCallback(-callback => \&on_mouse);

my $need_to_init = 0;
my $night_mode = 0;
my $flags = 0;

while (my $frame = $capture->QueryFrame) {

	unless ($image) {
		$image = Cv->new(-size => scalar $frame->GetSize,
						 -depth => 8, -channels => 3,
						 -origin => $frame->origin);
		$flags = 0;
	}
	$frame->Copy(-dst => $image);
	$grey = $image->CvtColor(CV_BGR2GRAY);
	$pyramid = $grey->new;

	if ($night_mode) {
		$image->Zero;
	}

	if ($need_to_init) {
		# automatic initialization
		$grey->GoodFeaturesToTrack(
			# -image => $grey,
			# -eig_image => $grey->new(-depth => 32),
			# -temp_image => $grey->new(-depth => 32),
			-corners => $points = [],
			-corner_count => $MAX_COUNT,
			-quality_level => 0.01,
			-min_distance => 10,
			-mask => \0,
			-block_size => 3,
			-use_harris => 0,
			-k => 0.04,
			);

		$grey->FindCornerSubPix(
			# -image => $grey,
			-corners => $points,
			# -count => scalar @{$points},
			-win => $win_size,
			-zero_zone => [ -1, -1 ],
			-criteria => scalar cvTermCriteria(
				 -type => CV_TERMCRIT_ITER | CV_TERMCRIT_EPS,
				 -max_iter => 20, -epsilon => 0.03),
			);

		$flags = 0;
        $need_to_init = 0;

	} elsif (@{$prev_points} > 0) {
		my $temp_points = [];
		Cv->CalcOpticalFlowPyrLK(
			-prev => $prev_grey,
			-curr => $grey,
			-prev_pyr => $prev_pyramid,
			-curr_pyr => $pyramid,
			-prev_features => $prev_points,
			-curr_features => $temp_points,
			-win_size => $win_size,
			-level => 3,
			# -status => my $status = [],
			# -track_error => my $track_error = [],
			-criteria => scalar cvTermCriteria(
				 -type => CV_TERMCRIT_ITER | CV_TERMCRIT_EPS,
				 -max_iter => 20, -epsilon => 0.03),
			-flags => $flags,
			);
		$flags |= CV_LKFLOW_PYR_A_READY;

		# foreach my $i (0 .. $#{$temp_points}) {
		# 	$temp_points->[$i]->{status} = $status->[$i];
		# 	$temp_points->[$i]->{track_status} = $track_error->[$i];
		# }

		my @good_points = ();
		foreach my $p (@{$temp_points}) {
			if ($add_remove_pt) {
				my $dx = $pt->{x} - $p->{x};
				my $dy = $pt->{y} - $p->{y};
				if ($dx*$dx + $dy*$dy <= 25) {
					$add_remove_pt = 0;
					next;
				}
			}
			# next if (!$p->{status});
			push(@good_points, $p);
			$image->Circle(
				# -img => $image,
				-center => $p,
				-radius => 3,
				-color => scalar CV_RGB(0, 255, 0),
				-thickness => -1,
				-line_type => 8,
				-shift => 0,
				);
		}
		$points = \@good_points;
	} else {
		$points = [];
		$flags = 0;
	}

	if ($add_remove_pt) {
		if (@{$points} < $MAX_COUNT) {
			$grey->FindCornerSubPix(
				# -image => $grey,
				-corners => my $p = [ $pt ],
				# -count => 1,
				-win => $win_size,
				-zero_zone => [ -1, -1 ],
				-criteria => scalar cvTermCriteria(
					 -type => CV_TERMCRIT_ITER | CV_TERMCRIT_EPS,
					 -max_iter => 20, -epsilon => 0.03),
				);
			push(@{$points}, @{$p});
		}
		$add_remove_pt = 0;
	}

	$prev_grey    = $grey;
	$prev_pyramid = $pyramid;
	$prev_points  = $points;
	
	$image->ShowImage("LkDemo");

	my $c = Cv->WaitKey(10);
	next unless ($c >= 0);
	
	if (($c &= 0x7f) == 27) {
		last;
	} elsif ($c == ord('r')) {
		$need_to_init = 1;
	} elsif ($c == ord('c')) {
		$prev_points = [];
	} elsif ($c == ord('n')) {
		$night_mode ^= 1;
	}
}
