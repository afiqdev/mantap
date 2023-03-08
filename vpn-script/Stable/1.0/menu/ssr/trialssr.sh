#!/bin/bash
# User Trial ShadowsocksR
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

# // Clear
clear
clear && clear && clear
clear;clear;clear

# // Start Menu
echo " List Of Avaiable ShadowsocksR Protocols"
echo "==============================================="
echo "  1. origin"
echo "  2. verify_simple"
echo "  3. verify_sha1"
echo "  4. auth_sha1"
echo "  5. auth_sha1_v2"
echo "  6. auth_sha1_v4"
echo "  7. auth_aes128_sha1"
echo "  8. auth_aes128_md5"
echo "  9. auth_chain_a"
echo " 10. auth_chain_b"
echo " 11. auth_chain_c"
echo " 12. auth_chain_d"
echo " 13. auth_chain_e"
echo " 14. auth_chain_f"
echo "==============================================="
read -p "Choose One Protocols You Want Use ( 1-14 ) : " choose_protocols
case $choose_protocols in
    1) # Origin
        Protocols="origin"
    ;;
    3) # verify_simple
        Protocols="verify_simple"
    ;;
    3) # auth_sha1
        Protocols="verify_sha1"
    ;;
    4) # auth_sha1
        Protocols="auth_sha1"
    ;;
    5) # auth_sha1_v2
        Protocols="auth_sha1_v2"
    ;;
    6) # auth_sha1_v4
        Protocols="auth_sha1_v4"
    ;;
    7) # auth_aes128_sha1
        Protocols="auth_aes128_sha1"
    ;;
    8) # auth_aes128_md5
        Protocols="auth_aes128_md5"
    ;;
    9) # auth_chain_a
        Protocols="auth_chain_a"
    ;;
    10) # auth_chain_b
        Protocols="auth_chain_b"
    ;;
    11) # auth_chain_c
        Protocols="auth_chain_c"
    ;;
    12) # auth_chain_d
        Protocols="auth_chain_d"
    ;;
    13) # auth_chain_e
        Protocols="auth_chain_e"
    ;;
    14) # auth_chain_f
        Protocols="auth_chain_f"
    ;;
    *) # No Choose
        echo -e "${EROR} Please Choose One Protocols !"
        exit 1
    ;;
esac

clear

# // Choose Obfs
echo " List Of Avaiable ShadowsocksR Obfs"
echo "==============================================="
echo " 1. plain"
echo " 2. http_simple"
echo " 3. http_post"
echo " 4. tls_simple"
echo " 5. tls1.2_ticket_auth"
echo "==============================================="
read -p "Choose One Obfs You Want Use ( 1-5 ) : " choose_obfs
case $choose_obfs in
    1) # plain
        obfs="plain"
    ;;
    2) # http_simple
        obfs="http_simple"
    ;;
    3) # http_post
        obfs="http_post"
    ;;
    4) # tls_simple
        obfs="tls_simple"
    ;;
    5) # tls1.2_ticket_auth_compatible
        obfs="tls1.2_ticket_auth_compatible"
    ;;
    *) # No Choose
        echo -e "${EROR} Please Choose One Obfs !"
        exit 1
    ;;
esac

clear

Username="Trial-$( </dev/urandom tr -dc 0-9A-Z | head -c4 )"
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )" # > // Filtering If User Type Space

if [[ $Username == "$( cat /etc/${Auther}/data-shadowsocksr.db | grep -w $Username | head -n1 | awk '{print $4}' )" ]]; then
echo -e "${EROR} Account With ( ${YELLOW}$Username ${NC}) Already Exists !"
exit 1
fi

# // String For Trial
max_log=1 # >> Set Max Login on 1 as Defaults
Jumlah_Hari=1 # >> Setting Expired Days on 1 days
bandwidth_allowed=1 # >> Setting Bandwidth On 1GB

# // Count Date
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`
hariini=`date -d "0 days" +"%Y-%m-%d"`

# // Port Configuration
if [[ $(cat /etc/${Auther}/ssr-server/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 ) == "" ]]; then
Port=3100
else
Port=$(( $(cat /etc/${Auther}/ssr-server/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 ) + 1 ))
fi

# // Adding User To Configuration
sed -i '/#SSR$/a\#DEPAN '"Username : $Username | Expired : $exp"'\
'"port $Port"'\
#BELAKANG '"Username : $Username | Expired : $exp"'' /etc/${Auther}/data-shadowsocksr.db

# // Adding User To ShadowsocksR Server
cd /etc/${Auther}/ssr-server/
match_add=$(python mujson_mgr.py -a -u "${Username}" -p "${Port}" -k "${Username}" -m "aes-256-cfb" -O "${Protocols}" -G "${max_log}" -o "${obfs}" -s "0" -S "0" -t "${bandwidth_allowed}" -f "bittorrent" | grep -w "add user info")
cd

# // Make Client Configuration Link
tmp1=$(echo -n "${Username}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g')
SSRobfs=$(echo ${obfs} | sed 's/_compatible//g')
tmp2=$(echo -n "${IP}:${Port}:${Protocols}:aes-256-cfb:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0)
ssr_link="ssr://${tmp2}"

# // Restarting Service
/etc/init.d/ssr-server restart

# // Clear
clear
clear && clear && clear
clear;clear;clear

# // Successfull
echo "Your Trial ShadowsocksR"
echo "=============================="
echo " IP         = "${IP}"
echo " Domain     = $( cat /etc/${Auther}/domain.txt | awk '{print $1}')"
echo " Username   = $Username"
echo " Password   = $Username"
echo " Port       = $Port"
echo " Protocols  = $Protocols"
echo " Obfs       = $obfs"
echo " Max Login  = $max_log Device"
echo " BW Limit   = $bandwidth_allowed GB"
echo "=============================="
echo " ShadowsocksR Config Link"
echo "$ssr_link"
echo "=============================="
echo " Created    = $hariini"
echo " Expired    = $exp"
echo "=============================="        