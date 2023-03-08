#!/bin/bash
# SSR Setup
# Edition : Stable Edition V1.0
# Auther  : AWALUDIN FERIYANTO
# (C) Copyright 2021-2022 By fsidvpn
# =========================================

# // Exporting Language to UTF-8
export LC_ALL='en_US.UTF-8' >/dev/null 2>&1
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

# // Take VPS IP & Network Interface
MYIP2="s/xxxxxxxxx/$IP/g"
NET=$(ip route show default | awk '{print $5}')

# // Make SSR Server Main Directory
rm -r -f /etc/${Auther}/ssr-server
mkdir -p /etc/${Auther}/ssr-server

# // Installing Requirement Package
apt update -y
apt install vim -y
apt install unzip -y
apt install cron -y
apt install git -y
apt install net-tools -y

# // Install Python2
apt install python -y

# // ShadowsocksR Setup
cd /etc/${Auther}/ssr-server/
wget -q -O /etc/${Auther}/ssr-server/SSR-Server.zip "https://${Server_URL}/mantap/SSR-Server.zip"
unzip -o SSR-Server.zip > /dev/null 2>&1
chmod +x jq
rm -f SSR-Server.zip
cp config.json /etc/${Auther}/ssr-server/user-config.json
cp mysql.json /etc/${Auther}/ssr-server/usermysql.json
cp apiconfig.py /etc/${Auther}/ssr-server/userapiconfig.py
sed -i "s/API_INTERFACE = 'sspanelv2'/API_INTERFACE = 'mudbjson'/" /etc/${Auther}/ssr-server/userapiconfig.py
sed -i "s/SERVER_PUB_ADDR = '127.0.0.1'/SERVER_PUB_ADDR = '${IP}'/" /etc/${Auther}/ssr-server/userapiconfig.py
sed -i 's/ \/\/ only works under multi-user mode//g' /etc/${Auther}/ssr-server/user-config.json
cd

# // Enable IPTables
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 3100:3200 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 3100:3200 -j ACCEPT

# // Saving IPTables Configuration
iptables-save > /etc/iptables.up.rules

# // Adding SSR-Server Service
cat > /etc/systemd/system/ssr-server.service << END
[Unit]
Description=ShadowsocksR Server
Documentation=halucok.me
After=network.target

[Service]
user=root
Type=forking
ExecStart=/etc/init.d/ssr-server start
ExecStop=/etc/init.d/ssr-server stop
Restart=always

[Install]
WantedBy=multi-user.target
END

# // Starting Service
systemctl daemon-reload
systemctl enable ssr-server
systemctl start ssr-server

# // Downloading SSR Server Init.d
wget -q -O /etc/init.d/ssr-server "https://${Server_URL}/mantap/ssr-server.init"
chmod +x /etc/init.d/ssr-server
/etc/init.d/ssr-server start

# // Make Client Configuration
cat > /etc/${Auther}/data-shadowsocksr.db << END
# ==================================
# ShadowsocksR User Data Config
# Created By Geo Project
# ==================================

#SSR
END

# // Remove Not Used Files !
rm -f /root/ssr.sh
