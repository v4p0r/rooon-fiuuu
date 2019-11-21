#!/usr/bin/perl
# Proxy List Checker by v4p0r
# Made in Brazil niggas 2k17
# greetz: YC - EOF Club - BRLZPoCC - All Friends

use Getopt::Long;
use LWP::UserAgent;
use strict;

my $distro; 
my $usr = $^O;

if ($usr eq "MSWin32") {
    system("cls");
} else {
    system("clear");
}

my $banner = @ARGV;
print "\n-------------------------\n" .
      "      Proxy Checker      \n" .
      "-------------------------\n";

my $optList;
my $optSave;
my $optUrl;
my $optTime;
my $optHelp;
my $rTime;
my $rAlvo;

GetOptions(
    'list|l=s' => \$optList,
    'url|u=s'  => \$optUrl,
    'time|t=s' => \$optTime,
    'save|s=s' => \$optSave,
    'help|h'   => \$optHelp
);

if ($optHelp) { 
    print "Usage: $0 [comando]\n" .
          "[+] Comandos:\n" .
          "--help [Ajuda com os comandos]\n" .
          "--list [Seleciona sua lista de proxys]\n" .
          "--url  [Url na hora de dar o GET]\n" .
          "       [Defaut http://google.com]\n" .
          "--time [Tempo de resposta]\n" .
          "       [Defaut 15]\n" .
          "--save [Onde as proxys boas serao salvas]\n\n" .
          "[!] Exemplos:\n" .
          "perl $0 --list list.txt --url http://myhost.com --time 10 --save god_proxys.txt\n" .
          "perl $0 --list list.txt --save god_proxys.txt\n";
    exit;
}

if ($optUrl) { 
    if ($optUrl) {    
        $rAlvo = $optUrl;
    } else {
        die "$0: url invalida.\n";
    }
} else {
    $rAlvo = "http://google.com";
}

if ($optTime) { 
    if ($optTime =~ /^\d+$/) {    
        $rTime = $optTime;
    } else {
        die "$0: tempo invalido.\n";
    }
} else {
    $rTime = "15";
}

if($banner <= 1){

    print "\nCoder: v4p0r\n" .
    "Team: Yunkers Crew && BRLZ PoC\n" .
    "Twitter: 0x777null".
    "Skype: drx.priv\n\n" .
    "Usage: perl $0 --help\n";
    exit;

}
  
open(my $list1,'<', $optList); 
my @proxy1 = <$list1>;

print "[+] Site: " . $rAlvo . "\n";
print "[+] Time: " . $rTime . "\n";
print "[+] " . scalar(@proxy1) . " Quantidade de proxy a ser checada\n\n";

foreach my $prxs (@proxy1) {

    my $ua = LWP::UserAgent->new;
       $ua->timeout($rTime);

    my $proxy = "http://".$prxs;
       $ua->proxy('http', $proxy);
   
    my $resposta = $ua->get($rAlvo);
    
    if ($resposta->is_success) {
        print "[+] God Proxys: $prxs";
        open(my $fh, '>>', $optSave);
        print $fh "$prxs";
        close $fh;
    } else {
        print "[-] Fail Proxys: $prxs";
    }
    
}
