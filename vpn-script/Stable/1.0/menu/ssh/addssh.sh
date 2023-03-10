#!/bin/bash
# User Add SSH / OPENVPN
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
read -p "Username : " Username
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )"

# // Validate Input
if [[ $Username == "" ]]; then
    echo -e "${EROR} Please Input an Username !"
    exit 1
fi

# // Validate User Exists
if [[ $( cat /etc/shadow | cut -d: -f1,8 | sed /:$/d | grep -w $Username ) == "" ]]; then
    Skip="true"
else
    clear
    clear && clear && clear
    clear;clear;clear
    echo -e "${EROR} User ( ${YELLOW}$Username${NC} ) Already Exists !"
    exit 1
fi

read -p "Password : " Password
read -p "Expired  : " Jumlah_Hari

# // String For IP & Port
DOMAIN=$( cat /etc/${Auther}/domain.txt )
openssh=$( cat /etc/ssh/sshd_config | grep -E Port | head -n1 | awk '{print $2}' )
dropbear1=$( cat /etc/default/dropbear | grep -E DROPBEAR_PORT | sed 's/DROPBEAR_PORT//g' | sed 's/=//g' | sed 's/"//g' |  tr -d '\r' )
dropbear2=$( cat /etc/default/dropbear | grep -E DROPBEAR_EXTRA_ARGS | sed 's/DROPBEAR_EXTRA_ARGS//g' | sed 's/=//g' | sed 's/"//g' | awk '{print $2}' |  tr -d '\r' )
ovpn_tcp="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn_udp="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
if [[ $ovpn_tcp == "" ]]; then
    ovpn_tcp="Eror"
fi
if [[ $ovpn_udp == "" ]]; then
    ovpn_udp="Eror"
fi
stunnel_dropbear=$( cat /etc/stunnel5/stunnel5.conf | grep -i accept | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $1}' | tr -d '\r' )
stunnel_openssh=$( cat /etc/stunnel5/stunnel5.conf | grep -i accept | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $2}' | tr -d '\r' )
stunnel_ovpn_tcp=$( cat /etc/stunnel5/stunnel5.conf | grep -i accept | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $3}' | tr -d '\r' )
ssh_ssl=$( cat /lib/systemd/system/sslh.service | grep -w ExecStart | head -n1 | awk '{print $6}' | sed 's/0.0.0.0//g' | sed 's/://g' | tr '\n' ' ' | tr -d '\r' )
ssh_nontls=$( cat /etc/${Auther}/ws-epro.conf | grep -i listen_port |  head -n 4 | cut -d= -f2 | sed 's/ //g' | sed 's/listen_port//g' | sed 's/://g' | tr '\n' ' ' | awk '{print $1}' | tr -d '\r' )
ovpn_nontls_tcp=$( cat /etc/${Auther}/ws-epro.conf | grep -i listen_port |  head -n 4 | cut -d= -f2 | sed 's/ //g' | sed 's/listen_port//g' | sed 's/://g' | tr '\n' ' ' | awk '{print $2}' | tr -d '\r' )
ovpn_tls_tcp=$( cat /etc/${Auther}/ws-epro.conf | grep -i listen_port |  head -n 4 | cut -d= -f2 | sed 's/ //g' | sed 's/listen_port//g' | sed 's/://g' | tr '\n' ' ' | awk '{print $3}' | tr -d '\r' )
squid1=$( cat /etc/squid/squid.conf | grep http_port | head -n 3 | cut -d= -f2 | awk '{print $2}' | sed 's/ //g' | tr '\n' ' ' | awk '{print $1}' )
squid2=$( cat /etc/squid/squid.conf | grep http_port | head -n 3 | cut -d= -f2 | awk '{print $2}' | sed 's/ //g' | tr '\n' ' ' | awk '{print $2}' )
squid3=$( cat /etc/squid/squid.conf | grep http_port | head -n 3 | cut -d= -f2 | awk '{print $2}' | sed 's/ //g' | tr '\n' ' ' | awk '{print $3}' )
ohp_1="$( cat /etc/systemd/system/ohp-mini-1.service | grep -i Port | awk '{print $3}' | head -n1)"
ohp_2="$( cat /etc/systemd/system/ohp-mini-2.service | grep -i Port | awk '{print $3}' | head -n1)"
ohp_3="$( cat /etc/systemd/system/ohp-mini-3.service | grep -i Port | awk '{print $3}' | head -n1)"
ohp_4="$( cat /etc/systemd/system/ohp-mini-4.service | grep -i Port | awk '{print $3}' | head -n1)"
udp_1=$( cat /etc/systemd/system/udp-mini-1.service | grep -i listen-addr | awk '{print $3}' | head -n1 | sed 's/127.0.0.1//g' | sed 's/://g' | tr -d '\r' )
udp_2=$( cat /etc/systemd/system/udp-mini-2.service | grep -i listen-addr | awk '{print $3}' | head -n1 | sed 's/127.0.0.1//g' | sed 's/://g' | tr -d '\r' )
udp_3=$( cat /etc/systemd/system/udp-mini-3.service | grep -i listen-addr | awk '{print $3}' | head -n1 | sed 's/127.0.0.1//g' | sed 's/://g' | tr -d '\r' )
today=`date -d "0 days" +"%Y-%m-%d"`

