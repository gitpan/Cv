# -*- mode: perl; coding: utf-8; tab-width: 4; -*-
use 5.008008;
use ExtUtils::MakeMaker;

my %with = (
	IMGPROC => 1, FEATURES2D => 1, FLANN => 1, OBJDETECT => 1,
	VIDEO => 1, HIGHGUI => 1, QT => 0, CALIB3D => 1, ML => 1,
	CONTRIB => 1,
	);
foreach (keys %with) {
	$with{$_} = $ENV{$_} if defined $ENV{$_};
}

use lib "./lib";
use Cv::Config;
use Cv::Constant;

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
	my %names = map { $_ => 1 } map { @{ $Cv::Constant::EXPORT_TAGS{$_} } }
		grep { $_ <= $cf->version } keys %Cv::Constant::EXPORT_TAGS;
	ExtUtils::Constant::WriteConstants(
		NAME => 'Cv', NAMES => [ keys %names ], DEFAULT_TYPE => 'IV',
		);
}

my @perl_h = qw(perl.h sv.h pp.h);
my @perl_h_patched = ();

{
	use Config;
	my $CORE = join('/', $Config{archlib}, 'CORE');
	foreach my $h (@perl_h) {
		if (open(PHI, "<$CORE/$h")) {
			my $patched = "lib/Cv/$h";
			open(PHO, ">$patched");
			while (<PHI>) {
				s/\bstruct\s+cv\b/struct STRUCT_CV/g;
				s/\bNORMAL\b/Perl_NORMAL/g;
				print PHO;
			}
			close PHO;
			close PHI;
			push(@perl_h_patched, $patched);
		}
	}
}

WriteMakefile(
	NAME => 'Cv',
	VERSION_FROM => "lib/Cv.pm", # finds $VERSION
	PREREQ_PM => {
		Data::Dumper => 0,
		Scalar::Util => 0,
		File::Basename => 0,
		List::Util => 0,
		Time::HiRes => 0,
		ExtUtils::PkgConfig => 1.12,
		ExtUtils::ParseXS => 2.22,
		Cwd => 0,
	},
	ABSTRACT_FROM => "lib/Cv.pm",
	AUTHOR => 'MASUDA Yuta <yuta.masuda@newdaysys.co.jp>',
	LIBS => $cf->libs,
	CC => $cf->cc,
	LD => $cf->cc,
	XSOPT => '-C++ -hiertype',
	TYPEMAPS => $cf->typemaps,
	CCFLAGS => $cf->ccflags,
    DEFINE => join(' ', map { "-DWITH_$_=$with{$_}" } keys %with),
	MYEXTLIB => 'xlib/libxs$(LIB_EXT)',
	dynamic_lib => $cf->dynamic_lib,
	INC => "-I.",
	clean => {
		FILES => [
			'const-c.inc', 'const-xs.inc',
			'_Inline', 'cover_db', 'camera.xml',
			'sample.avi',
			@perl_h_patched,
			] },
	);

sub MY::postamble {
	my $cv_inc = join(' ', glob("Cv-*.inc const-*.inc"));
	"
Cv.xs:	lib/Cv/typemap.h $cv_inc

const-c.inc const-xs.inc: lib/Cv/Constant.pm

cover:
	cover -delete
	-HARNESS_PERL_SWITCHES=-MDevel::Cover make test
	cover
	find cover_db -type d |xargs chmod +rx

\$(MYEXTLIB):
	cd xlib && \$(MAKE) \$(PASSTHRU)

";
}
