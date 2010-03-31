# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
#use Test::More tests => 8;
use Test::Output;
use Test::File;
use Test::Number::Delta;
use File::Basename;
use Data::Dumper;

BEGIN {
	use_ok('Cv');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.


my $lena = dirname($0).'/'."lena.jpg";
my ($w, $h) = (320, 240);
my $size = cvSize(-width => $w, -height => $h);
my $depth = IPL_DEPTH_8U;
my $channels = 3;

sub rand_int { int(rand($_[0])); }

# ------------------------------------------------------------
#   CreateImage - Creates header and allocates data
# ------------------------------------------------------------
{
	my $img1 = Cv->new(-size => $size, -depth => $depth, -channels => 3);
	my $img2 = Cv->new([320, 240], 8, 3);
	my $img3 = Cv->CreateImage([320, 240], 8, 3);
	
	ok($img1, "Cv->new(Named Parameter)");
	ok($img2, "Cv->new(Positional Parameter)");
	ok($img3, "Cv->CreateImage");
	
	eval { Cv->new([320, 240], 8) };
	like($@, qr//, "new(usage)");	# XXXXX
	eval { Cv->CreateImage([320, 240], 8) };
	like($@, qr/usage:/, "CreateImage(usage)");

	#  GetSize - Returns size of matrix or image ROI
	my $sz = $img1->GetSize;
	is($sz->[0], $size->[0], "GetSize(width)");
	is($sz->[1], $size->[1], "GetSize(height)");
	is($img1->width, $size->[0], "width");
	is($img1->height, $size->[1], "height");
	#  GetDepth - Return pixel depth in bits
	is($img1->GetDepth, $depth, "GetDepth");
	is($img1->depth, $depth, "depth");
	#  GetChannels - Return Number of channels per pixel
	is($img1->GetChannels, $channels, "GetChannels");
	is($img1->channels, $channels, "channels");
	is($img1->nChannels, $channels, "nChannels");
	#  SetOrigin - set origin of the image, 0 - top-left, 1 - bottom-left
	$img1->SetOrigin(IPL_ORIGIN_BL);
	is($img1->GetOrigin, IPL_ORIGIN_BL, "GetOrigin");
	$img1->SetOrigin(IPL_ORIGIN_TL);
	is($img1->origin, IPL_ORIGIN_TL, "origin");
	eval { Cv->GetOrigin };
	like($@, qr/usage:/, "GetOrigin(usage)");
	eval { Cv->SetOrigin };
	like($@, qr/usage:/, "SetOrigin(usage)");

}

# ------------------------------------------------------------
#  cvLoadImage - Loads an image from file
# ------------------------------------------------------------
{
	my $img1 = Cv->LoadImage($lena);
	ok($img1, "LoadImage");
	my $img2 = Cv->load($lena);
	ok($img2, "load");
	
	eval { Cv->LoadImage() };
	like($@, qr/usage:/, "LoadImage(usage)");
}	

# ------------------------------------------------------------
#  cvSaveImage - Saves an image to the file
# ------------------------------------------------------------
{
	my $dst = dirname($0).'/'."SavedImage.png";
	my $src = Cv->LoadImage($lena);
	$src->SaveImage($dst);
	file_exists_ok($dst);
#	Cv->LoadImage($dst)->ShowImage("Saved Image")->WaitKey;
	unlink($dst);

	eval { $src->SaveImage() };
	like($@, qr/usage:/, "SaveImage(usage)");
}


# ------------------------------------------------------------
#  cvShowImage - Shows the image in the specified window
#  cvWaitKey - Waits for a pressed key
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	$img->ShowImage("Saved Image")->WaitKey(1000);

#	eval { $img->ShowImage->WaitKey(1000) };
#	like($@, qr/can\'t use ShowImage/, "can\'t use ShowImage");
}

# ------------------------------------------------------------
#   CloneImage - Makes a full copy of image
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $clone1 = $img->CloneImage;
	ok($clone1, "CloneImage");

	my $clone2 = Cv->CloneImage(-image => $img);
	ok($clone2, "clone");

	my $clone3 = $img->clone;
	ok($clone3, "clone");

	eval { Cv->CloneImage };
	like($@, qr/usage:/, "CloneImage(usage)");
}

