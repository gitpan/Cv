# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
use 5.008008;
use ExtUtils::MakeMaker;

use lib './lib';
use Cv::Config;

my $cf = new Cv::Config;

{
	use ExtUtils::Constant qw (WriteConstants);
	*{ExtUtils::Constant::Base::macro_to_ifdef} = sub {
		my ($self, $macro) = @_;
		if (ref $macro) {
			return $macro->[0];
		}
		if (defined $macro && $macro ne "" && $macro ne "1") {
			# return $macro ? "#ifdef $macro\n" : "#if 0\n";
			return $macro ? "#if 1 /* $macro */\n" : "#if 0\n";
		}
		return "";
	};
	require "lib/Cv/Constant.pm";
	my %names = map { $_ => 1 } map { @{ $Cv::Constant::EXPORT_TAGS{$_} } }
		grep { $_ <= $cf->version } keys %Cv::Constant::EXPORT_TAGS;
	ExtUtils::Constant::WriteConstants(
		NAME => 'Cv', NAMES => [ keys %names ], DEFAULT_TYPE => 'IV',
		);
}
	
my @perl_h = qw(perl.h sv.h pp.h);

{
	use Config;
	my $CORE = join('/', $Config{archlib}, 'CORE');
	foreach my $h (@perl_h) {
		if (open(PHI, "<$CORE/$h")) {
			open(PHO, ">lib/Cv/$h");
			while (<PHI>) {
				s/\bstruct\s+cv\b/struct STRUCT_CV/g;
				s/\bNORMAL\b/pl_NORMAL/g;
				print PHO;
			}
			close PHO;
			close PHI;
		}
	}
}

WriteMakefile(
	NAME => 'Cv',
	VERSION_FROM => 'lib/Cv.pm', # finds $VERSION
	PREREQ_PM => {
		Data::Dumper => 0,
		Scalar::Util => 0,
		File::Basename => 0,
		List::Util => 0,
		Time::HiRes => 0,
		Cwd => 0,
		ExtUtils::PkgConfig => 0,
	}, # e.g., Module::Name => 1.1
	($] >= 5.005 ?     ## Add these new keywords supported since 5.005
	 (ABSTRACT_FROM => 'lib/Cv.pm', # retrieve abstract from module
	  AUTHOR => 'MASUDA Yuta <yuta.masuda@newdaysys.co.jp>') : ()),
	LIBS => $cf->libs, # e.g., '-lm'
	CC => $cf->cc,
	LD => $cf->cc,
	XSOPT => '-C++ -hiertype',
	TYPEMAPS => $cf->typemaps,
	CCFLAGS => $cf->ccflags,
	MYEXTLIB => 'xlib/libxs$(LIB_EXT)',
	dynamic_lib => $cf->dynamic_lib,
	INC => "-I.",		# e.g., '-I. -I/usr/include/other'
	clean => {
		FILES => [
			'const-c.inc', 'const-xs.inc',
			'_Inline', 'cover_db', 'camera.xml', '*.tmp',
			map { "lib/Cv/$_" } @perl_h,
			] },
	);

sub MY::postamble {
	"
Cv.xs:	Cv-c.inc Cv-xs.inc.tmp lib/Cv/typemap.h
Cv-xs.inc.tmp:	Cv-xs.inc Makefile.PL
	perl -lpe 's/\\bvoid\\s*\\*/VOID*/g' Cv-xs.inc >\$@

cover:
	cover -delete
	-HARNESS_PERL_SWITCHES=-MDevel::Cover make test
	cover
	find cover_db -type d |xargs chmod +rx

\$(MYEXTLIB): xlib/Makefile
	cd xlib && \$(MAKE) \$(PASSTHRU)

Makefile.PL: lib/Cv/Constant.pm lib/Cv/Config.pm

";
}
