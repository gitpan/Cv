# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::MatND::Ghost;

use 5.008008;
use strict;
use warnings;

use Cv::MatND;
our @ISA = qw(Cv::MatND);

sub DESTROY {
}

1;
__END__
