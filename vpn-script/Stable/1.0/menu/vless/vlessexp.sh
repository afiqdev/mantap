#!/bin/bash
# User Vless Auto Expired
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

# // String For User Data Option
grep -c -E "^#DEPAN " "/etc/xray-mini/vless-nontls.json" > /etc/${Auther}/jumlah-akun-vless.db
grep "^#DEPAN " "/etc/xray-mini/vless-nontls.json" | cut -d ' ' -f 4  > /etc/${Auther}/akun-vless.db
totalaccounts=`cat /etc/${Auther}/akun-vless.db | wc -l` 
echo "Total Akun = $totalaccounts" > /etc/${Auther}/total-akun-vless.db
for((i=1; i<=$totalaccounts; i++ ))
do
    # // Username Interval Counting
    username=`head -n $i /etc/${Auther}/akun-vless.db | tail -n 1`
    expired=$( cat /etc/xray-mini/vless-nontls.json | grep -w $username | head -n1 | awk '{print $8}' )

    # // Counting On Simple Algoritmatika
    now=`date -d "0 days" +"%Y-%m-%d"`
    d1=$(date -d "$expired" +%s)
    d2=$(date -d "$now" +%s)
    sisa_hari=$(( (d1 - d2) / 86400 ))

    # // String For Do Task
    client="$username"
    expired="$expired"

# // Validate Use If Syntax
if [[ $sisa_hari -lt 1 ]]; then
    # // Removing Data From Server Configuration
    sed -i "/^#DEPAN Username : $client | Expired : $expired/,/^#BELAKANG Username : $client | Expired : $expired/d" /etc/xray-mini/vless-tls.json
    sed -i "/^#DEPAN Username : $client | Expired : $expired/,/^#BELAKANG Username : $client | Expired : $expired/d" /etc/xray-mini/vless-nontls.json

    # // Restarting XRay Service
    systemctl daemon-reload
    systemctl restart xray-mini@vless-nontls
    systemctl restart xray-mini@vless-tls

    # // Successfull Deleted Expired Client
    echo "Username : $username | Expired : $expired | Deleted $now" >> /etc/${Auther}/vless-expired-deleted.db
    echo "Username : $username | Expired : $expired | Deleted $now"

else
    Skip="true"
fi

# // End Function
done??????