# ------------------------------------------------------------
#   SetImageROI - Sets image ROI to given rectangle
#   ResetImageROI - Releases image ROI
#   GetImageROI - Returns image ROI coordinates
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $roi = [100, 100, 200, 200];
	$img->SetImageROI($roi);
	my $get_roi = $img->GetImageROI;
	is($get_roi->{x}, $roi->[0], "Get/SetImageROI(x)");
	is($get_roi->{y}, $roi->[1], "Get/SetImageROI(y)");
	is($get_roi->{width}, $roi->[2], "Get/SetImageROI(width)");
	is($get_roi->{height}, $roi->[3], "Get/SetImageROI(height)");
	$img->ShowImage("SetImageROI")->WaitKey(1000);
	$img->ResetImageROI;
	$get_roi = $img->GetImageROI;
	is($get_roi->{x}, 0, "ResetImageROI(x)");
	is($get_roi->{y}, 0, "ResetImageROI(y)");
	is($get_roi->{width}, $img->width, "ResetImageROI(width)");
	is($get_roi->{height}, $img->height, "ResetImageROI(height)");

	eval { Cv->SetImageROI };
	like($@, qr/usage:/, "SetImageROI(usage)");
	eval { Cv->ResetImageROI };
	like($@, qr/usage:/, "ResetImageROI(usage)");
	eval { Cv->GetImageROI };
	like($@, qr/usage:/, "GetImageROI(usage)");
}

# ------------------------------------------------------------
#   SetImageCOI - Sets channel of interest to given value
#   GetImageCOI - Returns index of channel of interest
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $coi = 1;
	$img->SetImageCOI($coi);
	my $get_coi = $img->GetImageCOI;
	is($get_coi, $coi, "Set/GetImageCOI");
	$img->ResetImageCOI($coi);
	$get_coi = $img->GetImageCOI;
	is($get_coi, 0, "ReSetImageCOI");

	eval { Cv->SetImageCOI };
	like($@, qr/usage:/, "SetImageCOI(usage)");
	eval { Cv->GetImageCOI };
	like($@, qr/usage:/, "GetImageCOI(usage)");
}

# ------------------------------------------------------------ 
#  GetElemType - Returns type of array elements
# ------------------------------------------------------------
{
	my $img = Cv->new($size, $depth, 3);
	my $type = $img->GetElemType;
	is($type, CV_8UC3, "GetElemType");
}

# ------------------------------------------------------------ 
#  GetDims, GetDimSize - Return number of array dimensions and their sizes
# ------------------------------------------------------------
{
	my $img = Cv->new($size, $depth, 3);
	my @dims = $img->GetDims;
	is(@dims, 2, "GetDims(dims)");
	is($dims[0], $size->[1], "GetDims(0)");
	is($dims[1], $size->[0], "GetDims(1)");

	is($img->GetDimSize,    $size->[1], "GetDimSize");
	is($img->GetDimSize(0), $size->[1], "GetDimSize(0)");
	is($img->GetDimSize(1), $size->[0], "GetDimSize(1)");
}