# // Adding User To Server
useradd -e `date -d "$Jumlah_Hari days" +"%Y-%m-%d"` -s /bin/false -M $Username
echo -e "$Password\n$Password\n"|passwd $Username &> /dev/null
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`

# // Success
sleep 1
clear
clear && clear && clear
clear;clear;clear
echo -e "========================"
echo -e "Your Premium VPN Details"
echo -e "========================"
echo -e " IP Address       = ${IP}"
echo -e " Hostname         = ${DOMAIN}"
echo -e " Username         = ${Username}"
echo -e " Password         = ${Password}"
echo -e "========================"
echo -e " OpenSSH          = ${openssh}"
echo -e " Dropbear         = ${dropbear1}, ${dropbear2}"
echo -e " Stunnel          = ${ssh_ssl}, ${stunnel_openssh}"
echo -e " SSH WS TLS       = ${ssh_ssl}"
echo -e " SSH WS NTLS      = ${ssh_nontls}"
#echo -e " OVPN TCP         = ${ovpn_tcp}"
#echo -e " OVPN UDP         = ${ovpn_udp}"
#echo -e " OVPN SSL         = ${stunnel_ovpn_tcp}"
echo -e " OVPN WS NTLS TCP = ${ovpn_nontls_tcp}"
echo -e " OVPN WS TLS TCP  = ${ovpn_tls_tcp}"
echo -e " Squid Proxy 1    = ${squid1}"
echo -e " Squid Proxy 2    = ${squid2}"
echo -e " Squid Proxy 3    = ${squid3}"
echo -e " OHP              = OpenSSH ${ohp_1}, Dropbear ${ohp_2}, OpenVpn ${ohp_3}"
echo -e " OHP Universal    = ${ohp_4}"
echo -e " BadVPN UDP       = ${udp_1}, ${udp_2}, ${udp_3}"
echo -e "========================"
echo -e " Payload WebSocket NonTLS"
echo -e " GET / HTTP/1.1[crlf]Host: ${DOMAIN}[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "========================"
echo -e " Payload WebSocket TLS"
echo -e " GET wss://example.com [protocol][crlf]Host: ${DOMAIN}[crlf]Upgrade: websocket[crlf][crlf]"
echo -e "========================"
echo -e " Link OVPN TCP    = http://${IP}:85/tcp.ovpn"
echo -e " Link OVPN UDP    = http://${IP}:85/udp.ovpn"
echo -e " Link SSL TCP     = http://${IP}:85/ssl.ovpn"
echo -e " Link OVPN CONFIG = http://${IP}:85/all.zip"
echo -e "========================"
echo -e " Created = $today"
echo -e " Expired = $exp"
echo -e "========================"
