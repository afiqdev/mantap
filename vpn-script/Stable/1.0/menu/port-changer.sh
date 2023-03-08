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

# // Validate Result ( 1 )
touch /etc/${Auther}/license.key
export Your_License_Key="$( cat /etc/${Auther}/license.key | awk '{print $1}' )"
export Validated_Your_License_Key_With_Server="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep -w $Your_License_Key | head -n1 | cut -d ' ' -f 1 )"
if [[ "$Validated_Your_License_Key_With_Server" == "$Your_License_Key" ]]; then
    validated='true'
else
    echo -e "${EROR} License Key Not Valid"
    exit 1
fi

# // Checking VPS Status > Got Banned / No
if [[ $IP == "$( curl -s https://${Server_URL}/mantap/vpn-script/Stable/1.0/menu/blacklist.txt | cut -d ' ' -f 1 | grep -w $IP | head -n1 )" ]]; then
    echo -e "${EROR} 403 Forbidden ( Your VPS Has Been Banned )"
    exit  1
fi

# // Checking VPS Status > Got Banned / No
if [[ $Your_License_Key == "$( curl -s https://${Server_URL}/mantap | cut -d ' ' -f 1 | grep -w $Your_License_Key | head -n1)" ]]; then
    echo -e "${EROR} 403 Forbidden ( Your License Has Been Limited )"
    exit  1
fi

# // Checking VPS Status > Got Banned / No
if [[ 'Standart' == "$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep -w $Your_License_Key | head -n1 | cut -d ' ' -f 8 )" ]]; then 
    License_Mode='Standart'
elif [[ Pro == "$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep -w $Your_License_Key | head -n1 | cut -d ' ' -f 8 )" ]]; then 
    License_Mode='Pro'
else
    echo -e "${EROR} Please Using Genuine License !"
    exit 1
fi

# // Checking Script Expired
exp=$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep -w $Your_License_Key | cut -d ' ' -f 4 )
now=`date -d "0 days" +"%Y-%m-%d"`
expired_date=$(date -d "$exp" +%s)
now_date=$(date -d "$now" +%s)
sisa_hari=$(( ($expired_date - $now_date) / 86400 ))
if [[ $sisa_hari -lt 0 ]]; then
    echo $sisa_hari > /etc/${Auther}/license-remaining-active-days.db
    echo -e "${EROR} Your License Key Expired ( $sisa_hari Days )"
    exit 1
else
    echo $sisa_hari > /etc/${Auther}/license-remaining-active-days.db
fi

# // Exporting RED_BG
export RED_BG='\e[41m'

# // Exporting Current Port
export ssh_ssl=$( cat /lib/systemd/system/sslh.service | grep -w ExecStart | head -n1 | awk '{print $6}' | sed 's/0.0.0.0//g' | sed 's/://g' | tr '\n' ' ' | tr -d '\r' )
export vmess_nontls=$( cat /etc/xray-mini/vmess-nontls.json | grep -w port | sed 's/port//g' | sed 's/=//g' | sed 's/://g' | sed 's/"//g' | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )
export vmess_tls=$( cat /etc/xray-mini/vmess-tls.json | grep -w port | sed 's/port//g' | sed 's/=//g' | sed 's/://g' | sed 's/"//g' | sed 's/,//g'  | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )
export vless_nontls=$( cat /etc/xray-mini/vless-nontls.json | grep -w port | sed 's/port//g' | sed 's/=//g' | sed 's/://g' | sed 's/"//g' | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )
export vless_tls=$( cat /etc/xray-mini/vless-tls.json | grep -w port | sed 's/port//g' | sed 's/=//g' | sed 's/://g' | sed 's/"//g' | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )
export trojan=$( cat /etc/xray-mini/trojan.json | grep -w port | sed 's/port//g' | sed 's/=//g' | sed 's/://g' | sed 's/"//g' | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )
export shadowsocks=$( cat /etc/xray-mini/shadowsocks.json | grep -w port | sed 's/port//g' | sed 's/=//g' | sed 's/://g' | sed 's/"//g' | sed 's/,//g' | tr '\n' ' ' | tr -d '\r' | tr -d '\r\n' | sed 's/ //g' )
export wireguard=$( cat /etc/wireguard/wg0.conf | grep ListenPort | head -n1 | awk '{print $3}' )
export sstp=$( cat /etc/accel-ppp.conf | grep -w port | awk '{print $1}' | sed 's/port//g' | sed 's/=//g')
export ssh_nontls=$( cat /etc/${Auther}/ws-epro.conf | grep -w listen_port | sed 's/listen_port//g' | sed 's/://g' | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $1}' | tr -d '\r' )
export squid1=$( cat /etc/squid/squid.conf | grep -w http_port | sed 's/http_port//g' | sed 's/://g' | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $1}' | tr -d '\r' )
export squid2=$( cat /etc/squid/squid.conf | grep -w http_port | sed 's/http_port//g' | sed 's/://g' | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $2}' | tr -d '\r' )
export squid3=$( cat /etc/squid/squid.conf | grep -w http_port | sed 's/http_port//g' | sed 's/://g' | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $3}' | tr -d '\r' )
export ohp1=$( cat /etc/systemd/system/ohp-mini-1.service | grep -w port | awk '{print $3}' | tr -d '\r' | tr -d '\r\n' )
export ohp2=$( cat /etc/systemd/system/ohp-mini-2.service | grep -w port | awk '{print $3}' | tr -d '\r' | tr -d '\r\n' )
export ohp3=$( cat /etc/systemd/system/ohp-mini-3.service | grep -w port | awk '{print $3}' | tr -d '\r' | tr -d '\r\n' )
export ohp4=$( cat /etc/systemd/system/ohp-mini-4.service | grep -w port | awk '{print $3}' | tr -d '\r' | tr -d '\r\n' )
export dropbear=$( cat /etc/default/dropbear | grep -w DROPBEAR_PORT | sed 's/DROPBEAR_PORT//g' | sed 's/=//g' | tr -d '\r' | tr -d '\r\n' )