# ------------------------------------------------------------
#  Set*D - Change the particular array element
#  Get*D - Return the particular array element
# ------------------------------------------------------------
{
	# GetD/SetD
	my $img = Cv->new($size, $depth, 3)->Zero;
	my $idx = [rand_int($h), rand_int($w)];
	my $val = CV_RGB(70, 80, 90);
	$img->SetD($idx, $val);
	my $r = $img->GetD($idx);
	is($r->[0], $val->[0], "SetD/GetD(0)");
	is($r->[1], $val->[1], "SetD/GetD(1)");
	is($r->[2], $val->[2], "SetD/GetD(2)");

	$idx = [rand_int($h), rand_int($w)];
	$val = rand_int(100);
	$img->SetD($idx, $val);
	$r = $img->GetD($idx);
	is($r->[0], $val, "SetD/GetD(0)");
	is($r->[1],    0, "SetD/GetD(1)");
	is($r->[2],    0, "SetD/GetD(2)");

	# Get1D/Set1D
	my ($row, $col) = (1, 256);
	my $mat = Cv::Mat->new(-rows => $row, -cols => $col, -type => CV_8UC1);
	$idx = rand_int($col);
	$val = rand_int(100);
	$mat->Set1D($idx, $val);
	$r = $mat->Get1D($idx);
	is($r->[0], $val, "Get1D/Set1D(scalar)");
	my @a = $mat->Get1D($idx);
	is($a[0], $val, "Get1D/Set1D(array)");

	# Get2D/Set2D
	($row, $col) = (2, 256);
	$mat = Cv::Mat->new(-rows => $row, -cols => $col, -type => CV_8UC1);
	$idx = [rand_int($row), rand_int($col)];
	$val = rand_int(100);
	$mat->Set2D($idx, $val);
	$r = $mat->Get2D($idx);
	is($r->[0], $val, "Get2D/Set2D(scalar)");
	@a = $mat->Get2D($idx);
	is($a[0], $val, "Get2D/Set2D(array)");

	# Get3D/Set3D
  SKIP: {
	  ($row, $col) = (3, 256);
	  $mat = Cv::Mat->new(-rows => $row, -cols => $col, -type => CV_8UC1);
	  $idx = [rand_int($row), rand_int($col)];
	  $val = rand_int(100);
	  $mat->Set2D($idx, $val);
	  $r = $mat->Get2D($idx);
	  is($r->[0], $val, "Get3D/Set3D(scalar)");
	  @a = $mat->Get2D($idx);
	  is($a[0], $val, "Get3D/Set3D(array)");
	}
		
	eval { $img->SetD };
	like($@, qr/usage:/, "SetD(usage)");
	eval { $img->GetD };
	like($@, qr/usage:/, "GetD(usage)");

}

# ------------------------------------------------------------
#  SetImageDate
#  GetImageDate
# ------------------------------------------------------------
{
	my $src = Cv->LoadImage($lena);
	my $dst = $src->CloneImage->Zero;
	my $data = $src->GetImageData;
	ok(length($data) == $src->width * $src->height * 3, "SetImageData");
	$dst->SetImageData($data);
	
	my @idx = (rand($src->width), rand($src->height));
	my $s = $src->GetD(\@idx);
	my $d = $dst->GetD(\@idx);
	is($d->[0], $s->[0], "GetImageData(0)");
	is($d->[1], $s->[1], "GetImageData(1)");
	is($d->[2], $s->[2], "GetImageData(2)");
}

# ------------------------------------------------------------
#  SetReal*D - Change the particular array element
#  GetReal*D - Return the particular element of single-channel array
# ------------------------------------------------------------
{
	my $val = rand(100);
	my @idx = (int(rand($h)), int(rand($w)));
	my ($row, $col) = ($h, $w);

	# GetRealD/SetRealD
	my $img = Cv->new($size, IPL_DEPTH_64F, 1)->Zero;
	$img->SetRealD(\@idx, $val);
	delta_ok($img->GetRealD(\@idx), $val, "SetRealD/GetRealD(0)");

	# GetReal1D/SetReal1D
	my $mat = Cv::Mat->new(-rows => 1, -cols => $col, -type => CV_64FC1);
	$mat->SetReal1D($idx[1], $val);
	delta_ok($mat->GetReal1D($idx[1]), $val, "GetReal1D/SetReal1D");

	# GetReal2D/SetReal2D
	$mat = Cv::Mat->new(-rows => $row, -cols => $col, -type => CV_64FC1);
	$mat->SetReal2D(\@idx, $val);
	delta_ok($mat->GetReal2D(\@idx), $val, "GetReal2D/SetReal2D");

	# Get3D/Set3D
  TODO: {
	  local $TODO = "don't know 3D Array how to use";
	  $mat = Cv::Mat->new(-rows => $row, -cols => $col, -type => CV_64FC1);
	  $idx = [rand($row), rand($col)];
	  $val = rand(100);
	  $mat->SetReal3D($idx, $val);
	  delta_ok($mat->GetReal3D($idx), $val, "GetReal3D/SetReal3D");
	}
		
	eval { $img->SetRealD };
	like($@, qr/usage:/, "SetRealD(usage)");
	eval { $img->GetRealD };
	like($@, qr/usage:/, "GetRealD(usage)");

}

