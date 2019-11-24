#!/usr/bin/perl

# 24 nov 2019 - 17:10 - v4p0r

use strict;
use warnings;
use Getopt::Long;
use WWW::Mechanize;

$|++;

&main;

sub help {

    &banner;
    print "[x] usage: " . $0 . " [command]\n" .
        "[x] commands:\n\n" .
        "  --cookies or -c [set cookies]\n" .
        "  --help or -h [display help]\n" .
        "  --save or -s [set save list]\n" .
        "               [Default: alexa.txt]\n" .
        "[x] examples:\n\n" .
        "  perl " . $0 . " -c 'cookies; bla; bla;' -s alex4.txt\n";
    
}

sub banner {

    system(($^O eq 'MSWin32') ? 'cls' : 'clear');
    print "==============================================\n" .
          " Alexa dumper top sites (auth) by v4p0r 2k19  \n" .
          "==============================================\n\n";
    
}


sub main {

    return &help if (($#ARGV + 1) == 0);
    
    my($cookies, $file, @result);
    GetOptions(
        'cookies|c=s'  => \$cookies,
        'save|s=s' => \$file,
        'help|h'   => \&help
    );  

    return &help if (!$cookies);
    
    &banner;
    $file ? ($file = $file) : ($file = "alexa.txt");

    for (my $i = 0; $i <= 19; $i++) {
        my $content = request('https://www.alexa.com/topsites/global;' . $i, $cookies);
        my @parse   = parse_content($content);
        push(@result, @parse)
    }

    savefile($file, $_) foreach(@result);

}

sub savefile {

    my ($file, $save) = @_;
    print $save . "\n";
    open(my $fh, '>>', $file);
    print $fh $save . "\n";
    close $fh;    
    
}

sub parse_content {

    my $content = shift;
    my $regex   = qr/td\">(\d{1,}).*?\<a href="\/siteinfo\/(.*?)"/smp;
    my @return;

    while ($content =~ /$regex/g) {
        push(@return, "$1 - $2")
    }
    
    return @return;

}

sub request {

    my ($url, $cookies) = @_;
    my @result;
    
    my $mech = WWW::Mechanize->new();
       $mech->add_header('Cookie' => $cookies);
       $mech->get($url);

    return $mech->content;

}

