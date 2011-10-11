# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::SparseMat;

use 5.008008;
use strict;
use warnings;

use Cv::SparseMat::Ghost;
use Cv::Arr;
our @ISA = qw(Cv::Arr);

BEGIN {
	Cv::aliases(
		[ 'cvCloneSparseMat', 'Clone' ],
		);
}

sub new {
	my $self = shift;
	my $sizes = @_ && ref $_[0] eq 'ARRAY'? shift : $self->sizes;
	my $type = @_? shift : $self->type;
	Cv::cvCreateSparseMat($sizes, $type);
}

1;
__END__
