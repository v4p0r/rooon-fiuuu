#!/usr/bin/perl

# by v4p0r - low - 26 jan 2018 
# discord: https://discord.gg/wFEBgDC

use strict;
use warnings;
use IO::Socket::PortState qw(check_ports);
&main;

sub ipgen {
    return my $ip = join ('.',(int(rand(255)),int(rand(255)),int(rand(255)),int(rand(255))));
}

sub check_conect {

    my %portas = (
        tcp => {
            22 => {}, 
            3389 => {},
        }
    );

    while () {

        my $i = &ipgen;
        my $h = check_ports($i, 5, \%portas);

        for my $p (sort {$a <=> $b} keys %{$h->{tcp}}) {
            my $s = $h->{tcp}{$p}{open} ? 'Porta aberta' : 'Porta fechada';
            print "[!] ". $i ." - ". $p ." - ". $s."\n";
        }

    }

}

sub banner {

    print "\n------------------------------------\n".
          "---  SSH and RDP Scanner - Port  ---\n".
          "------------------------------------\n\n";
          
}

sub main {
    &banner;
    &check_conect;
}