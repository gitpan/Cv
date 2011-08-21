# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Subdiv2D;

use 5.008008;
use strict;
use warnings;

BEGIN {
	Cv::aliases(
		[ 'cvCalcSubdivVoronoi2D', 'CalcVoronoi' ],
		[ 'Cv::CreateSubdivDelaunay2D', 'CreateDelaunay' ],
		[ 'cvSubdivDelaunay2DInsert', 'DelaunayInsert' ],
		[ 'cvSubdiv2DLocate', 'Locate' ],
		);
}

1;
__END__