# // Clear
clear
clear && clear && clear
clear;clear;clear

echo -e "${RED_BG}                         Port Changer                     ${NC}"
echo -e "${GREEN} 1${YELLOW})${NC}. Change SSH SSL Port       | Current Port ( ${GREEN}${ssh_ssl}${NC} ) "
echo -e "${GREEN} 2${YELLOW})${NC}. Change Vmess NonTLS Port  | Current Port ( ${GREEN}${vmess_nontls}${NC} )"
echo -e "${GREEN} 3${YELLOW})${NC}. Change Vmess TLS Port     | Current Port ( ${GREEN}${vmess_tls}${NC} )"
echo -e "${GREEN} 4${YELLOW})${NC}. Change Vless NonTLS Port  | Current Port ( ${GREEN}${vless_nontls}${NC} )"
echo -e "${GREEN} 5${YELLOW})${NC}. Change Vless TLS Port     | Current Port ( ${GREEN}${vless_tls}${NC} )"
echo -e "${GREEN} 6${YELLOW})${NC}. Change Trojan Port        | Current Port ( ${GREEN}${trojan}${NC} )"
echo -e "${GREEN} 7${YELLOW})${NC}. Change Shadowsocks Port   | Current Port ( ${GREEN}${shadowsocks}${NC} )"
echo -e "${GREEN} 8${YELLOW})${NC}. Change Wireguard Port     | Current Port ( ${GREEN}${wireguard}${NC} )"
echo -e "${GREEN} 9${YELLOW})${NC}. Change SSTP Port          | Current Port ( ${GREEN}${sstp}${NC} )"
echo -e "${GREEN}10${YELLOW})${NC}. Change WebSocket NonTLS   | Current Port ( ${GREEN}${ssh_nontls}${NC} )"
echo -e "${GREEN}11${YELLOW})${NC}. Change Squid Proxy 1      | Current Port ( ${GREEN}${squid1}${NC} )"
echo -e "${GREEN}12${YELLOW})${NC}. Change Squid Proxy 2      | Current Port ( ${GREEN}${squid2}${NC} )"
echo -e "${GREEN}13${YELLOW})${NC}. Change Squid Proxy 3      | Current Port ( ${GREEN}${squid3}${NC} )"
echo -e "${GREEN}14${YELLOW})${NC}. Change OHP 1 OpenSSH      | Current Port ( ${GREEN}${ohp1}${NC} )"
echo -e "${GREEN}15${YELLOW})${NC}. Change OHP 2 Dropbear     | Current Port ( ${GREEN}${ohp2}${NC} )"
echo -e "${GREEN}16${YELLOW})${NC}. Change OHP 3 OpenVPN      | Current Port ( ${GREEN}${ohp3}${NC} )"
echo -e "${GREEN}17${YELLOW})${NC}. Change OHP 4 Universal    | Current Port ( ${GREEN}${ohp4}${NC} )"
echo -e "${GREEN}18${YELLOW})${NC}. Change Dropbear           | Current Port ( ${GREEN}${dropbear}${NC} )"

