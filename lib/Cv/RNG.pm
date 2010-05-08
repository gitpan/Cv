# -*- mode: perl; coding: utf-8; tab-width: 4; -*-

package Cv::RNG;

use 5.008000;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed);
use Data::Dumper;

BEGIN {
	$Data::Dumper::Terse = 1;
}

use Cv::Constant;
use Cv::CxCore qw(:all);

our $VERSION = '0.03';

# ======================================================================
#  2.9. Random Number Generation
# ======================================================================

# ------------------------------------------------------------
#  RNG - Initializes random number generator state
# ------------------------------------------------------------
sub new {
    my $class = shift;
	my %av = argv([ -seed => -1,
				  ], @_);
	bless cvRNG(pack("q", $av{-seed})), $class;
}

sub DESTROY {
	my $self = shift;
	cvReleaseRNG($self);
}


# ------------------------------------------------------------
#  RandArr - Fills array with random numbers and updates the RNG state
# ------------------------------------------------------------
sub RandArr {
	my $self = shift;
	my %av = argv([ -arr => undef,
					-dist_type => undef,
					-param1 => undef,
					-param2 => undef,
					-rng => $self,
				  ], @_);
	unless (defined $av{-rng} && blessed $av{-rng} &&
			blessed $av{-arr} &&
			defined $av{-dist_type} &&
			defined $av{-param1} &&
			defined $av{-param2}) {
		chop(my $usage = <<"----"
usage:	Cv->RandArr(
	-rng => RNG state initialized by cvRNG. 
	-arr => The destination array. 
	-dist_type => Distribution type:
	        CV_RAND_UNI - uniform distribution
	        CV_RAND_NORMAL - normal or Gaussian distribution
	-param1 => The first parameter of distribution. In case of uniform
	        distribution it is the inclusive lower boundary of random numbers
	        range.  In case of normal distribution it is the mean value of
	        random numbers.
	-param2 => The second parameter of distribution. In case of uniform
	        distribution it is the exclusive upper boundary of random numbers
	        range. In case of normal distribution it is the standard deviation
	        of random numbers.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvRandArr(
		$av{-rng},
		$av{-arr},
		$av{-dist_type},
		pack("d4", @{$av{-param1}}),
		pack("d4", @{$av{-param2}}),
		);
	$av{-arr};
}


# ------------------------------------------------------------
#  RandInt - Returns 32-bit unsigned integer and updates RNG
# ------------------------------------------------------------
sub RandInt {
	my $self = shift;
	my %av = argv([ -rng => $self,
				  ], @_);
	unless (defined $av{-rng} && blessed $av{-rng}) {
		chop(my $usage = <<"----"
usage:	Cv->RandInt(
	-rng => RNG state initialized by RandInit and, optionally, customized by
	        RandSetRange (though, the latter function does not affect on the
	        discussed function outcome).
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvRandInt($av{-rng});
}

# ------------------------------------------------------------
#  RandReal - Returns floating-point random number and updates RNG
# ------------------------------------------------------------
sub RandReal {
	my $self = shift;
	my %av = argv([ -rng => $self,
				  ], @_);
	unless (defined $av{-rng} && blessed $av{-rng}) {
		chop(my $usage = <<"----"
usage:	Cv->RandReal(
	-rng => RNG state initialized by cvRNG.
	)
----
			);
		croak $usage, " = ", &Dumper(\%av);
	}
	cvRandReal($av{-rng});
}

1;
