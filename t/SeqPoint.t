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


if (1) {
	my $stor = new Cv::MemStorage(8192);
	#use Data::Dumper;
	#print STDERR Data::Dumper->Dump([$stor], [qw($stor)]);
	ok($stor->isa('Cv::MemStorage'));
}

if (2) {
	my $stor = Cv::MemStorage->new(8192);
	#use Data::Dumper;
	#print STDERR Data::Dumper->Dump([$stor], [qw($stor)]);
	ok($stor->isa('Cv::MemStorage'));
}

if (3) {
	my $stor = new Cv::MemStorage;
	ok($stor->isa('Cv::MemStorage'));
	use Cv::Seq::Point;
	my $seq = new Cv::Seq::Point(0, $stor);
	ok($seq->isa('Cv::Seq::Point'));
	# my $type_name = Cv::cvTypeOf($seq)->type_name;
	# print STDERR $type_name, "\n";

	$seq->Push([0, 1], [2, 3]);
	my $p = $seq->Shift;
	is($p->[0], 0);
	is($p->[1], 1);
	my $q = $seq->Shift;
	is($q->[0], 2);
	is($q->[1], 3);
}

if (4) {
	my $stor = new Cv::MemStorage;
	ok($stor->isa('Cv::MemStorage'));
	use Cv::Seq::Point;
	my $seq = new Cv::Seq::Point(0, $stor);
	ok($seq->isa('Cv::Seq::Point'));
	$seq->Unshift([0, 1], [2, 3]);
	my $p = $seq->Pop;
	is($p->[0], 0);
	is($p->[1], 1);
	my $q = $seq->Pop;
	is($q->[0], 2);
	is($q->[1], 3);
}
