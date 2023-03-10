#!/bin/bash
# User Add Vless
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

# // Read User Data
read -p "Username : " Username
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r')"

# // Validate Input
if [[ $Username == "" ]]; then
    echo -e "${EROR} Please Input an Username !"
    exit 1
fi

# // Checking User already on vps or no
if [[ "$( cat /etc/xray-mini/vless-nontls.json | grep -w ${Username})" == "" ]]; then
    Do=Nothing
else
    echo -e "${EROR} User ( ${YELLOW}$Username${NC} ) Already Exists !"
    exit 1
fi

# // Read Expired Date
read -p "Expired  : " Jumlah_Hari

# // Data String
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`

# // Vless Data
domain=$( cat /etc/${Auther}/domain.txt )
port_nontls=$( cat /etc/xray-mini/vless-nontls.json | grep -w port | awk '{print $2}' | sed 's/,//g' )
port_tls=$( cat /etc/xray-mini/vless-tls.json | grep -w port | awk '{print $2}' | sed 's/,//g' )
uuid=$(cat /proc/sys/kernel/random/uuid)
path=$( cat /etc/xray-mini/vless-nontls.json | grep -w path | awk '{print $2}' | sed 's/,//g' | sed 's/"//g' )

# // Input Data User Ke V2Ray Vless NonTLS
sed -i '/#XRay$/a\#DEPAN '"Username : $Username | Expired : $exp"'\
            },{"id": "'""$uuid""'","email": "'""$Username""'"\
#BELAKANG '"Username : $Username | Expired : $exp"'' /etc/xray-mini/vless-nontls.json

# // Input Data User Ke XRay Vless TCP XTLS
sed -i '/#XRay$/a\#DEPAN '"Username : $Username | Expired : $exp"'\
            },{"id": "'""$uuid""'","flow": "'xtls-rprx-direct'","email": "'""$Username""'"\
#BELAKANG '"Username : $Username | Expired : $exp"'' /etc/xray-mini/vless-tls.json

# // Link Configration
https="vless://${uuid}@${domain}:${port_tls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct&sni=example.com#$Username"
http="vless://${uuid}@${domain}:${port_nontls}?path=${path}&security=none&encryption=none&host=example.com&type=ws#$Username"
https2="vless://${uuid}@${domain}:${port_tls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-splice&sni=example.com#$Username"
https3="vless://${uuid}@${domain}:${port_tls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-splice-udp443&sni=example.com#$Username"
https4="vless://${uuid}@${domain}:${port_tls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-direct-udp443&sni=example.com#$Username"

# // Restarting XRay For Vless
systemctl restart xray-mini@vless-nontls
systemctl restart xray-mini@vless-tls

# // Success
sleep 1
clear
clear && clear && clear
clear;clear;clear
echo -e "Your Premium Vless Details"
echo -e "==============================="
echo -e " Remarks     = ${Username}"
echo -e " IP          = ${IP}"
echo -e " Address     = ${domain}"
echo -e " Port HTTP   = ${port_nontls}"
echo -e " Port HTTPS  = ${port_tls}"
echo -e " User ID     = ${uuid}"
echo -e " HTTPS Sec   = xtls"
echo -e " HTTP Sec    = websocket"
echo -e " ReqHost     = example.com"
echo -e " Path HTTP   = ${path}"
echo -e "==============================="
echo -e " TLS VLESS DIRECT LINK"
echo -e " ${https}"
echo -e "==============================="
echo -e " TLS VLESS SPLICE LINK"
echo -e " ${https2}"
echo -e "==============================="
echo -e " TLS VLESS DIRECT UDP 443 LINK"
echo -e " ${https4}"
echo -e "==============================="
echo -e " TLS VLESS SPLICE UDP 443 LINK"
echo -e " ${https3}"
echo -e "==============================="
echo -e " HTTP VLESS CONFIG LINK"
echo -e " ${http}"
echo -e "==============================="
echo -e " Created     = ${hariini}"
echo -e " Expired     = ${exp}"
echo -e "==============================="???
