#!/bin/bash
# Wireguard Setup
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

# // Installing Wireguard Core
OS=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/"//g' | awk '{print $1}' )
if [[ $OS == "ubuntu" ]]; then
	apt update -y
	apt upgrade -y
	apt autoremove -y
	apt install -y wireguard
elif [[ $OS == "debian" ]]; then
	echo "deb http://deb.debian.org/debian/ unstable main" >/etc/apt/sources.list.d/unstable.list
	printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' >/etc/apt/preferences.d/limit-unstable
	apt update -y
	apt upgrade -y
	apt autoremove -y
	apt install -y wireguard-tools
fi

# // Installing Requirement Tools
apt install iptables -y
apt install iptables-persistent -y
apt install wireguard-dkms -y

# // Make Wireguard Directory
mkdir -p /etc/wireguard
chmod 600 -R /etc/wireguard/

# // Generating Wiregaurd PUB Key & WG PRIV Key
PRIV_KEY=$(wg genkey)
PUB_KEY=$(echo "$PRIV_KEY" | wg pubkey)

# // Make Wireguard Config Directory
cat > /etc/wireguard/string-data << END
DIFACE=$NETWORK_IFACE
IFACE=wg0
LOCAL=10.10.17.1
PORT=2048
PRIV=$PRIV_KEY
PUB=$PUB_KEY
END

# // Wireguard Data Load
source /etc/wireguard/string-data

# // Create Server Config
cat > /etc/wireguard/wg0.conf << END
[Interface]
Address = $LOCAL/24
ListenPort = $PORT
PrivateKey = $PRIV
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ${DIFACE} -j MASQUERADE;
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ${DIFACE} -j MASQUERADE;

#WIREGUARD
END

# // Adding Wireguard to IpTables
iptables -t nat -I POSTROUTING -s ${LOCAL}/24 -o ${DIFACE} -j MASQUERADE
iptables -I INPUT 1 -i wg0 -j ACCEPT
iptables -I FORWARD 1 -i ${DIFACE} -o wg0 -j ACCEPT
iptables -I FORWARD 1 -i wg0 -o ${DIFACE} -j ACCEPT
iptables -I INPUT 1 -i ${DIFACE} -p udp --dport ${PORT} -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# // Make Client Config Directory
mkdir -p /etc/${Auther}/webserver/wg/

# // Starting Wireguard
systemctl enable systemd-resolved
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0

rm -f /root/wireguard.sh????????????????????????????????????
