#!/bin/bash
# Menu For Script
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

# // Exporting RED BG
export RED_BG='\e[41m'

# // Exporting Addons Tools
export End_License=$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep -w $Your_License_Key | cut -d ' ' -f 4 | awk '{print $1}' );
export Start_License=$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep -w $Your_License_Key | cut -d ' ' -f 3 | awk '{print $1}' );
export Issue_License=$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep -w $Your_License_Key | cut -d ' ' -f 9-100 | awk '{print $1}' );
export Limit_License=$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep -w $Your_License_Key | cut -d ' ' -f 2 | awk '{print $1}' );
export Sekarang=`date -d "0 days" +"%Y-%m-%d"`
export Tanggal_Expired_Dalam_Hitungan_Detik=$(date -d "$End_License" +%s)
export Tanggal_Sekarang_Dalam_Hitungan_Detik=$(date -d "$Sekarang" +%s)
export Sisa_Hari_Masa_Aktif=$(( ($Tanggal_Expired_Dalam_Hitungan_Detik - $Tanggal_Sekarang_Dalam_Hitungan_Detik) / 86400 ))


clear
clear
clear
clear
echo -e "${RED_BG}                 VPS / System Information                 ${NC}"
echo -e "Sever Uptime        ${RED} •${NC} $( uptime -p  | cut -d " " -f 2-10000 ) "
echo -e "Current Time        ${RED} •${NC} $( date -d "0 days" +"%d-%m-%Y | %X" )"
echo -e "Operating System    ${RED} •${NC} $( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' ) ( $( uname -m) )"
echo -e "Current Domain      ${RED} •${NC} $( cat /etc/${Auther}/domain.txt )"
echo -e "Server IP           ${RED} •${NC} ${IP}"
echo -e "License Key Status  ${RED} •${NC} ${Status_License}"
echo -e "License Type        ${RED} •${NC} ${License_Mode} Edition"
echo -e "License Issued to   ${RED} •${NC} ${Issue_License}"
echo -e "License Start       ${RED} •${NC} ${Start_License}"
echo -e "License Limit       ${RED} •${NC} ${Limit_License} VPS"
echo -e "License Expired     ${RED} •${NC} ${End_License} (${GREEN} $(if [[ ${Sisa_Hari_Masa_Aktif} -lt 5 ]]; then
echo -e "${RED}${Sisa_Hari_Masa_Aktif} Days Left ${NC}"; else
echo -e "${Sisa_Hari_Masa_Aktif} Days Left"; fi
)${NC} )"

echo -e ""

echo -e "${RED_BG}                VPN Admin/Account Manager                 ${NC}"
echo -e "[${GREEN}01${NC}]${RED} •${NC} SSH & OpenVPN Account Manager"
echo -e "[${GREEN}02${NC}]${RED} •${NC} Vmess Account Manager"
echo -e "[${GREEN}03${NC}]${RED} •${NC} Vless Account Manager"
echo -e "[${GREEN}04${NC}]${RED} •${NC} Trojan Account Manager"
echo -e "[${GREEN}05${NC}]${RED} •${NC} Shadowsocks Account Manager"
echo -e "[${GREEN}06${NC}]${RED} •${NC} ShadowsocksR Account Manager"
echo -e "[${GREEN}07${NC}]${RED} •${NC} Wireguard Account Manager"
echo -e "[${GREEN}08${NC}]${RED} •${NC} PPTP Account Manager"
echo -e "[${GREEN}09${NC}]${RED} •${NC} L2TP Account Manager"
echo -e "[${GREEN}10${NC}]${RED} •${NC} SSTP Account Manager"


