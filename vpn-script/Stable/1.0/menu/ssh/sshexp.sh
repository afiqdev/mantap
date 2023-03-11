#!/bin/bash
# User SSH / OPENVPN Auto Expired
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

# // Clear Expired User
clear
hariini=`date +%d-%m-%Y`
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /etc/${Auther}/akun-ssh.db
totalaccounts=`cat /etc/${Auther}/akun-ssh.db | wc -l` 
echo "Total Akun = $totalaccounts" > /etc/${Auther}/total-akun-ssh.db
for((i=1; i<=$totalaccounts; i++ ))
do
    tuserval=`head -n $i /etc/${Auther}/akun-ssh.db | tail -n 1`
    username=`echo $tuserval | cut -f1 -d:`
    userexp=`echo $tuserval | cut -f2 -d:`
    userexpireinseconds=$(( $userexp * 86400 ))
    tglexp=`date -d @$userexpireinseconds`             
    tgl=`echo $tglexp |awk -F" " '{print $3}'`
while [ ${#tgl} -lt 2 ]
do
    tgl="0"$tgl
done
while [ ${#username} -lt 15 ]
do
    username=$username" " 
done
    bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
    echo "echo 'User : $username | Expired : $tgl $bulantahun'" >> /etc/${Auther}/ssh-user-cache.db
    algoritmakeys="Expired_User"
    Data=$( cat /etc/${Auther}/ssh-user-cache.db )
    hashsuccess="$(echo -n "$Data" | sha256sum | cut -d ' ' -f 1)" 
    Sha256Successs="$(echo -n "$hashsuccess$algoritmakeys" | sha256sum | cut -d ' ' -f 1)"
    echo "$Sha256Successs" > /etc/${Auther}/ssh-user-controller.db
    echo "$(base64 -d /etc/${Auther}/ssh-user-controller.db)" > /etc/${Auther}/ssh-user-controller.db
    todaystime=`date +%s`
if [ $userexpireinseconds -ge $todaystime ]; then
    SKip="true"
else
    echo "Username : $username | Expired : $tgl $bulantahun | Deleted $hariini" >> /etc/${Auther}/ssh-expired-deleted.db
    echo "Username : $username | Expired : $tgl $bulantahun | Deleted $hariini"
    userdel -f $username
fi
done
