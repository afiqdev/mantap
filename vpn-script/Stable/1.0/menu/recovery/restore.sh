#!/bin/bash
# VPS User Data Recovery ( Restore )
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

read -p "Backup ID : " idmu
if [[ $idmu == "" ]]; then
    echo -e "${EROR} Please input Backup ID"
    exit 1
fi

link="https://drive.google.com/u/4/uc?id=${idmu}&export=download"
wget -q -O /root/cache.zip $link
unzip -o /root/cache.zip > /dev/null 2>&1
cd /root/Backup/
cp passwd /etc/passwd
cp group /etc/group
cp shadow /etc/shadow
cp gshadow /etc/gshadow
cp ipsec-passwd /etc/ipsec.d/passwd
cp chap-secrets /etc/ppp/chap-secrets
cp -r xray-mini /etc/xray-mini
cp -r wireguard /etc/wireguard
cp -r ssr-server /etc/${Auther}/ssr-server
cp sstp-client.db /etc/${Auther}/SSTP-Server/sstp-client.db
cd 
rm -r -f /root/Backup/

# // Clear
clear
clear && clear && clear
clear;clear;clear
rm -f /root/cache.zip
rm -r -f /root/Backup

# // Done
echo -e "${OKEY} Successfull Restored Your Data !"
echo ""
echo -e "${YELLOW}Tips${NC}: Restart Your VPS After Restored Backup !"
echo ""??????
