# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Subdiv2D;

use 5.008000;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);
use Data::Dumper;

use Cv::Constant;
use Cv::CxCore qw(:all);
use Cv::Seq;
use Cv::Subdiv2D::Edge;

BEGIN {
	$Data::Dumper::Terse = 1;
}

our $VERSION = '0.03';

# ------------------------------------------------------------
#  CreateSubdivDelaunay2D - Creates empty Delaunay triangulation
# ------------------------------------------------------------
sub CreateDelaunay {
    my $class = shift;
	my %av = &argv([ -rect => undef,
					 -storage => undef,
				   ], @_);
	if (my $delaunay = cvCreateSubdivDelaunay2D(
			pack("i4", cvRect($av{-rect})),
			$av{-storage})
		) {
		bless $delaunay, $class;
	} else {
		undef;
	}
}

sub DESTROY { }

sub edges {
	my $self = shift;
	bless CvSubdiv2D_edges($self), 'Cv::Seq';
}

# ------------------------------------------------------------
#  SubdivDelaunay2DInsert - Inserts a single point to Delaunay triangulation
# ------------------------------------------------------------
sub DelaunayInsert {
    my $self = shift;
	my %av = &argv([ -pt => undef,
					 -subdiv => $self,
				   ], @_);
	my ($flags, $first, $x, $y) =
		unpack("i2f2", cvSubdivDelaunay2DInsert(
				   $av{-subdiv},
				   pack("f2", cvPoint($av{-pt})),
			   ));
	my $pt = {
		'flags' => $flags,
		'first' => $first,
		'x' => $x,
		'y' => $y,
	};
}

# ------------------------------------------------------------
#  Subdiv2DLocate - Inserts a single point to Delaunay triangulation
# ------------------------------------------------------------
sub Locate {
    my $self = shift;
	my %av = &argv([ -pt => undef,
					 -edge => undef,
					 -vertex => undef,
					 -subdiv => $self,
				   ], @_);
	unless (blessed $av{-subdiv} &&
			defined $av{-pt}) {
		chop(my $usage = <<"----"
usage:	Cv::Subdiv2D->Locate(
	-subdiv => Delaunay or another subdivision. 
	-pt => The point to locate. 
	-edge => The output edge the point falls onto or right to. 
	-vertex => Optional output vertex double pointer the input point
	        coincides with. 
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	my $loc = cvSubdiv2DLocate(
		$av{-subdiv},
		pack("f2", cvPoint($av{-pt})),
		my $edge,
		my $vertex = {},
		);
	if (defined $edge) {
		if (ref $av{-edge}) {
			${$av{-edge}} = bless $edge, 'Cv::Subdiv2D::Edge';
		}
	}
	$loc;
}

# ------------------------------------------------------------
#  FindNearestPoint2D - Finds the closest subdivision vertex to given point
# ------------------------------------------------------------

# ------------------------------------------------------------
#  CalcSubdivVoronoi2D - Calculates coordinates of Voronoi diagram cells
# ------------------------------------------------------------
sub CalcVoronoi {
    my $self = shift;
	my %av = &argv([ -subdiv => $self,
				   ], @_);
	unless (blessed $av{-subdiv}) {
		chop(my $usage = <<"----"
usage:	Cv::Subdiv2D->CalcVoronoi(
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvCalcSubdivVoronoi2D($av{-subdiv});
	$av{-subdiv};
}

1;
__END__
