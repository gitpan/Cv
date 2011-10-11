# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::MatND;

use 5.008008;
use strict;
use warnings;

use Cv::MatND::Ghost;
use Cv::Arr;
our @ISA = qw(Cv::Arr);

BEGIN {
	Cv::aliases(
		[ 'cvClearMatND', 'Clear' ],
		[ 'cvCloneMatND', 'Clone' ],
		);
}

sub new {
	my $self = shift;
	my $sizes = @_ && ref $_[0] eq 'ARRAY'? shift : $self->sizes;
	my $type = @_? shift : $self->type;
	if (@_) {
		my $data = shift;
		Cv::cvCreateMatNDHeader($sizes, $type);
	} else {
		Cv::cvCreateMatND($sizes, $type);
	}
}

1;
__END__
