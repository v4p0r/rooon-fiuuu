#!/usr/bin/perl

# Filtrar valores unicos de uma lista
# Velocidade: Mediana
# Feito por: v4p0r 
# Gretzz: all friends

use strict;
use warnings;

my $list = $ARGV[0];
my $help = "perl $0 <list.txt> \n";

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

print   "================================================\n" .
        " #       Filtrar valores unicos de uma lista    \n" .
        " #                Coder: v4p0r                  \n" .
        "================================================\n\n";
        
die $help unless $list;

open (my $wolf,'<',$list) or die "[-] Lista nao encontrada amigao\n";
my @filter = <$wolf>;
my @filtered = uniq(@filter);

print "[!] Lista: " . $list . "\n";
print "[!] Carregados: " . scalar(@filter) . "\n";
print "[!] Filtrados: " . scalar(@filtered) . "\n\n";

foreach my $one(@filtered) {

    open(my $fh, '>>', 'filtrado.txt');
    print $fh "$one";
    close $fh;

}

print "[!] Lista filtrada :)\n";