# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Mat::Ghost;

use 5.008008;
use strict;
use warnings;

use Cv::Mat;
our @ISA = qw(Cv::Mat);

sub DESTROY {
}

1;
__END__