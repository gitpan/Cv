# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::FileStorage;

use 5.008008;
use strict;
use warnings;

BEGIN {
  Cv::aliases(
	  [ 'cvWrite' ],
	  [ 'cvGetFileNodeByName' ],
	  );
}

our %ClassOf = (
	'opencv-image' => 'Cv::Image',
	'opencv-matrix' => 'Cv::Mat',
	'opencv-nd-matrix' => 'Cv::MatND',
	'opencv-sparse-matrix' => 'Cv::SparseMat',
	'opencv-sequence' => 'Cv::Seq',
	'opencv-sequence-tree' => 'Cv::Seq', # Cv::Contour?
	'opencv-graph' => 'Cv::Graph',
	'opencv-haar-classifier' => 'Cv::HaarClassifierCascade',
	);

sub new {
	my $class = shift;
	Cv::cvOpenFileStorage(@_);
}

sub Bless {
	my $p = shift;
	my $t = Cv::cvTypeOf($p);
	if (my $class = $ClassOf{$t->type_name}) {
		bless $p, $class;
	} else {
		$p;
	}
}

sub Load {
	my $class = shift;
	Bless(Cv::cvLoad(@_));
}

sub Read {
	Bless(cvRead(@_));
}

1;
__END__
