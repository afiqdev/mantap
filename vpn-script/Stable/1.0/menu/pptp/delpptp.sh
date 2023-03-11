#!/bin/bash
# User Del PPTP
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

# // Getting L2TP Client Data
CLIENT_001=$(grep -c -E "^#DEPAN_PPTP " "/etc/ppp/chap-secrets")
echo "    =================================================="
echo "               LIST PPTP CLIENT ON THIS VPS"
echo "    =================================================="
grep -e "^#DEPAN_PPTP " "/etc/ppp/chap-secrets" | cut -d ' ' -f 2-8 | nl -s ') '
	until [[ ${CLIENT_002} -ge 1 && ${CLIENT_002} -le ${CLIENT_001} ]]; do
		if [[ ${CLIENT_002} == '1' ]]; then
                echo "    =================================================="
			read -rp "    Please Input an Client Number (1-${CLIENT_001}) : " CLIENT_002
		else
                echo "    =================================================="
			read -rp "    Please Input an Client Number (1-${CLIENT_001}) : " CLIENT_002
		fi
	done

# // String For Username && Expired Date
client=$(grep "^#DEPAN_PPTP " "/etc/ppp/chap-secrets" | cut -d ' ' -f 4 | sed -n "${CLIENT_002}"p)
expired=$(grep "^#DEPAN_PPTP " "/etc/ppp/chap-secrets" | cut -d ' ' -f 8 | sed -n "${CLIENT_002}"p)

# // Removing Data From Server Configuration
sed -i "/^#DEPAN_PPTP Username : $client | Expired : $expired/,/^#BELAKANG_PPTP Username : $client | Expired : $expired/d" /etc/ppp/chap-secrets

# // Clear
clear
clear && clear && clear
clear;clear;clear

# // Successfull
echo -e "${OKEY} Username ( ${YELLOW}$client${NC} ) Has Been Removed !"
