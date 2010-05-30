# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

# The full "Square Detector" program.  It loads several images
# subsequentally and tries to find squares in each image

use Test::More qw(no_plan);
#use Test::More tests => 2;
use Test::Output;
BEGIN {
	use_ok('Cv');
}
use File::Basename;
use Data::Dumper;

my $thresh = 50;
my $wndname = "Square Detection Demo";

# helper function: finds a cosine of angle between vectors from
# pt0->pt1 and from pt0->pt2

sub angle {
    my ($pt1, $pt2, $pt0) = @_;

    my $dx1 = $pt1->[0] - $pt0->[0];
    my $dy1 = $pt1->[1] - $pt0->[1];
    my $dx2 = $pt2->[0] - $pt0->[0];
    my $dy2 = $pt2->[1] - $pt0->[1];

    ($dx1*$dx2 + $dy1*$dy2) /
	sqrt(($dx1*$dx1 + $dy1*$dy1)*($dx2*$dx2 + $dy2*$dy2) + 1e-10);
}


# returns sequence of squares detected on the image.  the sequence is
# stored in the specified memory storage

sub findSquares4 {
    my ($img, $storage) = @_;

    my $N = 11;

    # create empty sequence that will contain points - 4 points per
    # square (the square's vertices)

    my $squares =
	#Cv::Seq::Point->new(0, &SizeOf_CvSeq, &SizeOf_CvPoint, $storage);
	Cv::Seq::Point->new(-storage => $storage);

    # select the maximum ROI in the image with the width and height
    # divisible by 2

    my $sz = [ $img->width & -2, $img->height & -2 ];
    my $timg = $img->CloneImage # make a copy of input image
	->SetImageROI([ 0, 0, @$sz ]);

    # down-scale and upscale the image to filter out the noise
    $timg = $timg->PyrDown(7)->PyrUp(7);

    # find squares in every color plane of the image
    foreach my $c (1 .. 3) {

        # extract the c-th color plane
	my $tgray = $timg->SetImageCOI($c)
	    ->Copy(-dst => Cv->CreateImage($sz, 8, 1));
        
        # try several threshold levels
        foreach my $l (0 .. $N - 1) {
            # hack: use Canny instead of zero threshold level.
            # Canny helps to catch squares with gradient shading   

	    my $gray;

            if ($l == 0) {
                # apply Canny. Take the upper threshold from slider
                # and set the lower to 0 (which forces edges merging)

                $gray = $tgray->Canny(
		    -threshold1 => 0, -threshold2 => $thresh,
		    -aperture_size => 5)

		    # dilate canny output to remove potential holes
		    # between edge segments

		    ->Dilate;

            } else {
                # apply threshold if l!=0:
                #   tgray(x,y) = gray(x,y) < (l+1)*255/N ? 255 : 0

                $gray = $tgray->Threshold(
		    -threshold => ($l + 1)*255/$N, -max_value => 255,
		    -threshold_type => &CV_THRESH_BINARY);
            }

            # find contours and store them all as a list
	    next unless my $contour = Cv->FindContours(
		-image => $gray, -storage => $storage,
		-mode => &CV_RETR_LIST,
		-method => &CV_CHAIN_APPROX_SIMPLE);

            # test each contour
	    while ($contour) {

		# approximate contour with accuracy proportional to
                # the contour perimeter

                my $result = $contour->ApproxPoly(
		    -method => &CV_POLY_APPROX_DP,
		    -parameter => $contour->ContourPerimeter * 0.02,
		    );

                # square contours should have 4 vertices after
		# approximation relatively large area (to filter out
		# noisy contours) and be convex.

                # Note: absolute value of an area is used because area
                # may be positive or negative - in accordance with the
                # contour orientation

                if ($result->total == 4 &&
                    abs($result->ContourArea) > 1000 &&
                    $result->CheckContourConvexity) {
		    
                    my $s = 0;

                    foreach my $i (2 .. 4) {

                        # find minimum angle between joint edges
                        # (maximum of cosine)

			my $t = abs(
			    angle(
				map {
				    scalar $result->GetSeqElem($_)
				} ($i, $i - 2, $i - 1)
			    ));
			$s = $s > $t ? $s : $t;
                    }

                    # if cosines of all angles are small (all angles
                    # are ~90 degree) then write quandrange vertices
                    # to resultant sequence

                    if ($s < 0.3) {
			for (0..3) {
			    $squares->Push(scalar $result->GetSeqElem($_));
			}
		    }
                }
                    
                # take the next contour
		$contour = $contour->h_next;
	    }
        }
    }

    $squares;
}


# the function draws all the squares in the image
sub drawSquares {
    my ($img, $squares) = @_;

    my $cpy = $img->CloneImage;
    
    # initialize reader of the sequence
    my $reader = $squares->StartReadSeq(-reverse => 0);
    
    # read 4 sequence elements at a time (all vertices of a square)
    for (my $i = 0; $i < $squares->total; $i += 4 ) {
	my @pt = ();

        # read 4 vertices
        push(@pt, scalar cvPoint(unpack("i2", $reader->ReadSeqElem)));
        push(@pt, scalar cvPoint(unpack("i2", $reader->ReadSeqElem)));
        push(@pt, scalar cvPoint(unpack("i2", $reader->ReadSeqElem)));
        push(@pt, scalar cvPoint(unpack("i2", $reader->ReadSeqElem)));

        # draw the square as a closed polyline 
        $cpy->PolyLine(
	    -pts => [ \@pt ], -npts => [ scalar @pt ], -is_closed => 1,
	    -color => CV_RGB(0,255,0), -thickness => 3, -line_type => CV_AA,
	    -shift => 0);
    }
    
    # show the resultant image
    $cpy->ShowImage($wndname);
}


my @names = ("pic1.png", "pic2.png", "pic3.png",
	     "pic4.png", "pic5.png", "pic6.png");

# create memory storage that will contain all the dynamic data
my $storage = Cv->CreateMemStorage(0);

foreach my $name (@names) {
    # load i-th image
    my $img0 = Cv->LoadImage(dirname($0).'/'.$name, 1);
    unless ($img0) {
	print "Couldn't load $name\n";
	next;
    }

    my $img = $img0->CloneImage;

    # create window and a trackbar (slider) with parent "image" and
    # set callback (the slider regulates upper threshold, passed to
    # Canny edge detector)
    Cv->NamedWindow($wndname, 1);

    # find and draw the squares
    &drawSquares($img, &findSquares4($img, $storage));

    # wait for key.  Also the function cvWaitKey takes care of event
    # processing
    my $c = Cv->WaitKey(1000);
    last if (($c & 0xff) == 27);
}

ok(1);