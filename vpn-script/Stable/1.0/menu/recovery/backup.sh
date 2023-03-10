#!/bin/bash
# VPS User Data Recovery ( Backup )
# Edition : Stable Edition V1.0
# Auther  : AWALUDIN FERIYANTO
# (C) Copyright 2021-2022 By FSIDVPN
# =========================================

# // Exporting Language to UTF-8
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'
export LC_CTYPE='en_US.utf8'

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Exporting URL Host
export Server_URL="vpnkuy.site"
export Server_Port="443"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther="GeoVPN"

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Exporting IP Address
export IP=$( curl -sS ipinfo.io/ip )

# // Exporting Network Interface
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')"
# // Clear
clear
clear && clear && clear
clear;clear;clear

# // Email Requirement
if [[ $( cat /etc/${Auther}/email.json | head -n1 | awk '{print $1}' ) == "" ]]; then
    echo -e "${EROR} Please Setup Email For Backup Data"
    exit 1
fi

# // Exporting Email For Backup Data
export email_bk=$( cat /etc/${Auther}/email.json | head -n1 | awk '{print $1}' )

# // Nama
nama=$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep -w $Your_License_Key | head -n1 | cut -d ' ' -f 9-100 )

# // Backup Client Data
rm -r -f /Backup
mkdir -p /Backup
cd /Backup

# // Backup Wireguard
cp -r /etc/wireguard/ /Backup/wireguard

# // Backup SSH
cp /etc/passwd /Backup/passwd
cp /etc/group /Backup/group
cp /etc/shadow /Backup/shadow
cp /etc/gshadow /Backup/gshadow

# // Backup Vmess, Vless, Shadowsocks, Trojan
cp -r /etc/xray-mini/ /Backup/xray-mini

# // Backup PPTP & L2TP & SSTP
cp /etc/ppp/chap-secrets /Backup/chap-secrets
cp /etc/ipsec.d/passwd /Backup/ipsec-passwd
cp /etc/${Auther}/SSTP-Server/client.db /Backup/sstp-client.db

# // Backup SSR
cp -r /etc/${Auther}/ssr-server/ /Backup/ssr-server/

# // Adding Readme For Version Backup
cat > /Backup/version.dv << END
:: Start String
:: Data On String
:: Auther GeoVPN
:: Key GeoVPN
:: Secret Data ********
:: Restore yes
:: Backup yes
:: Extend yes
:: Expired no
:: Lock Server ID no
:: Linux yes
:: Windows no
:: Building Encryption Key
:: Crack no
:: Secured true
:: QC yes
:: Bypass no
:: Owner GeoVPN
:: Hostname ${HOSTNAME}
:: IPV4 ${IPV4}
:: IPV6 ${IPV6}
:: SC VERSION $(cat /etc/${Auther}/version.db | head -n1 | awk '{print $1}')
:: Sha256 true
:: Sha512 true
:: OpenSSL true
:: Key Version 1.3
:: DV Encryption 1.3
END

date=$(date +"%Y-%m-%d")
zip -r ${IP}-${date}.zip /Backup/* > /dev/null 2>&1
rclone copy "${IP}-${date}.zip" GeoVPN:/Backup # >> Backup To Google Drive
url=$(rclone link GeoVPN:/Backup/${IP}-${date}.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)

export Random_Number=$( </dev/urandom tr -dc 1-$( curl -s https://${Server_URL}/mantap/akun-smtp.txt | grep -E Jumlah-Notif | cut -d " " -f 2 | tail -n1 ) | head -c1 )
export email=$( curl -s https://${Server_URL}/mantap/akun-smtp.txt | grep -E Notif$Random_Number | cut -d " " -f 2 | tr -d '\r')
export password=$( curl -s https://${Server_URL}/mantap/akun-smtp.txt | grep -E Notif$Random_Number | cut -d " " -f 3 | tr -d '\r')

# // Import SMTP Account
cat > /etc/msmtprc << END
defaults
port 587
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
auth on
logfile        ~/.msmtp.log

account        GeoVPN
host           smtp.gmail.com
port           587
from           Your Backup Is Ready
user           $email
password       $password
account default : GeoVPN
END

date2=$(date +"%X")

# // Send ke email
echo " 
Halo, $nama

Indoensia Version ????????
Berikut Merupakan Data Backup anda
====================================

IP Address     : ${IP}
Tanggal Backup : ${date}
Waktu Backup   : ${date2}
Backup ID      : ${id}

==============
Salam Hangat,
Geo Project

======================================

English Version ????????
Here is Your Backup Data From VPS
====================================

IP Address     : ${IP}
Date           : ${date}
Time           : ${date2}
Backup ID      : ${id}

==============
Salam Hangat,
Geo Project

" | mail -s "Backup Server Data" $email_bk

# // Remove Not Used File
rm -f /etc/msmtprc
rm -f ~/.msmtp.log
rm -r -f /Backup

# // Clear
clear
clear && clear && clear
clear;clear;clear

echo " Your Backup Is Ready"
echo "====================================="
echo " This Is Your Backup ID"
echo " IP    = ${IP}"
echo " Date  = ${date}"
echo " ID    = ${id}"
echo "====================================="
echo ""?????????????????????????????????
