# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::Image::Ghost;
use lib qw(blib/lib blib/arch);

use 5.008000;
use strict;
use warnings;

use Cv::Image;

our @ISA = qw(Cv::Image);

sub DESTROY {
}

1;
