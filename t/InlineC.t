# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

#  Before `make install' is performed this script should be runnable with
#  `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

use File::Basename;
my $lena = dirname($0) . "/lena.jpg";
my $verbose = Cv->hasGUI;

my $img1 = myload($lena);
my $sum1 = $img1->Sum;
my $img2 = Cv->LoadImage($lena);
my $sum2 = $img2->Sum;
is($sum1->[$_], $sum2->[$_]) for 0 .. $img1->channels - 1;
if ($verbose) {
	$img1->show('Inline C');
	Cv->waitKey(1000);
}

use Cv::Config;
use Inline C => Config => %Cv::Config::C;
use Inline C => << '----';
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include "typemap.h"
IplImage* myload(const char* name)
{
	return cvLoadImage(name);
}
----
