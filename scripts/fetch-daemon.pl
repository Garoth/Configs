#!/usr/bin/perl
use strict;
use warnings;

while (1) {
    print "Getting Data.\n";
    system ("/home/garoth/.scripts/queued-builds.pl > /home/garoth/data/queued");
    print "Done: Queued Jobs\n";
    system ("/home/garoth/.scripts/current-builds.pl > /home/garoth/data/current");
    print "Done: Running Jobs\n";
    sleep 5;
}
