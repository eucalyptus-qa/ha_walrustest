#!/usr/bin/perl

require "ec2ops.pl";

$component_to_switch = shift @ARGV || "CLC";

parse_input();
print "SUCCESS: parsed input\n";

open(OFH, ">../status/current_roles");
foreach $comp (keys(%masters)) {
    print OFH "MASTER $comp $masters{$comp}\n";
}
foreach $comp (keys(%slaves)) {
    print OFH "SLAVE $comp $slaves{$comp}\n";
}
close(OFH);

doexit(0, "EXITING SUCCESS\n");

