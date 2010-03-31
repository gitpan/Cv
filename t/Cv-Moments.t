# -*- mode: perl; coding: utf-8; tab-width: 4 -*-

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Cv.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More qw(no_plan);
#use Test::More tests => 11;
BEGIN { use_ok('Cv') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my ($cx, $cy) = (100, 100);
my $src = Cv->CreateImage([320, 240], 8, 3)->Zero;
$src->Rectangle(-pt1 => [$cx-50, $cy-50], -pt2 => [$cx+50, $cy+50],
				-color => 'white', -thickness => -1);

my $fn = Cv->InitFont;

# linear
my $sz = $src->GetSize;
my $pi = atan2(1, 1)*4;
foreach my $i (0..10) {
	my $angle = $i/10 * $pi;
	my $affine = $src->Affine( [ [ 1, 0, $cx+$i*5 ],
								 [ 0, 1, $cy+$i*5 ], ]);
	&print_moment($affine);
	$affine->ShowImage;
	$affine->WaitKey(500);
}


# rotate
#my $sz = $src->GetSize;
#my $pi = atan2(1, 1)*4;
foreach my $i (0..10) {
	my $angle = $i/10 * $pi;
	my $affine = $src->Affine( [ [ +cos($angle), -sin($angle), $cx ],
								 [ +sin($angle), +cos($angle), $cy ], ]);
	&print_moment($affine);
	$affine->ShowImage;
	$affine->WaitKey(500);
}

# scaling
foreach my $i (0..10) {
	my $affine = $src->Affine( [ [ ($i+1), 0, $cx ],
								 [ 0, ($i+1), $cy ], ]);
	&print_moment($affine);
	$affine->ShowImage;
	$affine->WaitKey(500);
}

sub print_moment {
	my $img = shift;
	my $m = $img->Moments(-binary => 1);
	# print STDERR Data::Dumper->Dump([$m], [qw($m)]);
	my $spatial = $m->GetSpatialMoment(-x_order => 0, -y_order => 0);
	my $central = $m->GetCentralMoment(-x_order => 0, -y_order => 0);
	my $norm = $m->GetNormalizedCentralMoment(-x_order => 0, -y_order => 0);
	my $hu = $m->GetHuMoments;
	# print STDERR Data::Dumper->Dump([$hu], [qw($hu)]);

	my $m00 = $m->m00;
	my $m10 = $m->m10;
	my $m01 = $m->m01;
	my $m20 = $m->m20;
	my $m11 = $m->m11;
	my $m02 = $m->m02;
	my $m30 = $m->m30;
	my $m21 = $m->m21;
	my $m12 = $m->m12;
	my $m03 = $m->m03;
	my $inv_sqrt_m00 = $m->inv_sqrt_m00;
	my ($gx, $gy) = ($m10/$m00, $m01/$m00);

	my @style = (-color => 'red', -font => $fn);
	my ($x, $y, $d) = (20, 20, 13);

	$img
		->PutText(-text => "spatial: $spatial", -org => [$x, $y+$d*0], @style)
		->PutText(-text => "central: $central", -org => [$x, $y+$d*1], @style)
		->PutText(-text => "norm: $norm",       -org => [$x, $y+$d*2], @style)
		->PutText(-text => "hu1: " . $hu->hu1,  -org => [$x, $y+$d*3], @style)
		->PutText(-text => "hu2: " . $hu->hu2,  -org => [$x, $y+$d*4], @style)
		->PutText(-text => "hu3: " . $hu->hu3,  -org => [$x, $y+$d*5], @style)
		->PutText(-text => "hu4: " . $hu->hu4,  -org => [$x, $y+$d*6], @style)
		->PutText(-text => "hu5: " . $hu->hu5,  -org => [$x, $y+$d*7], @style)
		->PutText(-text => "hu6: " . $hu->hu6,  -org => [$x, $y+$d*8], @style)
		->PutText(-text => "hu7: " . $hu->hu7,  -org => [$x, $y+$d*9], @style)
		->PutText(-text => "(gx, gy): ($gx, $gy)", -org => [$x, $y+$d*10], @style);
}
