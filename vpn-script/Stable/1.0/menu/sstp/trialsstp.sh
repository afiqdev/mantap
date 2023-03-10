#!/bin/bash
# User Trial SSTP
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
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )" # > // Filtering If User Type Space

# // Validate Input
if [[ $Username == "" ]]; then
    echo -e "${EROR} Please Input an Username !"
    exit 1
fi

# // Checking User already on vps or no
if [[ "$( cat /etc/GeoVPN/SSTP-Server/client.db | grep -w ${Username})" == "" ]]; then
    Do=Nothing
else
    echo -e "${EROR} User ( ${YELLOW}$Username${NC} ) Already Exists !"
    exit 1
fi

# // Expired Date
Jumlah_Hari=1
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`

# // Password For Default
Pass=123

# // Getting Domain
Domain=$( cat /etc/${Auther}/domain.txt | cut -d " " -f 1 );
    
# // Getting Port From Config Fsile
port=$( cat /etc/accel-ppp.conf | grep -w port | head -n1 | sed 's/port//g' | sed 's/=//g' | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )

# // Input Data To Server
sed -i '/#SSTP$/a\#DEPAN '"Username : $Username | Expired : $exp"'\
'"${Username} * ${Pass} *"' \
#BELAKANG '"Username : $Username | Expired : $exp" /etc/GeoVPN/SSTP-Server/client.db

# // Success
clear
clear && clear && clear
clear;clear;clear
echo -e "Your Trial SSTP Details"
echo -e "==============================="
echo -e " Remarks     = ${Username}"
echo -e " IP          = ${IP}"
echo -e " Address     = ${Domain}"
echo -e " Username    = ${Username}"
echo -e " Password    = ${Pass}"
echo -e " Certificate = http://${IP}:85/sstp.crt"
echo -e "==============================="
echo -e " Created     = ${hariini}"
echo -e " Expired     = ${exp}"
echo -e "==============================="????????????
