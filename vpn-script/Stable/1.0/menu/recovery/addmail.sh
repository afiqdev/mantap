# // Clear
clear
clear && clear && clear
clear;clear;clear

export Auther="GeoVPN"

read -p "Input Your Email : " email
if [[ $email == "" ]]; then
    echo -e "${EROR} Please input Email"
    exit 1
fi
echo > /etc/${Auther}/email.json $email
sleep 3
echo -e " OKAY Email Has Ben Added"
