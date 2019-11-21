
# Get Proxys www.live-socks.net
# Velocidade: Mediana
# Feito por: v4p0r 
# Data: 19 jan 2018 - 15:16
# Gretzz: YC - Tropa do Cenora - all friends

use strict;
use warnings;
use WWW::Mechanize;

my (@count);

main();

sub request_ {

    my $url = 'http://www.live-socks.net/search?max-results='.'2'; # Altere aqui a quatidade de request aqui
     
    my $mech = WWW::Mechanize->new(agent => "Mozilla 5.0");;
       $mech->timeout(3);
       $mech->max_size(1_024_000);
       $mech->protocols_allowed(['http', 'https']);
      
    my $req = $mech->get($url);
    my $war = $req->decoded_content;

    for my $lulz($war =~ /a href='([^']*).>\d{2}/g) {
        get_proxys($lulz);
    }
    
}

sub get_proxys {

    my ($lulz) = @_;
    
    my $mech = WWW::Mechanize->new(agent => "Mozilla 5.0");;
       $mech->timeout(3);
       $mech->max_size(1_024_000);
       $mech->protocols_allowed(['http', 'https']);
      
    my $req = $mech->get($lulz);
    my $war = $req->decoded_content;

    for my $soul ($war =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{2,5}/gm) {

        push(@count, $soul);

        open(my $fh, '>>', 'soul.txt');
        print $fh "$soul\n";
        close $fh;
        
    }

    @count = grep {!/(255)|^\d+\.\d+\.\d+\.0$/} @count;
    print "[=] [" . scalar(@count) . "] Total de Proxys coletadas\n";

}

sub banner {
    
    print "+--------------------------\n" .
          "# Simples Proxy Scanner    \n" .
          "# Coder by v4p0r           \n" .
          "+--------------------------\n\n";

}

sub main {
    banner();
    request_();
}