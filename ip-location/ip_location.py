#!/usr/bin/python

'''
	IP Location and Mass IP Location
	Respect:  YC - HighTech - EOF Club - Brian - d3m0l1d0r - Cater - Strike - rCent - b33ck
             Kodo - pr0s3x - CrazyDuck - xin0x - mmxm - CriptonKing - d3z3n0v3 - c0de_universal - All Friends
'''

import requests
import json
import argparse as arg
import sys
import os as sistema

sistema.system("cls" if sistema.name == "nt" else "reset")

parser = arg.ArgumentParser()
parser.add_argument("-i", "--ip",
                    action="store",
                    help="Select target IP")
parser.add_argument("-l", "--list",
                    action="store",
                    help="Select target IP list")
parser.add_argument("-s", "--save",
                    action="store",
                    help="Select where the tested ips will be saved")
param = parser.parse_args()

menu = """
       *                  ((((        *       *
*            *        *  (((
       *    Coded       (((      *
  *   / \      *   by  *(((           *
   __/___\__  *          (((
    | (O) |    v4p0r *    ((((                  *
* __| :-: |__ ... .. .             *.     ... .
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 # IP Location and Mass IP Location v1
 # Coder: v4p0r
 # Team: Yunkers Crew
 # Skype: drx.priv
 # Twitter: 0x777null
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 # [+] Usage:
 # python ip_location.py --help
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"""

banner_single = """
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 # Search IP
 # I hope this helps you
 # By v4p0r
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"""

banner_mass = """
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 # Search IP List
 # I hope this helps you
 # By v4p0r
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"""

if len(sys.argv) == 1:
    print(menu)
    exit()

def main():

    if param.list:
        print(banner_mass)
        arquivo = open(param.list)
        lines = arquivo.readlines()
        lines = [ip.replace("\n", "") for ip in lines]

        for ip in lines:
            searchIP(ip)

    else:
        print(banner_single)
        searchIP(param.ip)

def searchIP(ip):

    info = requestIP(ip)
    if info["status"] != "fail" or None:
        result = infoIP(info)
        print(result)
        lista = []
        lista.append(result)

        if param.save:
            save_resultados(lista)
    else:
        print("[!] Error")

def requestIP(ip):
    try:
        url = "http://ip-api.com/json/{}" . format(ip)
        req = requests.get(url)
        ret = json.loads(req.text)
        return ret
    except IndexError:
        return None

def save_resultados(lista):
    print("[*] Save results...\n\n::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
    file = open(param.save, "a")
    file = [file.write(str(x_ip) + "\n") for x_ip in lista]
    return file

def infoIP(info):
    return "\n[+] IP: {} \n[+] ORG: {}\n[+] ISP: {}\n[+] AS: {}\n[+] COUNTRY CODE: {}\n[+] COUNTRY: {}\n[+] REGION: {}\n[+] REGION NAME: {}\n[+] CITY: {}\n[+] TIME ZONE: {}\n[+] LATITUDE: {}\n[+] LONGITUDE: {}\n".format(info["query"], info["org"], info["isp"], info["as"], info["countryCode"], info["country"], info["region"], info["regionName"], info["city"], info["timezone"], info["lat"], info["lon"])

try:
    main()
except KeyboardInterrupt:
    exit()