# ------------------------------------------------------------
#   Set - Sets every element of array to given value
# ------------------------------------------------------------
{
	my $img = Cv->new($size, $depth, 3)->Zero;
	my $val = CV_RGB(70, 80, 90);
	$img->Set($val);
	my $r = $img->GetD([rand($h), rand($w)]);
	is($r->[0], $val->[0], "Set(0)");
	is($r->[1], $val->[1], "Set(1)");
	is($r->[2], $val->[2], "Set(2)");

	$val = 100;
	$img->Set($val);
	$r = $img->GetD([rand($h), rand($w)]);
	is($r->[0], $val, "Set(0)");
	is($r->[1], 0, "Set(1)");
	is($r->[2], 0, "Set(2)");

	eval { $img->Set };
	like($@, qr/usage:/, "Set(usage)");
}

# ------------------------------------------------------------
#   Copy - Copies one array to another
# ------------------------------------------------------------
{
	my $src = Cv->LoadImage($lena);
	my $dst = $src->Copy;
	my @pos = (rand_int(100), rand_int(100));
	ok( $src->GetD(\@pos)->[0] == $dst->GetD(\@pos)->[0] &&
		$src->GetD(\@pos)->[1] == $dst->GetD(\@pos)->[1] &&
		$src->GetD(\@pos)->[2] == $dst->GetD(\@pos)->[2], "Copy");
	$dst->Zero;
	$src->Copy(-dst => $dst);
	ok( $src->GetD(\@pos)->[0] == $dst->GetD(\@pos)->[0] &&
		$src->GetD(\@pos)->[1] == $dst->GetD(\@pos)->[1] &&
		$src->GetD(\@pos)->[2] == $dst->GetD(\@pos)->[2], "Copy(-dst)");

	eval { $src->Copy(-src => undef) };
	like($@, qr/usage:/, "Copy(usage)");
}

# ------------------------------------------------------------
#   SetIdentity - Initializes scaled identity matrix
# ------------------------------------------------------------
{
	my $mat = Cv::Mat->new(-rows => 256, -cols => 256, -type => CV_8UC1);
	my @val = (10, 20, 30);
	$mat->Set($val[0]);
	$mat->SetIdentity;
	ok( $mat->Get2D([1, 1])->[0] == 1 &&
		$mat->Get2D([1, 2])->[0] == 0, "SetIdentity");
	$mat->SetIdentity($val[0]);
	ok( $mat->Get2D([1, 1])->[0] == $val[0] &&
		$mat->Get2D([1, 2])->[0] == 0, "SetIdentity(single channle)");

	my $img = Cv->LoadImage($lena);
	$img->SetIdentity(\@val);
	ok( $img->Get2D([1, 1])->[0] == $val[0] &&
		$img->Get2D([2, 2])->[1] == $val[1] &&
		$img->Get2D([3, 3])->[2] == $val[2] , "SetIdentity(multi channels)");
	ok($img->Get2D([1, 2])->[1] == 0, "SetIdentity");

	eval { $img->SetIdentity(-mat => undef) };
	like($@, qr/usage:/, "SetIdentity(usage)");
}


