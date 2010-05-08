#!/usr/bin/perl
# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

use lib qw(blib/lib blib/arch);
use strict;
use Cv 0.03;

&run;
exit 0;

# the script demostrates iterative construction of delaunay
# triangulation and voronoi tesselation

sub draw_subdiv_point {
	my ($img, $fp, $color) = @_;
	$img->Circle(
		-center => $fp,
		-radius => 3,
		-color => $color,
		-thickness => &CV_FILLED,
		-line_type => 8,
		-shift => 0,
		);
}

sub draw_subdiv_edge {
	my ($img, $edge, $color) = @_;
	my $org = $edge->Org;
	my $dst = $edge->Dst;
	if ($org && $dst) {
		$img->Line(
			-pt1 => $org,
			-pt2 => $dst,
			-color => $color,
			-thickness => 1,
			-line_type => &CV_AA,
			-shift => 0,
			);
    }
}

sub draw_subdiv {
	my ($img, $subdiv, $delaunay_color, $voronoi_color) = @_;
	my $total = $subdiv->edges->total;
	my $reader = $subdiv->edges->StartReadSeq;
	for (1 .. $total) {
		my $edge = Cv->Subdiv2DEdge($reader->ptr);
		if (CV_IS_SET_ELEM($edge)) {
			my $edge2 = Cv->Subdiv2DEdge(\ (my $tmp = ${$reader->ptr} + 1));
			draw_subdiv_edge($img, $edge2, $voronoi_color);
			draw_subdiv_edge($img, $edge, $delaunay_color);
		}
        $reader->NextSeqElem;
    }
}

sub locate_point {
	my ($subdiv, $fp, $img, $active_color) = @_;
    $subdiv->Locate(-pt => $fp, -edge => \ (my $e0));
	if ($e0) {
		my $e = $e0;
		do {
			draw_subdiv_edge($img, $e, $active_color);
			$e = $e->GetEdge(-type => &CV_NEXT_AROUND_LEFT);
		} while ($e->ne($e0));
	}
	draw_subdiv_point($img, $fp, $active_color);
}


sub draw_subdiv_facet {
	my ($img, $edge) = @_;
	if (my $t = $edge) {
		my @buf = ();

		# gather points
		do {
			return undef unless my $pt = $t->Org;
			push(@buf, scalar cvPoint($pt));
			$t = $t->GetEdge(-type => &CV_NEXT_AROUND_LEFT);
		} while ($t->ne($edge));

		$img->FillConvexPoly(
			-pts => \@buf,
			-color => &CV_RGB(rand(255), rand(255), rand(255)),
			-line_type => &CV_AA,
			-shift => 0,
			);
		$img->PolyLine(
			-pts => [ \@buf ],
			-contours => 1,
			-is_closed => 1,
			-color => &CV_RGB(0, 0, 0),
			-thickness => 1,
			-line_type => &CV_AA,
			-shift => 0,
			);
		draw_subdiv_point($img, $edge->Rotate(1)->Dst, &CV_RGB(0, 0, 0));
	}
}

sub paint_voronoi {
	my ($subdiv, $img) = @_;
    my $total = $subdiv->edges->total;
    $subdiv->CalcVoronoi;
	my $reader = $subdiv->edges->StartReadSeq;
	for (1 .. $total) {
		my $edge = Cv->Subdiv2DEdge($reader->ptr);
        if (CV_IS_SET_ELEM($edge)) {
            draw_subdiv_facet($img, $edge->Rotate(1)); # left
            draw_subdiv_facet($img, $edge->Rotate(3)); # right
        }
        $reader->NextSeqElem;
    }
}


sub run {
	my $win = "source";
    my $rect = { 'x' => 0, 'y' => 0, 'width' => 600, 'height' => 600 };

    my $active_facet_color = &CV_RGB(255,   0,   0);
    my $delaunay_color     = &CV_RGB(  0,   0,   0);
    my $voronoi_color      = &CV_RGB(  0, 180,   0);
    my $bkgnd_color        = &CV_RGB(255, 255, 255);

    my $img = Cv->CreateImage(
		-size => scalar cvSize($rect),
		-depth => 8, -channels => 3,
		);
    $img->Set(-value => $bkgnd_color);
	Cv->NamedWindow(-window_name => $win, -flags => 1);

	my $storage = Cv->CreateMemStorage(0);
    my $subdiv = Cv->CreateSubdivDelaunay2D(
		-rect => $rect, -storage => $storage,
		);

    print ("Delaunay triangulation will be build now interactively.\n",
		   "To stop the process, press any key\n\n");

    for (1 .. 200) {
        my $fp = cvPoint(
			-x => rand($rect->{width}  - 10) + 5,
			-y => rand($rect->{height} - 10) + 5,
			);

        locate_point($subdiv, $fp, $img, $active_facet_color);

        $img->ShowImage(-window_name => $win);
        last if (Cv->WaitKey(100) >= 0);

        $subdiv->DelaunayInsert($fp);
        $subdiv->CalcVoronoi;
		$img->Set(-value => $bkgnd_color);
        draw_subdiv($img, $subdiv, $delaunay_color, $voronoi_color);
        $img->ShowImage(-window_name => $win);
        last if (Cv->WaitKey(100) >= 0);
    }

	$img->Set(-value => $bkgnd_color);
    paint_voronoi($subdiv, $img);
    $img->ShowImage(-window_name => $win);
    Cv->WaitKey(0);
}
