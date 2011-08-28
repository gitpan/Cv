# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
package Cv::Config;

use strict;
use Cwd qw(abs_path);
use ExtUtils::PkgConfig;

our %opencv;
our %C;
our $cf;

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

sub which {
	my @PATH = split(':', $ENV{PATH});
	my @found = ();
	for my $f (@_) {
		for my $d (@PATH) {
			my $g = "$d/$f";
			$g =~ s{[ ()]}{\\$&}g;
			$g .= '.exe' if $^O eq 'cygwin';
			push(@found, grep { -x $_ } glob("$g"));
			return @found if @found;
		}
	}
	@found;
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
		unless ($self->{CC} = $ENV{CXX} || $ENV{CC}) {
			my @cc = which(qw(g++4? g++4 g++-4? g++-4 g++ c++));
			$self->{CC} = shift(@cc);
		}
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
		# warn "Compiling $c to get Cv version.\n";
		my $CC = $self->cc;
		my $CCFLAGS = $self->ccflags;
		my $LIBS = '';
		if ($^O eq 'cygwin') {
			if (my $libs = $self->libs) {
				$LIBS = join(' ', @{$self->libs});
			}
		}
		if (open C, ">$c") {
			print C <<"----";
#include <stdio.h>
#include <opencv/cv.h>
main() {
	printf("%.6lf\\n",
		   CV_MAJOR_VERSION
		   + CV_MINOR_VERSION    * 1e-3
		   + CV_SUBMINOR_VERSION * 1e-6);
}
----
	;
			close C;
			# warn "$CC $CCFLAGS -o a.exe $c $LIBS\n";
			chop(my $v = `$CC $CCFLAGS -o a.exe $c $LIBS && ./a.exe`);
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
	%opencv = ExtUtils::PkgConfig->find('opencv');
	$cf = &new;
	%C = $cf->c;
}

1;
