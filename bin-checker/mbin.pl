#!/usr/bin/perl

# Create Date: 30 set 2017 - update: 28 jun 2018
# Greetz: Yunkers Crew && BRLZ PoC && EOF Club && All Friends

use strict;
use warnings;
use Getopt::Long;
use WWW::Mechanize;

$|++;

&main;

sub onebin {

    &banner;
    my ($bin, $file) = @_;
    
    print "[x] Salvas em: " . $file . "\n\n" .
        "=============================================\n";
    
    my @info = request($bin);

    my $x = "BIN: " . uc($info[0]) . "\n" . "PAIS: " . uc($info[1]) . "\n" . "CODE: " . uc($info[3]) . "\n" . "BANCO: " . uc($info[4]) . "\n" .
        "URL: " . uc($info[5]) . "\n" . "TEL: " . $info[6] . "\n" . "BANDEIRA: " . uc($info[10]). "\n" . "TIPO: " . uc($info[8]) . "\n" .
        "SUB: " . uc($info[9]) . "\n" . "=============================================";

    print $x;
    savefile($file, $x);        
    
}

sub mass {

    &banner;
    my ($list, $file) = @_;
    my @results = openfile($list);
    
    print "[x] Lista a ser checada: " . $list . "\n" .
        "[x] Salvas em: " . $file . "\n" .
        "[x] " . scalar(@results) . " Quantidade de bins a ser checkadas\n\n" .
        "=============================================\n";

    foreach my $bin (@results) {
    
        my ($bin) = $bin =~ /(\d{6})/;
        my @info = request($bin);
        
        my $x = "BIN: " . uc($info[0]) . " | " . "PAIS: " . uc($info[1]) . " | " . "CODE: " . uc($info[3]) . " | " . "BANCO: " . uc($info[4]) . " | " .
            "URL: " . uc($info[5]) . " | " . "TEL: " . $info[6] . " | " . "BANDEIRA: " . uc($info[10]). " | " . "TIPO: " . uc($info[8]) . " | " .
            "SUB: " . uc($info[9]) . "\n" . "=============================================\n";
                
        print $x;
        savefile($file, $x);

    }
    
}

sub request {

    my $bin = shift;
    my @result;

    my $mech = WWW::Mechanize->new();
       $mech->get("https://www.cardbinlist.com/search.html?bin=" . $bin);
 
    my @gext = $mech->content =~ /text.xs.left(.*)col.half.left/smi;
    my @paxs = $gext[0] =~ /<td><a href=".*">(.*?)<\/a><\/td>/;
    my @infx = $gext[0] =~ /<\/th>.*?<td>(.*?)<\/td>/gsm;
    my @bxnd = $infx[5] =~ />(.*)</;
    
    push @result, $bin, @paxs, @infx, @bxnd;
    return @result;

}

sub openfile {

    my $file = shift;
    open(my $open, '<', $file) or die "\n [Lista nao selecionada]";
    my @result = <$open>;
    return @result;
    
}

sub savefile {

    my ($file, $save) = @_;
    open(my $fh, '>>', $file);
    print $fh $save;
    close $fh;    
    
}

sub help {

    &banner;
    print "[x] Usage: " . $0 . " [comando]\n" .
        "[x] Comandos:\n\n" .
        "  --bin  or -b [Checa apenas 1 bin]\n" .
        "  --help or -h [Ajuda com os comandos]\n" .
        "  --list or -l [Seleciona sua lista de bin a ser checada]\n" .
        "  --save or -s [Onde as bins serao salvas]\n" .
        "               [Default: bin_list.txt]\n" .
        "[x] Exemplos:\n\n" .
        "  perl " . $0 . " --list list.txt --save bins_check.txt\n" .
        "  perl " . $0 . " --bin 553624\n";
    
}

sub about {

    &banner;
    print "Coder: v4p0r\n" .
        "Team: Yunkers Crew && BRLZ PoC\n" .
        "Twitter: 0x777null" .
        "Skype: drx.priv\n\n" .
        "Usage: perl " . $0 . " --help\n";
        
}

sub banner {

    print "================================\n" .
        "        Mass Bin Checker\n" .
        "================================\n\n";
    
}

sub main {

    &about if (($#ARGV + 1) == 0);
    my($list, $bin, $file);
    GetOptions(
        'list|l=s' => \$list,
        'bin|b=s'  => \$bin,
        'save|s=s' => \$file,
        'help|h'   => \&help
    );    

    $file ? ($file = $file) : ($file = "bin_check.txt");

    if ($bin) {
        ($bin) = $bin =~ /(\d{6})/ or die "[x] Define a bin ae amigo, min 6 digitos";
        onebin($bin, $file);
    }

    if (defined($list)) {
        mass($list, $file);
    }
    
}