echo -e ""
echo -e "${RED_BG}               VPN Service Restart Control                ${NC}"
echo -e "[${GREEN}11${NC}]${RED} •${NC} Restarting SSH & OpenVPN Service"
echo -e "[${GREEN}12${NC}]${RED} •${NC} Restarting Vmess Service"
echo -e "[${GREEN}13${NC}]${RED} •${NC} Restarting Vless Service"
echo -e "[${GREEN}14${NC}]${RED} •${NC} Restarting Trojan Service"
echo -e "[${GREEN}15${NC}]${RED} •${NC} Restarting Shadowsocks Service"
echo -e "[${GREEN}16${NC}]${RED} •${NC} Restarting ShadowsocksR Service"
echo -e "[${GREEN}17${NC}]${RED} •${NC} Restarting Wireguard Service"
echo -e "[${GREEN}18${NC}]${RED} •${NC} Restarting PPTP Service"
echo -e "[${GREEN}19${NC}]${RED} •${NC} Restarting L2TP Service"
echo -e "[${GREEN}20${NC}]${RED} •${NC} Restarting SSTP Service"
echo -e "[${GREEN}21${NC}]${RED} •${NC} Restarting All Service"
echo -e ""

echo -e "${RED_BG}                     Addons Service                       ${NC}"
echo -e "[${GREEN}22${NC}]${RED} •${NC} Quick VPS IP Pointing"
echo -e "[${GREEN}23${NC}]${RED} •${NC} VPN Port Changer"
echo -e "[${GREEN}24${NC}]${RED} •${NC} Benchmark Speed ( Speedtest By Ookla )"
echo -e "[${GREEN}25${NC}]${RED} •${NC} Checking Ram Usage"
echo -e "[${GREEN}26${NC}]${RED} •${NC} Checking Bandwidth Usage"
echo -e "[${GREEN}27${NC}]${RED} •${NC} Change Timezone"
echo -e "[${GREEN}28${NC}]${RED} •${NC} Change License Key"
echo -e "[${GREEN}29${NC}]${RED} •${NC} Change Domain / Host"
echo -e "[${GREEN}30${NC}]${RED} •${NC} Renew SSL Certificate"
echo -e "[${GREEN}31${NC}]${RED} •${NC} Add Email For Backup"
echo -e "[${GREEN}32${NC}]${RED} •${NC} Backup VPN Client"
echo -e "[${GREEN}33${NC}]${RED} •${NC} Restore VPN Client"
echo -e "[${GREEN}34${NC}]${RED} •${NC} Custom SSH Certificate       [${GREEN} Pro ${NC}]"
echo -e "[${GREEN}35${NC}]${RED} •${NC} Custom OpenVPN Certificate   [${GREEN} Pro ${NC}]"

echo -e ""

read -p "Input Your Choose ( 1-35 ) : " choosemu


