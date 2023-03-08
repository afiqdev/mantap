#!/bin/bash
# Welcome Information
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
export RED_BG='\e[41m'

# // Exporting IP Address
export IP=$( curl -sS ipinfo.io/ip )

# // Function Start
function license_check () {
Algoritma_Keys="$( cat /etc/${Auther}/license.key )"
Validated_Keys="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 1 )"
if [[ "$Algoritma_Keys" == "$Validated_Keys" ]]; then
    if [[ $Algoritma_Keys == "" ]]; then
        Skip="true"
    else
        Limit_License="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 2 )"
        Start_License="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 3 )"
        End_License="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 4 )"
        Bot="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 5 )"
        Backup="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 6 )"
        Beta="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 7 )"
        Tipe="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 8 )"
        Issue_License="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 9-100 )"
    fi
    exp=$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 4 )
    now=`date -d "0 days" +"%Y-%m-%d"`
    d1=$(date -d "$exp" +%s)
    d2=$(date -d "$now" +%s)
    Sisa_Hari=$(( (d1 - d2) / 86400 ))
    Status_License="Activated"
else
    if [[ $Algoritma_Keys == "" ]]; then
        Skip="true"
    else
        Limit_License="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 2 )"
        Start_License="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 3 )"
        End_License="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 4 )"
        Bot="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 5 )"
        Backup="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 6 )"
        Beta="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 7 )"
        Tipe="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 8 )"
        Issue_License="$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $Algoritma_Keys | cut -d ' ' -f 9-100 )"
    fi
    Status_License="Not Activated"
fi
}

function script_version () {
        SC_Version="$( cat /etc/${Auther}/version.db )"
        Latest="$( curl -s https://${Server_URL}/mantap/bot/Latest-Version.txt )"
}

function os_detail () {
    OS_Name="$( cat /etc/os-release | grep -w ID | head -n1 | sed 's/ID//g' | sed 's/=//g' )"
    OS_FName="$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' | sed 's/,//g'  )"
    OS_Version="$( cat /etc/os-release | grep -w VERSION | head -n1 | sed 's/VERSION//g' | sed 's/=//g' | sed 's/"//g' )"
    OS_Version_ID="$( cat /etc/os-release | grep -w VERSION_ID | head -n1 | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/"//g' )"
    OS_Arch="$( uname -m )"
    OS_Kernel="$( uname -r )"
}

# =========================================================================================================
# // OpenSSH
openssh=$( systemctl status ssh | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $openssh == "running" ]]; then
    status_openssh="${GREEN}Running${NC} ( No Eror )"
else
    status_openssh="${RED}No Running${NC} ( Eror )"
fi

# // Stunnel5
stunnel5=$( systemctl status stunnel5 | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $stunnel5 == "running" ]]; then
    status_stunnel5="${GREEN}Running${NC} ( No Eror )"
else
    status_stunnel5="${RED}No Running${NC} ( Eror )"
fi

# // Dropbear
dropbear=$( systemctl status dropbear | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $dropbear == "running" ]]; then
    status_dropbear="${GREEN}Running${NC} ( No Eror )"
else
    status_dropbear="${RED}No Running${NC} ( Eror )"
fi

# // Squid
squid=$( systemctl status squid | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $squid == "running" ]]; then
    status_squid="${GREEN}Running${NC} ( No Eror )"
else
    status_squid="${RED}No Running${NC} ( Eror )"
fi

# // BadVPN
badvpn1=$( systemctl status udp-mini-1 | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $badvpn1 == "running" ]]; then
    status_badvpn1="${GREEN}Running${NC} ( No Eror )"
else
    status_badvpn1="${RED}No Running${NC} ( Eror )"
fi

# // BadVPN
badvpn2=$( systemctl status udp-mini-2 | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $badvpn2 == "running" ]]; then
    status_badvpn2="${GREEN}Running${NC} ( No Eror )"
else
    status_badvpn2="${RED}No Running${NC} ( Eror )"
fi

# // BadVPN
badvpn3=$( systemctl status udp-mini-3 | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $badvpn3 == "running" ]]; then
    status_badvpn3="${GREEN}Running${NC} ( No Eror )"
else
    status_badvpn3="${RED}No Running${NC} ( Eror )"
fi

# // OHP Proxy
ohp1=$( systemctl status ohp-mini-1 | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ohp1 == "running" ]]; then
    status_ohp1="${GREEN}Running${NC} ( No Eror )"
