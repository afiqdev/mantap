#!/bin/bash
# User Trial PPTP
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

# // Input Data
Username="Trial-$( </dev/urandom tr -dc 0-9A-Z | head -c4 )"

# // Checking User already on vps or no
if [[ "$( grep "^#DEPAN_PPTP " "/etc/ppp/chap-secrets" | cut -d ' ' -f 4 | grep -w  ${Username} )" == "" ]]; then
    Do=Nothing
else
    echo -e "${EROR} User ( ${YELLOW}$Username${NC} ) Already Exists !"
    exit 1
fi

# // Pasword & Expired Days
password="123"
Jumlah_Hari="1"

# // Data String
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`
domain=$( cat /etc/${Auther}/domain.txt )

# // Input Client to server
sed -i '/#PPTP$/a\#DEPAN_PPTP '"Username : $Username | Expired : $exp"'\
"'"$Username"'" pptpd "'"$password"'" * \
#BELAKANG_PPTP '"Username : $Username | Expired : $exp"'' /etc/ppp/chap-secrets

# Update file attributes
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*

# // Clear
clear
clear && clear && clear
clear;clear;clear

# // Info
echo -e "Your Trial PPTP Details"
echo -e "==============================="
echo -e " Address     = ${domain}"
echo -e " IP          = ${IP}"
echo -e " Username    = ${Username}"
echo -e " Password    = ${password}"
echo -e "==============================="
echo -e " Created     = ${hariini}"
echo -e " Expired     = ${exp}"
echo -e "==============================="????????????
