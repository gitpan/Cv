use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

chop(my $libs = `pkg-config opencv --libs`);
die "cannot find opencv library." unless $libs;
chop(my $ccflags = `pkg-config opencv --cflags`);
$ccflags =~ s/(-I[\w\/]*)\/opencv/$1/;

WriteMakefile(
    NAME              => 'Cv',
    VERSION_FROM      => 'lib/Cv.pm', # finds $VERSION
    PREREQ_PM         => {
	Data::Dumper => 2.121,
	Scalar::Util => 1.18,
	File::Basename => 2.71,
	List::Util => 1.19,
	Time::HiRes => 1.9707,
	Test::File => 1.29,
	Test::More => 0,
	Test::Output => 0.12,
	Test::Number::Delta => 0,
    }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Cv.pm', # retrieve abstract from module
       AUTHOR         => 'MASUDA Yuta <yuta.masuda@newdaysys.co.jp>') : ()),
    LIBS              => [ $libs ], # e.g., '-lm'
    CCFLAGS           => $ccflags,
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
    clean             => { FILES => [ '_Inline', 'cover_db' ] },
);

sub MY::postamble {
<<"----";
cover:
	#cover -delete
	-HARNESS_PERL_SWITCHES=-MDevel::Cover make test
	cover
----
}
