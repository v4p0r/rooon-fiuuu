<?php

/*
 * Gerador de Dados by v4p0r
 * Batatinhas and YC forever
 * Data: 05/04/2018 - 01:30
 * My gang: Cater, d3z3n0v3, b33ck, ang33l
 * Greetz: mmxm, xin0x, kodo, anonymous_, code_universal, strike, xuau minha mãe and all friends
 */

$estado_rand = array(
    "AC",
    "AL",
    "AM",
    "AP",
    "BA",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MG",
    "MS",
    "MT",
    "PA",
    "PB",
    "PE",
    "PI",
    "PR",
    "RJ",
    "RN",
    "RS",
    "RO",
    "RR",
    "SC",
    "SE",
    "SP",
    "TO"
);
$estado      = array_rand($estado_rand, 2);

$sexo  = substr(str_shuffle(str_repeat("MH", 1)), 0, 1);
$idade = rand(20, 50);
$url   = "https://www.4devs.com.br/ferramentas_online.php";
$data  = "acao=gerar_pessoa&sexo=" . $sexo . "&idade=" . $idade . "&pontuacao=S&cep_estado=" . $estado_rand[$estado[0]] . "&cep_cidade=";

$pessoa = cURL($url, $data);

echo "/* Pessoa */ <br /><br />";
echo "Nome: " . $pessoa[0][1] . "<br />" . "CPF: " . $pessoa[1][1] . "<br />" . "RG: " . $pessoa[2][1] . "<br />" . "Data de Nascimento: " . $pessoa[3][1] . "<br />" . "Signo: " . $pessoa[4][1] . "<br />" . "Mãe: " . $pessoa[5][1] . "<br />" . "Pai: " . $pessoa[6][1] . "<br />" . "Email: " . $pessoa[7][1] . "<br />" . "Senha: " . $pessoa[8][1] . "<br />" . "CEP: " . $pessoa[9][1] . "<br />" . "Endereço: " . $pessoa[10][1] . "<br />" . "Número: " . $pessoa[11][1] . "<br />" . "Bairro: " . $pessoa[12][1] . "<br />" . "Cidade: " . $pessoa[13][1] . "<br />" . "Estado: " . $pessoa[14][1] . "<br />" . "Telefone: " . $pessoa[15][1] . "<br />" . "Celular: " . $pessoa[16][1] . "<br />" . "Altura: " . $pessoa[17][1] . "<br />" . "Peso: " . $pessoa[18][1] . "<br />" . "Tipo Sanguineo: " . $pessoa[19][1] . "<br />" . "Cor Favorita: " . $pessoa[20][1] . "<br /><br />";

$url  = "https://www.4devs.com.br/ferramentas_online.php";
$data = "acao=gerar_conta_bancaria&estado=" . $estado_rand[$estado[0]] . "&banco=";

$bancaria = cURL($url, $data);

echo "/* Conta Bancária */ <br /><br />";
echo "Banco: " . $bancaria[0][1] . "<br />" . "Cidade: " . $bancaria[1][1] . "<br />" . "Estado: " . $bancaria[2][1] . "<br />" . "Agência de Nascimento: " . $bancaria[3][1] . "<br />" . "Conta Corrente: " . $bancaria[4][1] . "<br /><br />";

$url  = "https://www.4devs.com.br/ferramentas_online.php";
$data = "acao=gerar_veiculo&pontuacao=S&estado=" . $estado_rand[$estado[0]] . "&fipe_codigo_marca=";

$veiculo = cURL($url, $data);

echo "/* Veicúlo */ <br /><br />";
echo "Marca: " . $veiculo[0][1] . "<br />" . "Modelo: " . $veiculo[1][1] . "<br />" . "Ano: " . $veiculo[2][1] . "<br />" . "RENAVAM: " . $veiculo[3][1] . "<br />" . "Placa: " . $veiculo[4][1] . "<br />" . "Cor: " . $veiculo[5][1] . "<br /><br />";

$band_rand = array(
    "visa13",
    "master",
    "amex",
    "discover",
    "diners",
    "enroute",
    "jcb",
    "voyager",
    "elo"
);
$bandeira  = array_rand($band_rand, 2);
$url       = "https://www.4devs.com.br/ferramentas_online.php";
$data      = "acao=gerar_cc&pontuacao=N&bandeira=" . $band_rand[$bandeira[0]];

$cartao = cURL($url, $data);

echo "/* Cartão de Crédito */ <br /><br />";
echo "Número do Cartão: " . $cartao[0][1] . "<br />" . "Data de Validade: " . $cartao[1][1] . "<br />" . "Código Segurança: " . $cartao[2][1] . "<br /><br />";

function cURL($url, $data)
{
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    $curl = curl_exec($ch);
    return regEX($curl);
}

function regEX($curl)
{
    $regex = '/value\=\"(.*?)\"/';
    preg_match_all($regex, $curl, $infos, PREG_SET_ORDER, 0);
    return $infos;
}

?>