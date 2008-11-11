#!/usr/bin/perl
use strict;
use warnings;

system("ssh builder\@farmer.build /usr/abuild/tools/queue-running-builds > /tmp/running");
open FILE, "/tmp/running";

my @parts;
my @builds = <FILE>;
my $output;
my $string;
close(FILE);

chomp(@builds);
if (@builds) {
    @builds = format_list(@builds);
    my $string = join(" <b>|</b> ", @builds);
    print $string;
} else {
    print "None";
}

sub format_list
{
    @builds = shift;
    foreach (@builds) {
        if ($_ eq "") {
            next;
        }
        # Take care of phase2 scheduled stuff
        if ($_ =~ m/1\.7\.0/) {
            $_ =~ /.*? .*? (.*)/;
            $_ = "<i>Ph2:</i> $1";
            $_ =~ s/(.*?)\@xandros\.com/$1/;
        }
    }
    return @builds;
}