else
    status_ohp1="${RED}No Running${NC} ( Eror )"
fi

# // OHP Proxy
ohp2=$( systemctl status ohp-mini-2 | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ohp2 == "running" ]]; then
    status_ohp2="${GREEN}Running${NC} ( No Eror )"
else
    status_ohp2="${RED}No Running${NC} ( Eror )"
fi

# // OHP Proxy
ohp3=$( systemctl status ohp-mini-3 | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ohp3 == "running" ]]; then
    status_ohp3="${GREEN}Running${NC} ( No Eror )"
else
    status_ohp3="${RED}No Running${NC} ( Eror )"
fi

# // OHP Proxy
ohp4=$( systemctl status ohp-mini-4 | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ohp4 == "running" ]]; then
    status_ohp4="${GREEN}Running${NC} ( No Eror )"
else
    status_ohp4="${RED}No Running${NC} ( Eror )"
fi

# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-epro | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws_epro="${GREEN}Running${NC} ( No Eror )"
else
    status_ws_epro="${RED}No Running${NC} ( Eror )"
fi

# // SSLH Status
sslh=$( systemctl status sslh | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $sslh == "running" ]]; then
    status_sslh="${GREEN}Running${NC} ( No Eror )"
else
    status_sslh="${RED}No Running${NC} ( Eror )"
fi

# // Vmess Proxy
vmess1=$( systemctl status xray-mini@vmess-nontls | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $vmess1 == "running" ]]; then
    status_vmess_nontls="${GREEN}Running${NC} ( No Eror )"
else
    status_vmess_nontls="${RED}No Running${NC} ( Eror )"
fi

# // Vmess Proxy
vmess2=$( systemctl status xray-mini@vmess-tls | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $vmess2 == "running" ]]; then
    status_vmess_tls="${GREEN}Running${NC} ( No Eror )"
else
    status_vmess_tls="${RED}No Running${NC} ( Eror )"
fi

# // Vless Proxy
vless1=$( systemctl status xray-mini@vless-nontls | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $vless1 == "running" ]]; then
    status_vless_nontls="${GREEN}Running${NC} ( No Eror )"
else
    status_vless_nontls="${RED}No Running${NC} ( Eror )"
fi

# // Vless Proxy
vless2=$( systemctl status xray-mini@vless-tls | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $vless2 == "running" ]]; then
    status_vless_tls="${GREEN}Running${NC} ( No Eror )"
else
    status_vless_tls="${RED}No Running${NC} ( Eror )"
fi

# // Trojan Proxy
trojan1=$( systemctl status xray-mini@trojan | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $trojan1 == "running" ]]; then
    status_trojan="${GREEN}Running${NC} ( No Eror )"
else
    status_trojan="${RED}No Running${NC} ( Eror )"
fi

# // Trojan Proxy
ss=$( systemctl status xray-mini@shadowsocks | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ss == "running" ]]; then
    status_ss="${GREEN}Running${NC} ( No Eror )"
else
    status_ss="${RED}No Running${NC} ( Eror )"
fi

# // Status ShadowsocksR
PID=`ps -ef |grep "server.py" |grep -v "grep" |grep -v "init.d" |grep -v "service" |awk '{print $2}'`
if [[ ! -z ${PID} ]]; then
    status_ssr="${GREEN}Running${NC} ( No Eror )"
else
    status_ssr="${RED}No Running${NC} ( Eror )"
fi

# // Status wireguard
wg=$( systemctl status wg-quick@wg0 | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' )
if [[ $wg == "active" ]]; then
    status_wg="${GREEN}Running${NC} ( No Eror )"
else
    status_wg="${RED}No Running${NC} ( Eror )"
fi

# // Status PPTP
pptp=$( /etc/init.d/pptpd status | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $pptp == "running" ]]; then
    status_pptp="${GREEN}Running${NC} ( No Eror )"
else
    status_pptp="${RED}No Running${NC} ( Eror )"
fi

# // Status L2TP
l2tp=$( /etc/init.d/xl2tpd status | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $l2tp == "running" ]]; then
    status_l2tp="${GREEN}Running${NC} ( No Eror )"
else
    status_l2tp="${RED}No Running${NC} ( Eror )"
fi

# // Status SSTP
sstp=$( /etc/init.d/accel-ppp status | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $sstp == "running" ]]; then
    status_sstp="${GREEN}Running${NC} ( No Eror )"
