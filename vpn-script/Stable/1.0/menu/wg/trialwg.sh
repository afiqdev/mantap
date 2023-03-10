#!/bin/bash
# User Trial Wireguard
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

if [[ $( cat /etc/wireguard/wg0.conf | grep -w $Username ) == "" ]]; then
    Skip=true
else
    echo -e "${EROR} User ( ${YELLOW}$Username${NC} ) Already Exists !"
    exit 1
fi

# // Expired Date
Jumlah_Hari=1
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`

# // Count Expired Date
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`

# // Load Wiregaurd String
source /etc/wireguard/string-data

# // Checknig IP Address
LASTIP=$( cat /etc/wireguard/wg0.conf | grep /24 | tail -n1 | awk '{print $3}' | cut -d "/" -f 1 | cut -d "." -f 4 )
if [[ "$LASTIP" = "" ]]; then
	User_IP="10.10.17.2"
else
	User_IP="10.10.17.$((LASTIP+1))"
fi

# // Client DNS
DNS1=8.8.8.8
DNS2=8.8.4.4

# // Domain Export
Domain=$( cat /etc/${Auther}/domain.txt | awk '{print $1}' )

# // Generate Client Key
User_Priv_Key=$(wg genkey)
User_PUB_Key=$(echo "$User_Priv_Key" | wg pubkey)
User_Preshared_Key=$(wg genpsk);

# // Make Client Config
cat > /etc/${Auther}/wireguard-cache.tmp << END
[Interface]
PrivateKey = ${User_Priv_Key}
Address = ${User_IP}/24
DNS = ${DNS1},${DNS2}

[Peer]
PublicKey = ${PUB}
PresharedKey = ${User_Preshared_Key}
Endpoint = ${Domain}:${PORT}
AllowedIPs = 0.0.0.0/0,::/0
END

# // Input Data User Ke Wireguard Server
cat >> /etc/wireguard/wg0.conf << END
#DEPAN Username : $Username | Expired : $exp
[Peer]
Publickey = ${User_PUB_Key}
PresharedKey = ${User_Preshared_Key}
AllowedIPs = ${User_IP}/24
#BELAKANG Username : $Username | Expired : $exp
END

# // Restarting Service & Copy Client data to webserver
systemctl restart "wg-quick@wg0"
cp /etc/${Auther}/wireguard-cache.tmp /etc/${Auther}/webserver/wg/${Username}.conf

# // Clear
clear
clear && clear && clear
clear;clear;clear

# // Detail
echo -e "Your Trial Wireguard Details"
echo -e "==============================="
echo -e " Username    = ${Username}"
echo -e " IP          = ${IPV4}"
echo -e " Address     = ${Domain}"
echo -e "==============================="
echo -e " Config File = http://${IP}:85/wg/${Username}.conf"
echo -e "==============================="
echo -e " Created     = ${hariini}"
echo -e " Expired     = ${exp}"
echo -e "==============================="