echo ""
read -p "Please Input Your Choose : " choosemu
case $choosemu in
    1) # // Change Port For SSH-SSL
        read -p "Input New Port For SSH-SSL : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected !"
            exit 1
        fi
        
        # // Make Changes To SSH-SSL Server Config
        sed -i "s/${ssh_ssl}/${newport} /g" /lib/systemd/system/sslh.service

        # // Restarting Service
        systemctl daemon-reload
        systemctl restart sslh

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} SSH-SSL Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    2) # // Change Vmess NonTLS
        read -p "Input New Port For Vmess NonTLS : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected !"
            exit 1
        fi

        # // Make Changes To Vmess NonTLS Server Config
        sed -i "s/${vmess_nontls}/${newport}/g" /etc/xray-mini/vmess-nontls.json

        # // Restarting Service
        systemctl daemon-reload
        systemctl restart xray-mini@vmess-nontls

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Vmess NonTLS Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    3) # // Change Vmess TLS
        read -p "Input New Port For Vmess TLS : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected !"
            exit 1
        fi

        # // Make Changes To Vmess TLS Server Config
        sed -i "s/${vmess_tls}/${newport}/g" /etc/xray-mini/vmess-tls.json

        # // Restarting Service
        systemctl daemon-reload
        systemctl restart xray-mini@vmess-tls

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Vmess TLS Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    4) # // Change Vless NonTLS
        read -p "Input New Port For Vless NonTLS : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected !"
            exit 1
        fi

        # // Make Changes To Vless NonTLS Server Config
        sed -i "s/${vless_nontls}/${newport}/g" /etc/xray-mini/vless-nontls.json

        # // Restarting Service
        systemctl daemon-reload
        systemctl restart xray-mini@vless-nontls

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Vless NonTLS Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    5) # // Change Vless TLS
        read -p "Input New Port For Vless TLS : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected !"
            exit 1
        fi

        # // Make Changes To Vless TLS Server Config
        sed -i "s/${vless_tls}/${newport}/g" /etc/xray-mini/vless-tls.json

        # // Restarting Service
        systemctl daemon-reload
        systemctl restart xray-mini@vless-tls

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Vless TLS Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    6) # // Change Trojan
        read -p "Input New Port For Trojan : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected !"
            exit 1
        fi

        # // Make Changes To Vless TLS Server Config
        sed -i "s/${trojan}/${newport}/g" /etc/xray-mini/trojan.json

        # // Restarting Service
        systemctl daemon-reload
        systemctl restart xray-mini@trojan

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Trojan Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    7) # // Change Shadowsocks
        read -p "Input New Port For Shadowsocks : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected !"
            exit 1
        fi

        # // Make Changes To Shadowsocks Server Config
        sed -i "s/${shadowsocks}/${newport}/g" /etc/xray-mini/shadowsocks.json

        # // Restarting Service
        systemctl daemon-reload
        systemctl restart xray-mini@shadowsocks

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Shadowsocks Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    8) # // Change Wireguard
        read -p "Input New Port For Wireguard : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected !"
            exit 1
        fi

        # // Make Changes To Vless TLS Server Config
        sed -i "s/${wireguard}/${newport}/g" /etc/wireguard/wg0.conf

        # // Restarting Service
        systemctl daemon-reload
        systemctl restart wg-quick@wg0

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Wireguard Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    9) # // Change SSTP
        read -p "Input New Port For SSTP : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected !"
            exit 1
        fi

        # // Make Changes To SSTP Server Config
        sed -i "s/${sstp}/${newport}/g" /etc/accel-ppp.conf

        # // Restarting Service
        systemctl daemon-reload
        systemctl restart accel-ppp

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} SSTP Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    10) # // Change WS-ePro Port
        read -p "Input New Port For SSH NonTLS : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected"
            exit 1
        fi

        # // Stopping SSLH
        systemctl daemon-reload
        systemctl stop sslh

        # // Make Changes To WS-ePro Config
        sed -i "s/${ssh_nontls}/${newport}/g" /etc/${Auther}/ws-epro.conf
        sed -i "s/${ssh_nontls}/${newport}/g" /lib/systemd/system/sslh.service    

        # // Starting SSLH
        systemctl daemon-reload
        systemctl start sslh

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} SSH NonTLS Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    11) # // Change Squid 1
        read -p "Input New Port For Squid1 : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected"
            exit 1
        fi

        # // Applying Change To Squid
        sed -i "s/${squid1}/${newport}/g" /etc/squid/squid.conf    

        # // Restarting Squid
        /etc/init.d/squid restart

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Squid1 Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    12) # // Change Squid 2
        read -p "Input New Port For Squid2 : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected"
            exit 1
        fi

        # // Applying Change To Squid
        sed -i "s/${squid2}/${newport}/g" /etc/squid/squid.conf    

        # // Restarting Squid
        /etc/init.d/squid restart

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Squid2 Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    13) # // Change Squid 3
        read -p "Input New Port For Squid3 : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected"
            exit 1
        fi

        # // Applying Change To Squid
        sed -i "s/${squid3}/${newport}/g" /etc/squid/squid.conf    

        # // Restarting Squid
        /etc/init.d/squid restart

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Squid3 Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;

    14) # // OHP 1 ( OpenSSH )
        read -p "Input New Port For OHP OpenSSH : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected"
            exit 1
        fi

        # // Stopping OHP Service
        systemctl daemon-reload
        systemctl stop ohp-mini-1
        systemctl disable ohp-mini-1

        # // Applying Change To OHP
        sed -i "s/${ohp1}/${newport}/g" /etc/systemd/system/ohp-mini-1.service    

        # // Starting OHP
        systemctl daemon-reload
        systemctl enable ohp-mini-1
        systemctl start ohp-mini-1

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} OHP OpenSSH Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;

    15) # // OHP 2 ( Dropbear )
        read -p "Input New Port For OHP Dropbear : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected"
            exit 1
        fi

        # // Stopping OHP Service
        systemctl daemon-reload
        systemctl stop ohp-mini-2
        systemctl disable ohp-mini-2

        # // Applying Change To OHP
        sed -i "s/${ohp2}/${newport}/g" /etc/systemd/system/ohp-mini-2.service    

        # // Starting OHP
        systemctl daemon-reload
        systemctl enable ohp-mini-2
        systemctl start ohp-mini-2

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} OHP Dropbear Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;

    16) # // OHP 3 ( Dropbear )
        read -p "Input New Port For OHP OpenVPN : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected"
            exit 1
        fi

        # // Stopping OHP Service
        systemctl daemon-reload
        systemctl stop ohp-mini-3
        systemctl disable ohp-mini-3

        # // Applying Change To OHP
        sed -i "s/${ohp3}/${newport}/g" /etc/systemd/system/ohp-mini-3.service    

        # // Starting OHP
        systemctl daemon-reload
        systemctl enable ohp-mini-3
        systemctl start ohp-mini-3

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} OHP OpenVPN Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;

    17) # // OHP 4 ( Universal )
        read -p "Input New Port For OHP Universal : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected"
            exit 1
        fi

        # // Stopping OHP Service
        systemctl daemon-reload
        systemctl stop ohp-mini-4
        systemctl disable ohp-mini-4

        # // Applying Change To OHP
        sed -i "s/${ohp4}/${newport}/g" /etc/systemd/system/ohp-mini-4.service    

        # // Starting OHP
        systemctl daemon-reload
        systemctl enable ohp-mini-4
        systemctl start ohp-mini-4

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} OHP Universal Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;

    18) # // Dropbear
        read -p "Input New Port For Dropbear : " newport
        if [[ $newport == "" ]]; then
            echo -e "${EROR} No Input Detected"
            exit 1
        fi

        # // Stopping Dropbear
        /etc/init.d/dropbear stop
    
        # // Applying Change to dropbear
        sed -i "s/${dropbear}/${newport}/g" /etc/default/dropbear

        # // Starting Dropbear
        /etc/init.d/dropbear start
       
        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Done
        echo -e "${OKEY} Dropbear Port Successfull Changed to ( ${GREEN}${newport}${NC} )"
    ;;
    *) # // Wrong Choose
        echo -e "${EROR} Please Choose One"
        sleep 2
        port-changer
    ;;
esac