else
    status_sstp="${RED}No Running${NC} ( Eror )"
fi
# =========================================================================================================

# // Running Function Requirement
os_detail
script_version
license_check

if [[ $Bot == "1" ]]; then
        bot='Allowed'
else
        bot='Not Allowed'
fi

if [[ $Beta == "1" ]]; then
        beta='Allowed'
else
        beta='Not Allowed'
fi

if [[ $Backup == "1" ]]; then
        backup='Allowed'
else
        backup='Not Allowed'
fi

# // Clear
clear
clear && clear && clear
clear;clear;clear

echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo -e "  Welcome To ${GREEN}Geo Project ${NC}Script Installer ${YELLOW}(${NC}${GREEN} Stable Edition ${NC}${YELLOW})${NC}"
echo -e "       This Script Coded On Bash & Python Language"
echo -e "     This Will Quick Setup VPN Server On Your Server"
echo -e "         Auther : ${GREEN}ADIT ARDIANSYAH ${NC}${YELLOW}(${NC} ${GREEN}Geo Project ${NC}${YELLOW})${NC}"
echo -e "       © Copyright By Geo Project ${YELLOW}(${NC} 2021-2022 ${YELLOW})${NC}"
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo ""
echo -e "${RED_BG}                     Sytem Information                    ${NC}"
echo -e "Sever Uptime        = $( uptime -p  | cut -d " " -f 2-10000 ) "
echo -e "Current Time        = $( date -d "0 days" +"%d-%m-%Y | %X" )"
echo -e "Script Version      = $( cat /etc/${Auther}/version.db )"
echo -e "Operating System    = ${OS_FName} ( ${OS_Arch} )"
echo -e "Current Domain      = $( cat /etc/${Auther}/domain.txt )"
echo -e "Server IP           = ${IP}"
echo ""

echo -e "${RED_BG}                  Subscription Information                ${NC}"
echo -e "License Key Status  = ${Status_License}"
echo -e "License Type        = ${Tipe} Edition"
echo -e "Bot Allowed         = ${bot}"
echo -e "Beta Allowed        = ${beta}"
echo -e "Backup Allowed      = ${backup}"
echo -e "License Issued to   = ${Issue_License}"
echo -e "License Start       = ${Start_License}"
echo -e "License Limit       = ${Limit_License} VPS"
echo -e "License Expired     = ${End_License} (${GREEN} $(if [[ ${Sisa_Hari} -lt 5 ]]; then
echo -e "$RED${Sisa_Hari} Days Left${NC}"; else
echo -e "${Sisa_Hari} Days Left"; fi
)${NC} )"
echo ""

echo -e "${RED_BG}                     Service Information                  ${NC}"
echo -e "OpenSSH             = $status_openssh"
echo -e "Dropbear            = $status_dropbear"
echo -e "Stunnel5            = $status_stunnel5"
echo -e "Squid               = $status_squid"
echo -e "BadVPN 7100         = $status_badvpn1"
echo -e "BadVPN 7200         = $status_badvpn2"
echo -e "BadVPN 7300         = $status_badvpn3"
echo -e "OHP OpenSSH         = $status_ohp1"
echo -e "OHP Dropbear        = $status_ohp2"
echo -e "OHP OpenVPN         = $status_ohp3"
echo -e "OHP Universal       = $status_ohp4"
echo -e "SSLH                = $status_sslh"
echo -e "SSH NonTLS          = $status_ws_epro"
echo -e "SSH TLS             = $status_ws_epro"
echo -e "OVPN TCP NonTLS     = $status_ws_epro"
echo -e "OVPN TCP TLS        = $status_ws_epro"
echo -e "VMESS NonTLS        = $status_vmess_nontls"
echo -e "VMESS TLS           = $status_vmess_tls"
echo -e "VLESS NonTLS        = $status_vless_nontls"
echo -e "VLESS XTLS          = $status_vless_tls"
echo -e "Trojan              = $status_trojan"
echo -e "Shadowsocks         = $status_ss"
echo -e "ShadowsocksR        = $status_ssr"
echo -e "Wireguard           = $status_wg"
echo -e "PPTP                = $status_pptp"
echo -e "L2TP                = $status_l2tp"
echo -e "SSTP                = $status_sstp"
echo ""
echo -e "${RED_BG}                        Geo Project                      ${NC}"
echo ""
