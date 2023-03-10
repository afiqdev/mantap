#!/bin/bash
# User Trial Vmess
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
if [[ "$( cat /etc/xray-mini/vmess-nontls.json | grep -w ${Username})" == "" ]]; then
    Do=Nothing
else
    echo -e "${EROR} User ( ${YELLOW}$Username${NC} ) Already Exists !"
    exit 1
fi

# // Expired Date
Jumlah_Hari=1
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`

# // Generate New UUID & Domain
uuid=$( cat /proc/sys/kernel/random/uuid );
Domain=$( cat /etc/${Auther}/domain.txt | cut -d " " -f 1 );

# // Getting Port From Config File
nontls=$( cat /etc/xray-mini/vmess-nontls.json | grep -w port | awk '{print $2}' | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )
tls=$( cat /etc/xray-mini/vmess-tls.json | grep -w port | awk '{print $2}' | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )
path_tls=$( cat /etc/xray-mini/vmess-tls.json | grep -w path | awk '{print $2}' | sed 's/,//g' | sed 's/"//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )
path_nontls=$( cat /etc/xray-mini/vmess-nontls.json | grep -w path | awk '{print $2}' | sed 's/,//g' | sed 's/"//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )

# // Input Client Data To Server
sed -i '/#XRay$/a\#DEPAN '"Username : $Username | Expired : $exp"'\
            },{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$Username""'"\
#BELAKANG '"Username : $Username | Expired : $exp"'' /etc/xray-mini/vmess-nontls.json

sed -i '/#XRay$/a\#DEPAN '"Username : $Username | Expired : $exp"'\
            },{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$Username""'"\
#BELAKANG '"Username : $Username | Expired : $exp"'' /etc/xray-mini/vmess-tls.json

# // Make Link Cache
cat > /etc/${Auther}/xray-vmess-nontls.tmp << END
{"add":"$Domain","aid":"0","host":"example.com","id":"${uuid}","net":"ws","path":"${path_nontls}","port":"${nontls}","ps":"${Username}","scy":"auto","sni":"","tls":"","type":"","v":"2"}
END
cat > /etc/${Auther}/xray-vmess-tls.tmp << END
{"add":"$Domain","aid":"0","host":"example.com","id":"${uuid}","net":"ws","path":"${path_tls}","port":"${tls}","ps":"${Username}","scy":"auto","sni":"${Domain}","tls":"tls","type":"","v":"2"}
END

# // Make Config Link
nontls_link="vmess://$(base64 -w 0 /etc/${Auther}/xray-vmess-nontls.tmp)"
tls_link="vmess://$(base64 -w 0 /etc/${Auther}/xray-vmess-tls.tmp)"

# // Restarting XRay Service
systemctl restart xray-mini@vmess-nontls
systemctl restart xray-mini@vmess-tls

# // Success
sleep 1
clear
clear && clear && clear
clear;clear;clear
echo -e "Your Trial Vmess Details"
echo -e "==============================="
echo -e " Remarks     = ${Username}"
echo -e " IP          = ${IP}"
echo -e " Address     = ${Domain}"
echo -e " Port HTTPS  = ${tls}"
echo -e " Port HTTP   = ${nontls}"
echo -e " User ID     = ${uuid}"
echo -e " AlterID     = 0"
echo -e " Security    = auto"
echo -e " Network     = ws/websocket"
echo -e " HeadType    = none"
echo -e " ReqHost     = example.com"
echo -e " Path HTTP   = ${path_nontls}"
echo -e " Path HTTPS  = ${path_tls}"
echo -e "==============================="
echo -e " HTTP VMESS CONFIG LINK"
echo -e " ${nontls_link}"
echo -e "==============================="
echo -e " HTTPS VMESS CONFIG LINK"
echo -e " ${tls_link}"
echo -e "==============================="
echo -e " Created     = ${hariini}"
echo -e " Expired     = ${exp}"
echo -e "==============================="??????????????????
