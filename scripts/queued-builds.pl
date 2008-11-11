#!/usr/bin/perl
use strict;
use warnings;

system("ssh builder\@farmer.build /usr/abuild/tools/queue-ls > /tmp/queue");
open FILE, "/tmp/queue";

my @parts;
my @builds = <FILE>;
my $output;
close(FILE);

chomp(@builds);
@builds = format_list(@builds);
my $string = join(" <b>|</b> ", @builds);

if ($string eq "EMPTY") {
    print "None";
} else {
    print $string;
}

sub format_list
{
    @builds = shift;
    foreach (@builds) {
        # Take care of phase2 scheduled stuff
        if ($_ =~ m/1\.7\.0/) {
            $_ =~ /.*? .*? (.*)/;
            $_ = "<i>Ph2:</i> $1";
            $_ =~ s/(.*?)\@xandros\.com/$1/;
        }
    }
    return @builds;
}

