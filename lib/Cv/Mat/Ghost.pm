# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Mat::Ghost;
use lib qw(blib/lib blib/arch);

use 5.008000;
use strict;
use warnings;

use Cv::Mat;
our @ISA = qw(Cv::Mat);

sub DESTROY {
}

1;
