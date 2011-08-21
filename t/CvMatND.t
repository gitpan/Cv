# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

#  Before `make install' is performed this script should be runnable with
#  `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
# use Test::More tests => 10;

BEGIN {
	use_ok('Cv');
}

{
	my $arr = Cv::MatND->new([240, 320], CV_8UC3);
	isa_ok($arr, "Cv::MatND");
	my $type_name = Cv->TypeOf($arr)->type_name;
	is($type_name, 'opencv-nd-matrix');

	is($arr->height, 240);
	is($arr->rows, 240);
	is($arr->width, 320);
	is($arr->cols, 320);
	is($arr->depth, 8);
	is($arr->channels, 3);
	is($arr->nChannels, 3);
	is($arr->dims, 2);
	my @sizes = $arr->getDims;
	is($sizes[0], 240);
	is($sizes[1], 320);
}


{
	for (

		{ size => [240, 320], type => CV_8UC1 },
		{ size => [240, 320], type => CV_8UC2 },
		{ size => [240, 320], type => CV_8UC3 },
		{ size => [240, 320], type => CV_8UC4 },

		{ size => [240, 320], type => CV_8SC1 },
		{ size => [240, 320], type => CV_8SC2 },
		{ size => [240, 320], type => CV_8SC3 },
		{ size => [240, 320], type => CV_8SC4 },

		{ size => [240, 320], type => CV_16SC1 },
		{ size => [240, 320], type => CV_16SC2 },
		{ size => [240, 320], type => CV_16SC3 },
		{ size => [240, 320], type => CV_16SC4 },

		{ size => [240, 320], type => CV_16UC1 },
		{ size => [240, 320], type => CV_16UC2 },
		{ size => [240, 320], type => CV_16UC3 },
		{ size => [240, 320], type => CV_16UC4 },

		{ size => [240, 320], type => CV_32SC1 },
		{ size => [240, 320], type => CV_32SC2 },
		{ size => [240, 320], type => CV_32SC3 },
		{ size => [240, 320], type => CV_32SC4 },

		{ size => [240, 320], type => CV_32FC1 },
		{ size => [240, 320], type => CV_32FC2 },
		{ size => [240, 320], type => CV_32FC3 },
		{ size => [240, 320], type => CV_32FC4 },

		{ size => [240, 320], type => CV_64FC1 },
		{ size => [240, 320], type => CV_64FC2 },
		{ size => [240, 320], type => CV_64FC3 },
		{ size => [240, 320], type => CV_64FC4 },

		{ size => [2], type => CV_8UC1 },
		{ size => [2, 3], type => CV_8UC2 },
		{ size => [2, 3, 4], type => CV_8UC3 },
		{ size => [2, 3, 4, 5], type => CV_8UC4 },
		{ size => [2, 3, 4, 5, 6], type => CV_8SC1 },
		{ size => [2, 3, 4, 5, 6, 7], type => CV_8SC2 },
		{ size => [2, 3, 4, 5, 6, 7, 8], type => CV_8SC3 },
		{ size => [2, 3, 4, 5, 6, 7, 8, 9], type => CV_8SC4 },

		) {

		my $arr = new Cv::MatND($_->{size}, $_->{type});
		isa_ok($arr, "Cv::MatND");	

		is($arr->type, $_->{type});

		my $dims = $arr->getDims(\my @size);
		is($dims, scalar @{$_->{size}});
		for my $i (0 .. $dims - 1) {
			is($size[$i], $_->{size}[$i]);
		}

		is($arr->rows, $_->{size}[0]);
		is($arr->cols, $_->{size}[1]) if ($dims >= 2);

	}
}


if (0) {
	for (

		{ size => [2], type => CV_8UC1 },
		{ size => [2, 3], type => CV_8UC2 },
		{ size => [2, 3, 4], type => CV_8UC3 },
		{ size => [2, 3, 4, 5], type => CV_8UC4 },
		{ size => [2, 3, 4, 5, 6], type => CV_8SC1 },
		{ size => [2, 3, 4, 5, 6, 7], type => CV_8SC2 },
		{ size => [2, 3, 4, 5, 6, 7, 8], type => CV_8SC3 },
		{ size => [2, 3, 4, 5, 6, 7, 8, 9], type => CV_8SC4 },

		) {

		my $arr = new Cv::MatND(@{$_->{size}}, $_->{type});
		isa_ok($arr, "Cv::MatND");	

		is($arr->type, $_->{type});

		my $dims = $arr->getDims(\my @size);
		is($dims, scalar @{$_->{size}});
		for my $i (0 .. $dims - 1) {
			is($size[$i], $_->{size}[$i]);
		}

		is($arr->rows, $_->{size}[0]);
		is($arr->cols, $_->{size}[1]) if ($dims >= 2);

	}
}