# ------------------------------------------------------------
#  ConvertScale - Converts one array to another with optional
#                 linear transformation
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $dst = Cv->new(scalar $img->GetSize, 8, 3);
	my $dst16 = Cv->new(scalar $img->GetSize, 16, 3);
	$img->ConvertScale(-dst => $dst16, -scale => 256, -shift => 0);
	ok($dst16, "ConvertScale");
	Cv->CvtScale(-src => $dst16, -dst => $dst, -scale => 1/256, -shift => 0);
	ok($dst, "CvtScale");
	$dst->Scale(-dst => $dst16, -scale => 256);
	ok($dst16, "Scale");
	$dst16->Convert(-dst => $dst16, -shift => 10);
	ok($dst16, "Convert");

	eval { $img->ConvertScale(-dst => $dst16, -scale => undef) };
	like($@, qr/usage:/, "ConvertScale(usage)");
}


# ------------------------------------------------------------
#  ConvertScaleAbs - Converts input array elements to 8-bit unsigned
#                    integer another with optional linear transformation
# ------------------------------------------------------------
{
	my $img = Cv->new($size, IPL_DEPTH_8S, 3);
	my $dst = Cv->new($size, IPL_DEPTH_8U, 3);
	my ($scale, $shift) = (2, -5);
	my $val = &CV_MAJOR_VERSION >= 2? -20 : 20;
	$img->Set($val);
	$img->ConvertScaleAbs(-dst => $dst, -scale => $scale, -shift => $shift);
	ok($dst, "ConvertScaleAbs");
	$dst->Zero;
	$img->CvtScaleAbs(-dst => $dst, -scale => $scale, -shift => $shift);
	is($img->GetD([100, 100])->[0], $val, "CvtScaleAbs(src)");
	is($dst->GetD([100, 100])->[0], abs($val*$scale + $shift), "CvtScaleAbs");

	eval { $img->ConvertScaleAbs(-dst => $dst, -scale => undef) };
	like($@, qr/usage:/, "ConvertScaleAbs(usage)");
}

# ------------------------------------------------------------
#  AbsDiff - Calculates absolute difference between two arrays
# ------------------------------------------------------------
{
	my $img1 = Cv->new($size, IPL_DEPTH_8U, 3);
	my $img2 = Cv->new($size, IPL_DEPTH_8U, 3);
	my @val1 = (rand_int(100), rand_int(100), rand_int(100));
	my @val2 = (rand_int(100), rand_int(100), rand_int(100));
	my @pos = (rand_int(100), rand_int(100));
	$img1->Set(\@val1);
	$img2->Set(\@val2);
	my $dst = $img1->AbsDiff(-src2 => $img2);
	ok( $dst->GetD(\@pos)->[0] == abs($val1[0] - $val2[0]) &&
		$dst->GetD(\@pos)->[1] == abs($val1[1] - $val2[1]) &&
		$dst->GetD(\@pos)->[2] == abs($val1[2] - $val2[2]), "AbsDiff");

	eval { $img1->AbsDiff };
	like($@, qr/usage:/, "ConvertScaleAbs(usage)");
}


# ------------------------------------------------------------
#  CvtColor -  Converts image from one color space to another
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $gray = $img->CvtColor(CV_RGB2GRAY);
	my $color = $gray->CvtColor(CV_GRAY2RGB);
	is($gray->channels, 1, "CvtColor(CV_RGB2GRAY)");
	is($color->channels, 3, "CvtColor(CV_GRAY2RGB)");

	eval { $gray->CvtColor };
	like($@, qr/usage:/, "CvtColor(usage)");
}

# ------------------------------------------------------------
#   Flip - Flip a 2D array around vertical, horizontal or both axises
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	for (-1..1) {
		my $flip = $img->Flip($_);
		ok($flip, "Flip($_)");
	}
	eval { $img->Flip(-flip_mode => undef) };
	like($@, qr/usage:/, "Flip(usage)");
}

