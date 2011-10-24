# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

#  Before `make install' is performed this script should be runnable with
#  `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
# use Test::More tests => 13;

BEGIN {
	use_ok('Cv');
}


my $verbose = Cv->hasGUI;

use File::Basename;
my $lena = dirname($0) . "/lena.jpg";
my $img = Cv->loadImage($lena);
isa_ok($img, 'Cv::Image');
my $font = Cv->InitFont(CV_FONT_HERSHEY_SIMPLEX, 0.5, 0.5, 0, 1, CV_AA);
isa_ok($font, 'Cv::Font');
use Time::HiRes qw(gettimeofday);

SKIP: {
	skip('version 2.001+', 1) unless cvVersion() >= 2.001;

	foreach my $q (0 .. 20) {
		my $params = [ CV_IMWRITE_JPEG_QUALITY, $q ];
		my $jpg = $img->encodeImage(".jpg", $params);
		isa_ok($jpg, 'Cv::Mat');
		$img->saveImage(my $tmpjpg = "/var/tmp/$$.jpg", $params);
		ok($jpg->ptr eq `cat $tmpjpg`, "ptr");
		my $dec = $jpg->decodeImage;
		isa_ok($dec, 'Cv::Image');
		my $lod = Cv->loadImage($tmpjpg); unlink($tmpjpg);
		isa_ok($lod, 'Cv::Image');
		if ($verbose) {
			$dec->putText(sprintf("jpg: quality %d, size %d", $q, $jpg->total),
						  [ 30, 30 ], $font, cvScalarAll(255));
			$dec->show;
			Cv->waitKey(100);
		}
	}
}
