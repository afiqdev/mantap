#!/bin/bash
# Port Changer Manager
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

# // Exporting RED_BG
export RED_BG='\e[41m'

# // Clear
clear
clear && clear && clear
clear;clear;clear

echo -e "${RED_BG}              IPTables Pointing / VPS Pointing            ${NC}"
echo -e "${GREEN} 1${YELLOW})${NC}. Create New Pointing"
echo -e "${GREEN} 2${YELLOW})${NC}. Delete an Pointing"
echo -e "${GREEN} 3${YELLOW})${NC}. List Pointing"
echo ""
read -p "Input Your Choose : " chooseme


case ${chooseme} in
1) # //Pointing
read -p "IP VPS Target   : " ip_target
read -p "Port VPS Target : " port_target
read -p "New Port Opened : " new_port

echo "1" > /proc/sys/net/ipv4/ip_forward # >> Enableing IPV4 Forward
iptables -t nat -A PREROUTING -p tcp --dport ${new_port} -j DNAT --to-destination ${ip_target}:${port_target}
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -t nat -A PREROUTING -p udp --dport ${new_port} -j DNAT --to-destination ${ip_target}:${port_target}
iptables -t nat -A POSTROUTING -j MASQUERADE

# // Clear
clear
clear && clear && clear
clear;clear;clear

# // Succesfull
echo -e "${OKEY} Successfull Pointing ${IP}:${new_port} to ${ip_target}:${port_target}"
;;
2) # Delete Pointing
clear
iptables -t nat -v -L PREROUTING -n --line-number
echo ""
read -p "Type Which Line Of Pointing want you deleted : " line
iptables -t nat -D PREROUTING $line
clear
echo -e "${OKEY} Successfull Deleted Line $line"
;;
3) # List Pointing
clear
iptables -t nat -v -L PREROUTING -n --line-number
;;
*) # Eror Select
    echo -e "${EROR} Please Input Your Choose"
    sleep 2
    vps-pointing
;;
esac
