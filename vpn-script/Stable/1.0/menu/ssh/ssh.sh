#!/bin/bash
# SSH Manager
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


echo -e "${RED_BG}              SSH / OpenVPN Account Manager               ${NC}"
echo -e "${GREEN} 1${YELLOW})${NC}. Create Account"
echo -e "${GREEN} 2${YELLOW})${NC}. Delete Account"
echo -e "${GREEN} 3${YELLOW})${NC}. Renew Account"
echo -e "${GREEN} 4${YELLOW})${NC}. Create Trial Account"
echo -e "${GREEN} 5${YELLOW})${NC}. Clean ALL Expired Account"
echo -e "${GREEN} 6${YELLOW})${NC}. Check User Login"
echo -e "${GREEN} 7${YELLOW})${NC}. Check Member List / User List"
echo ""
read -p "Please Input Your Choose : " choosemu
case $choosemu in
    1) # // Add Account
        addssh
    ;;
    2) # // Delete Account
        delssh
    ;;
    3) # // Renew Account
        renewssh
    ;;
    4) # // Create Trial Account
        trialssh
    ;;
    5) # // Clean Expired Account
        sshexp
    ;;
    6) # // Check User Login
        sshlogin
    ;;
    7) # // Check Member List
        userssh
    ;;
    *) # // Wrong Choose
        echo -e "${EROR} Please Choose One"
        sleep 2
        ssh-manager
    ;;
esac