# ------------------------------------------------------------
#   Split - Divides multi-channel array into several single-channel
#           arrays or extracts a single channel from the array
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $r = Cv->new(scalar $img->GetSize, $img->depth, 1);
	my $g = $r->clone;
	my $b = $r->clone;
	$img->Split(-dst0 => $r, -dst1 => $g, -dst2 => $b);
	ok($r, "Split(dst0)");
	ok($g, "Split(dst1)");
	ok($b, "Split(dst2)");

	$img->Split(-dst => [$r, $g, $b]);
	ok($r, "Split(dst0)");
	ok($g, "Split(dst1)");
	ok($b, "Split(dst2)");

	eval { $img->Split };
	like($@, qr/usage:/, "Split(usage)");
}

# ------------------------------------------------------------
#   Merge - Composes multi-channel array from several single-channel
#           arrays or inserts a single channel into the array
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $dst = Cv->new(scalar $img->GetSize, $img->depth, 3);
	my $r = Cv->new(scalar $img->GetSize, $img->depth, 1);
	my $g = $r->clone;
	my $b = $r->clone;
	$img->Split(-dst0 => $r, -dst1 => $g, -dst2 => $b);
	$dst->Merge(-src0 => $r, -src1 => $g, -src2 => $b);
	ok($dst, "Merge");

	$dst->Merge(-src => [$r, $g, $b]);
	ok($dst, "Merge");

	eval { $img->Merge };
	like($@, qr/usage:/, "Merge(usage)");
}

# ------------------------------------------------------------
#   LUT - Performs look-up table transform of array
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $gray = $img->CvtColor(CV_RGB2GRAY)->CvtColor(CV_GRAY2RGB);
	my $lut = Cv::Mat->new(-rows => 1, -cols => 256, -type => CV_8UC3);
	foreach my $i (0 .. 31) {
		my $c0 = 4.0968*$i; my $c1 = $c0 + $c0;
		my $c2 = 255 - $c1; my $c3 = 255 - $c0;
		my $c4 = 127 - $c0; my $c5 = 128 + $c0;
		$lut->SetD([ 32*0 + $i ], [ $c1,  0 ,  0  ]);
		$lut->SetD([ 32*1 + $i ], [ 255, $c1,  0  ]);
		$lut->SetD([ 32*2 + $i ], [ $c2, 255,  0  ]);
		$lut->SetD([ 32*3 + $i ], [  0 , 255, $c1 ]);
		$lut->SetD([ 32*4 + $i ], [  0 , $c3, 255 ]);
		$lut->SetD([ 32*5 + $i ], [  0 , $c4, 255 ]);
		$lut->SetD([ 32*6 + $i ], [ $c0, $c0, 255 ]);
		$lut->SetD([ 32*7 + $i ], [ $c5, $c5, 255 ]);
	}
	my $thermo = $gray->LUT(-lut => $lut);
	ok($thermo, "LUT");
	$thermo->ShowImage->WaitKey(1000);

	eval { $gray->LUT };
	like($@, qr/usage:/, "LUT(usage)");
}


# ============================================================
#  Image Filtering
# ============================================================

# ------------------------------------------------------------
#   Smoothes the image in one of several ways
# ------------------------------------------------------------
{
	my $img = Cv->LoadImage($lena);
	my $smooth = $img->Smooth;
	ok($smooth, "Smooth");
#	my $no_scale  = $img->Smooth(-smoothtype => CV_BLUR_NO_SCALE);
#	ok($no_scale, "Smooth(CV_BLUR_NO_SCALE)");
	my $blur      = $img->Smooth(-smoothtype => CV_BLUR);
	ok($blur, "Smooth(CV_BLUR)");
	my $gaussian  = $img->Smooth(-smoothtype => CV_GAUSSIAN);
	ok($gaussian, "Smooth(CV_GAUSSIAN)");
	my $median    = $img->Smooth(-smoothtype => CV_MEDIAN);
	ok($median, "Smooth(CV_MEDIAN)");
	my $bilateral = $img->Smooth(-smoothtype => CV_BILATERAL);
	ok($bilateral, "Smooth(CV_BILATERAL)");

	eval { $img->Smooth(-smoothtype => undef) };
	like($@, qr/usage:/, "Smooth(usage)");
}

