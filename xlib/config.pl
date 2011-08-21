our %with = (QT => 0);

chop($libs = `pkg-config opencv --libs 2>/dev/null`);
die "cannot find opencv library" unless $libs && $? == 0;

chop(our $home = `pwd`);
chop($ccflags = "-I$home " . `pkg-config opencv --cflags`);
$ccflags =~ s/(-I[\w\/]*)\/opencv/$1/;

our $cc = 'c++';
foreach ($^O eq 'freebsd' ? qw(g++44 g++45 g++46) : (),
	 $^O eq 'cygwin' ? qw(g++-4) : (),
	 $cc) {
    `which $_`;
    if ($? == 0) {
	$cc = $_;
	last;
    }
}

1;