case $choosemu in
    1 | 01) # >> SSH Manager
        ssh-manager
    ;;
    2 | 02) # >> Vmess Manager
        vmess-manager
    ;;
    3 | 03) # >> Vless Manager
        vless-manager
    ;;
    4 | 04) # >> Trojan Manager
        trojan-manager
    ;;
    5 | 05) # >> Shadowsocks Manager
        ss-manager
    ;;
    6 | 06) # >> ShadowsocksR Manager
        ssr-manager
    ;;
    7 | 07) # >> Wireguard Manager
        wg-manager
    ;;
    8 | 08) # >> PPTP Manager
        pptp-manager
    ;;
    9 | 09) # >> L2TP Manager
        l2tp-manager
    ;;
    10) # >> SSTP Manager
        sstp-manager
    ;;

    # Restarting
    11) # >> Restart SSH
        /etc/init.d/ssh restart
        /etc/init.d/dropbear restart
        /etc/init.d/stunnel5 restart
        /etc/init.d/squid restart
    ;;
    12) # >> Restart Vmess
        systemctl disable xray-mini@vmess-nontls
        systemctl disable xray-mini@vmess-tls
        systemctl stop xray-mini@vmess-nontls
        systemctl stop xray-mini@vmess-tls
        systemctl enable xray-mini@vmess-nontls
        systemctl enable xray-mini@vmess-tls
        systemctl start xray-mini@vmess-nontls
        systemctl start xray-mini@vmess-tls
    ;;
    13) # >> Restart Vless
        systemctl disable xray-mini@vless-nontls
        systemctl disable xray-mini@vless-tls
        systemctl stop xray-mini@vless-nontls
        systemctl stop xray-mini@vless-tls
        systemctl enable xray-mini@vless-nontls
        systemctl enable xray-mini@vless-tls
        systemctl start xray-mini@vless-nontls
        systemctl start xray-mini@vless-tls
    ;;
    14) # >> Restart Trojan
        systemctl disable xray-mini@trojan
        systemctl stop xray-mini@trojan
        systemctl enable xray-mini@trojan
        systemctl start xray-mini@trojan
    ;;
    15) # >> Restart Shadowsocks
        systemctl disable xray-mini@shadowsocks
        systemctl stop xray-mini@shadowsocks
        systemctl enable xray-mini@shadowsocks
        systemctl start xray-mini@shadowsocks
    ;;
    17) # >> Restart Wireguard
        systemctl restart wg-quick@wg0
    ;;
    16) # >> Restart ShadowsocksR
        /etc/init.d/ssr-server restart
    ;;
    18) # >> Restart PPTP
        /etc/init.d/pptpd restart
    ;;
    19) # >> Restart L2TP
        /etc/init.d/xl2tpd restart
    ;;
    20) # >> Restart SSTP
        /etc/init.d/accel-ppp restart
    ;;
    21) # >> ALL Service
        /etc/init.d/ssh restart
        /etc/init.d/dropbear restart
        /etc/init.d/stunnel5 restart
        /etc/init.d/squid restart
        systemctl disable xray-mini@vmess-nontls
        systemctl disable xray-mini@vmess-tls
        systemctl stop xray-mini@vmess-nontls
        systemctl stop xray-mini@vmess-tls
        systemctl enable xray-mini@vmess-nontls
        systemctl enable xray-mini@vmess-tls
        systemctl start xray-mini@vmess-nontls
        systemctl start xray-mini@vmess-tls
        systemctl disable xray-mini@vless-nontls
        systemctl disable xray-mini@vless-tls
        systemctl stop xray-mini@vless-nontls
        systemctl stop xray-mini@vless-tls
        systemctl enable xray-mini@vless-nontls
        systemctl enable xray-mini@vless-tls
        systemctl start xray-mini@vless-nontls
        systemctl start xray-mini@vless-tls
        systemctl disable xray-mini@trojan
        systemctl stop xray-mini@trojan
        systemctl enable xray-mini@trojan
        systemctl start xray-mini@trojan
        systemctl disable xray-mini@shadowsocks
        systemctl stop xray-mini@shadowsocks
        systemctl enable xray-mini@shadowsocks
        systemctl start xray-mini@shadowsocks
        systemctl restart wg-quick@wg0
        systemctl restart ws-epro
        systemctl restart ohp-mini-1.service
        systemctl restart ohp-mini-2.service
        systemctl restart ohp-mini-3.service
        systemctl restart ohp-mini-4.service
        systemctl restart udp-mini-1.service
        systemctl restart udp-mini-2.service
        systemctl restart udp-mini-3.service
        /etc/init.d/ssr-server restart
        /etc/init.d/pptpd restart
        /etc/init.d/xl2tpd restart
        /etc/init.d/accel-ppp restart
        /etc/init.d/nginx restart
        /etc/init.d/fail2ban restart
    ;;
    22) # >> Pointing
        vps-pointing
    ;;
    23) # >> Port Changer
        port-changer
    ;;
    24) # >> Speedtest
        speedtest
    ;;
    25) # >> Ram Usage
        ram-usage
    ;;
    26) # >> Bandiwdth usage
        clear
        vnstat
    ;;
    27) # >> Change Timezone
        clear 
        echo -e "${RED_BG}                     Timezone Changer                     ${NC}"
        echo -e "${GREEN} 1${YELLOW})${NC}. Indonesia Jakarta ( WIB ) / GMT +7"
        echo -e "${GREEN} 2${YELLOW})${NC}. Malaysia ( Kuala_Lumpur ) / GMT +8"
        echo ""
        read -p "Please Choose an Timezone : " timezonemu
        if [[ $timezonemu == "" ]]; then
            echo -e "${EROR} Please Select an Timezone"
            exit 1
        fi

        if [[ $timezonemu == "1" ]]; then
            ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
            clear
            echo -e "${OKEY} Changed Timezone to WIB / Jakarta"
        elif [[ $timezonemu == "2" ]]; then
            ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
            clear
            echo -e "${OKEY} Changed Timezone to Kuala_Lumpur / Malaysia"
        else
            echo -e "${EROR} Wrong Select"
            exit 1s
        fi
    ;;
    28) # // Change License
        read -p "Input Your License Key : " Input_License_Key

        # // Checking Input Blank
        if [[ $Input_License_Key ==  "" ]]; then
            echo -e "${EROR} Please Input License Key !${NC}"
            exit 1
        fi

        # // Checking License Validate
        Key="$Input_License_Key"
        clear

        # // Algoritma Key
        algoritmakeys="1920192019209129403940293013912" 
        hashsuccess="$(echo -n "$Key" | sha256sum | cut -d ' ' -f 1)" 
        Sha256Successs="$(echo -n "$hashsuccess$algoritmakeys" | sha256sum | cut -d ' ' -f 1)" 
        License_Key=$Sha256Successs
        echo ""
        echo -e "${OKEY} Successfull Connected To vpnkuy.site"
        sleep 1

        # // Validate Result
        Getting_Data_On_Server=$( curl -s https://vpnkuy.site/mantap/validated-registered-license-key.txt | grep $License_Key | cut -d ' ' -f 1 )
        if [[ "$Getting_Data_On_Server" == "$License_Key" ]]; then
            mkdir -p /etc/${Auther}/
            echo "$License_Key" > /etc/${Auther}/license.key
            echo -e "${OKEY} License Validated !"
            sleep 1
        else
            echo -e "${EROR} Your License Key Not Valid !"
            exit 1
        fi
        clear
        echo -e "${OKEY} Successfull Changed License Key to $Input_License_Key"
    ;;
    29) # >> Change domain
        read -p "New Domain : " domain

        if [[ $domain == "" ]]; then
            echo -e "${EROR} No Domain Detected"
            exit 1
        fi

        echo $domain > /etc/${Auther}/domain.txt

        # // Making Certificate
        clear
        echo -e "${OKEY} Starting Generating Certificate"
        mkdir -p /data/
        chmod 700 /data/
        rm -r -f /root/.acme.sh
        mkdir -p /root/.acme.sh
        wget -q -O /root/.acme.sh/acme.sh "https://releases.vpnkuy.site/mantap/vpn-script/Resource/tools/acme.sh"
        chmod +x /root/.acme.sh/acme.sh
        sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
        sudo /root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /data/ssl.crt --keypath /data/ssl.key --ecc
        sleep 10
        clear
        echo -e "${OKEY} Successfull Changed Domain to $domain"
    ;;
    30) # // Renew SSL Cert
        domain=$( cat /etc/${Auther}/domain.txt | head -n1 )

        sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
        sudo /root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /data/ssl.crt --keypath /data/ssl.key --ecc
    ;;
    31) # // Add mail
        addmail
    ;;
    32) # // Backup
        backup
    ;;
    33) # // Restore
        restore
    ;;
    34) # // Create SSL For Stunnel
        if [[ $License_Mode == "Pro" ]]; then
        clear
        read -p "Country       : " country
        read -p "State         : " state
        read -p "Location      : " locality
        read -p "Organization  : " organization
        read -p "Common Name   : " commonname
        read -p "Email         : " email
        organizationalunit=${organization}

        if [[ $country == "" ]]; then
            echo -e "${EROR} Please Input Country"
            exit 1
        fi
        if [[ $state == "" ]]; then
            echo -e "${EROR} Please Input State"
            exit 1
        fi
        if [[ $locality == "" ]]; then
            echo -e "${EROR} Please Input Location"
            exit 1
        fi
        if [[ $organization == "" ]]; then
            echo -e "${EROR} Please Input Location"
            exit 1
        fi
        if [[ $commonname == "" ]]; then
            echo -e "${EROR} Please Input CommonName"
            exit 1
        fi
        if [[ $email == "" ]]; then
            echo -e "${EROR} Please Input Email"
            exit 1
        fi

        cd /root
        openssl genrsa -out key.pem 2048
        openssl req -new -x509 -key key.pem -out cert.pem -days 1095 -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
        cat key.pem cert.pem > /etc/stunnel5/stunnel5.pem
        rm -f key.pem
        rm -f cert.pem

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Success
        echo -e "${OKEY} Successfull Request Certificate For ${commonname}"
        else
            echo -e "${EROR} Sorry For Pro Edition Only"
            exit 1
        fi
    ;;
    35) # // OpenVPN
        if [[ $License_Mode == "Pro" ]]; then

        clear
        read -p "Country       : " country
        read -p "State         : " state
        read -p "Location      : " locality
        read -p "Organization  : " organization
        read -p "Common Name   : " commonname
        read -p "Email         : " email
        organizationalunit=${organization}

        if [[ $country == "" ]]; then
            echo -e "${EROR} Please Input Country"
            exit 1
        fi
        if [[ $state == "" ]]; then
            echo -e "${EROR} Please Input State"
            exit 1
        fi
        if [[ $locality == "" ]]; then
            echo -e "${EROR} Please Input Location"
            exit 1
        fi
        if [[ $organization == "" ]]; then
            echo -e "${EROR} Please Input Location"
            exit 1
        fi
        if [[ $commonname == "" ]]; then
            echo -e "${EROR} Please Input CommonName"
            exit 1
        fi
        if [[ $email == "" ]]; then
            echo -e "${EROR} Please Input Email"
            exit 1
        fi

        wget -q -O /root/openvpn.zip "https://releases.GeoVPN.net/vpn-script/Resource/tools/openvpn-cert.zip"
        unzip -o /root/openvpn.zip > /dev/null 2>&1

        rm openvpn.zip
        cd openvpn-cert

        apt install easy-rsa -y
        echo 'export EASY_RSA="$( pwd )"' > /root/openvpn-cert/vars
        echo "export OPENSSL=openssl" >> /root/openvpn-cert/vars
        echo "export PKCS11TOOL=pkcs11-tool" >> /root/openvpn-cert/vars
        echo "export GREP=grep" >> /root/openvpn-cert/vars
        echo 'export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`' >> /root/openvpn-cert/vars
        echo 'export KEY_DIR="$EASY_RSA/keys"' >> /root/openvpn-cert/vars
        echo "export PKCS11_MODULE_PATH=dummy" >> /root/openvpn-cert/vars
        echo "export PKCS11_PIN=dummy" >> /root/openvpn-cert/vars
        echo "export DH_KEY_SIZE=2048" >> /root/openvpn-cert/vars
        echo "export KEY_SIZE=4096" >> /root/openvpn-cert/vars
        echo "export CA_EXPIRE=3650" >> /root/openvpn-cert/vars
        echo "export KEY_EXPIRE=3650" >> /root/openvpn-cert/vars
        echo "export KEY_COUNTRY=${country}" >> /root/openvpn-cert/vars
        echo "export KEY_PROVINCE=${state}" >> /root/openvpn-cert/vars
        echo "export KEY_CITY=${locality}" >> /root/openvpn-cert/vars
        echo "export KEY_ORG=${organization}" >> /root/openvpn-cert/vars
        echo "export KEY_EMAIL=${email}" >> /root/openvpn-cert/vars
        echo "export KEY_CN=$commonname" >> /root/openvpn-cert/vars
        echo "export KEY_NAME=GeoVPN" >> /root/openvpn-cert/vars
        echo "export KEY_OU=${organization}" >> /root/openvpn-cert/vars
        chmod +x /root/openvpn-cert/whichopensslcnf
        chmod +x /root/openvpn-cert/vars
        cp openssl-1.0.0.cnf openssl.cnf
        chmod +x *
        source ./vars
        ./vars
        ./clean-all
        clear
        ./build-ca
        clear
        ./build-key-server GeoVPN
        clear
        ./build-key client
        clear
        ./build-dh
        clear

        cd keys
        cp * /etc/openvpn/
        rm -r -f /root/openvpn-cert

        # // Clear
        clear
        clear && clear && clear
        clear;clear;clear

        # // Success
        echo -e "${OKEY} Successfull Request Certificate For ${commonname}"
        else
            echo -e "${EROR} Sorry For Pro Edition Only"
            exit 1
        fi
    ;;
    *) # >> Wrong Select
        echo -e "${EROR} Please Select Someone"
        sleep 2
        menu
    ;;
esac
