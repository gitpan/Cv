# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Image::Ghost;

use 5.008008;
use strict;
use warnings;

use Cv::Image;
our @ISA = qw(Cv::Image);

sub DESTROY {
}

1;
__END__