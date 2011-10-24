# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
package Cv::Config;

use 5.008008;
use strict;
use warnings;
use Carp;
use Cwd qw(abs_path);

our %opencv;
our %C;
our $cf;
our $verbose = 1;

sub new {
	$cf ||= bless {};
	$cf;
}

sub uniq {
	my %used = ();
	my @list = ();
	foreach (@_) {
		unless ($used{$_}) {
			push(@list, $_);
			$used{$_} = 1;
		}
	}
	@list;
}

sub cvdir {
	my $self = shift;
	unless (defined $self->{cvdir}) {
		my $cvdir;
		if (my $myself = $INC{'Cv/Config.pm'}) {
			my @mypath = split(/\/+/, $myself);
			$cvdir = join('/', @mypath[0..$#mypath-1]);
		} else {
			$cvdir = './lib/Cv';
		}
		$self->{cvdir} = abs_path($cvdir);
	}
	$self->{cvdir};
}


sub typemaps {
	my $self = shift;
	my $cvdir = $self->cvdir;
	unless (defined $self->{TYPEMAPS}) {
		my @typemaps = ();
		if (defined $self->{TYPEMAPS}) {
			@typemaps = split(/:/, $self->{TYPEMAPS});
		}
		push(@typemaps, "$cvdir/typemap");
		$self->{TYPEMAPS} = join(':', uniq(@typemaps));
	}
	[ split(/\s+/, $self->{TYPEMAPS}) ];
}


sub cc {
	my $self = shift;
	unless (defined $self->{CC}) {
		$self->{CC} = $ENV{CXX} || $ENV{CC} || 'c++';
	}
	$self->{CC};
}


sub libs {
	my $self = shift;
	unless (defined $self->{LIBS}) {
		my $libs = $opencv{libs};
		$libs =~ s/(^\s+|\s+$)//g;
		$self->{LIBS} = [ $libs ];
	}
	$self->{LIBS};
}


sub dynamic_lib {
	my $self = shift;
	my $cc = $self->cc;
	unless (defined $self->{dynamic_lib}) {
		if (open(CC, "$cc -v 2>&1 |")) {
			my %cf;
			while (<CC>) {
				if (/^Configured with:\s*/) {
					while (/(-[-\w]+)=('[^']*'|[^\s]*)/g) {
						$cf{$1} = $2;
					}
				}
			}
			if (my $rpath = $cf{'--libdir'} || $cf{'--libexecdir'}) {
				$self->{dynamic_lib} = {
					OTHERLDFLAGS => "-Wl,-rpath=$rpath",
				};
			} else {
				$self->{dynamic_lib} = {
				};
			}
			close CC;
		}
	}
	$self->{dynamic_lib};
}


sub ccflags {
	my $self = shift;
	my $cvdir = $self->cvdir;
	unless (defined $self->{CCFLAGS}) {
		my @inc = ("-I$cvdir"); my %inced = ();
		my $ccflags = $opencv{cflags};
		my @ccflags = ();
		if ($? == 0) {
			$ccflags =~ s/(^\s+|\s+$)//g;
			foreach (split(/\s+/, $ccflags)) {
				if (/^-I/) {
					s/(-I[\w\/]*)\/opencv/$1/;
					next if $inced{$_};
					$inced{$_} = 1;
					push(@inc, $_);
				} else {
					push(@ccflags, $_);
				}
			}
		}
		$self->{CCFLAGS} = join(' ', @inc, @ccflags);
	}
	$self->{CCFLAGS};
}


sub version {
	my $self = shift;
	unless (defined $self->{version}) {
		return $self->{version} = Cv::cvVersion()
			if Cv->can('cvVersion');
		my $c = "/tmp/version$$.c";
		warn "Compiling $c to get Cv version.\n"  if $verbose;
		my $CC = $self->cc;
		my $CCFLAGS = $self->ccflags;
		my $LIBS = join(' ', @{$self->libs});
		if (open C, ">$c") {
			print C <<"----";
#include <stdio.h>
#include <opencv/cv.h>
main() {
	printf("%.6lf\\n",
		   CV_MAJOR_VERSION
		   + CV_MINOR_VERSION    * 1e-3
		   + CV_SUBMINOR_VERSION * 1e-6);
	exit(0);
}
----
	;
			close C;
			warn "$CC $CCFLAGS -o a.exe $c $LIBS\n" if $verbose;
			chop(my $v = `$CC $CCFLAGS -o a.exe $c $LIBS && ./a.exe`);
			unless ($? == 0) {
				unlink($c);
				die "$0: can't compile $c to get Cv version.\n",
				"$0: your system has installed opencv?\n";
			}
			if ($v =~ /^\d+\.\d+/) {
				$self->{version} = $& + 0;
			}
			# print STDERR "OpenCV: $version\n";
			unlink($c, 'a.exe');
		}
	}
	$self->{version};
}


sub myextlib {
	my $self = shift;
	unless (defined $self->{MYEXTLIB}) {
		my $extlib;
		foreach (@INC) {
			my $ext = $^O eq 'cygwin' ? ".dll" : ".so";
			my $so = "$_/auto/Cv/Cv$ext";
			if (-x $so) {
				$extlib = abs_path($so);
				last;
			}
		}
		$self->{MYEXTLIB} = $extlib;
	}
	$self->{MYEXTLIB};
}


sub c {
	my $self = shift;
	my %C = (
		CC       => $self->cc,
		LD       => $self->cc,
		CCFLAGS  => $self->ccflags,
		LIBS     => $self->libs,
		MYEXTLIB => $self->myextlib,
		TYPEMAPS => $self->typemaps,
		AUTO_INCLUDE => join("\n", (
								 '#undef do_open',
								 '#undef do_close',
							 )),
		);
	# print STDERR "\$C{$_} = $C{$_}\n" for keys %C;
	%C;
}


BEGIN {
	foreach my $key (qw(cflags libs)) {
		eval {
			chop(my $value = `pkg-config opencv --$key`);
			$opencv{$key} = $value;
		};
		if ($?) {
			warn "=" x 60, "\n";
			warn "See README to install this module\n";
			warn "=" x 60, "\n";
			exit 1;
		}
	}
	$cf = &new;
	%C = $cf->c;
}

1;