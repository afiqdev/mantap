#!/bin/bash
# User Renew SSH / OPENVPN
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

# // Input Username
read -p "Username : " Username

# // Checking User Avaiable Or No
if [[ $( cat /etc/shadow | cut -d: -f1,8 | sed /:$/d | grep -w $Username ) == "" ]]; then
    clear
    clear && clear && clear
    clear;clear;clear
    echo -e " ${RED}❌${NC} User ( ${YELLOW}$Username${NC} ) Not Exists !"
    exit 1
else
read -p "Expired  : " Days

# // String For Date Details
Today=`date +%s`
Total_Penambahan=$(( $Days * 86400 ))
Expired_Pada=$(($Today + $Total_Penambahan))
Expired_Counted_1=$(date -u --date="1970-01-01 $Expired_Pada sec GMT" +%Y/%m/%d)
Expired=$(date -u --date="1970-01-01 $Expired_Pada sec GMT" '+%Y-%m-%d')

# // Change Expired Date On Server
passwd -u $Username > /dev/null 2>&1
usermod -e $Expired_Counted_1 $Username > /dev/null 2>&1
egrep "^$User" /etc/passwd > /dev/null 2>&1
echo -e "$Pass\n$Pass\n"|passwd $User > /dev/null 2>&1

# // Clear
clear
clear && clear && clear
clear;clear;clear

# // Successfull
echo -e " ${GREEN}✅${NC} User ( ${YELLOW}${Username}${NC} ) Renewed Then Expired On ( ${YELLOW}$Expired${NC} )"

fi
