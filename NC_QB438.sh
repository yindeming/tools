#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <user> <password> <port> <qb_up_port>"
    exit 1
fi

USER=$1
PASSWORD=$2
PORT=$3
UP_PORT=$4

bash <(wget -qO- https://raw.githubusercontent.com/jerry048/Dedicated-Seedbox/main/Install.sh) -u $USER -p $PASSWORD -c 1500 -q 4.3.9 -l v1.2.19 -x
apt install -y curl htop vnstat
systemctl stop qbittorrent-nox@$USER
systemctl disable qbittorrent-nox@$USER
wget -O /usr/bin/qbittorrent-nox https://github.com/jerry048/Seedbox-Components/raw/refs/heads/main/Torrent%20Clients/qBittorrent/x86_64/Other/qBittorrent%204.3.8%20-%20libtorrent-v1.2.14/qbittorrent-nox
chmod +x /usr/bin/qbittorrent-nox
tune2fs -m 1 $(df -h / | awk 'NR==2 {print $1}') 
sed -i "s/WebUI\\Port=[0-9]*/WebUI\\Port=$PORT/" /home/$USER/.config/qBittorrent/qBittorrent.conf 
sed -i "s/Connection\\PortRangeMin=[0-9]*/Connection\\PortRangeMin=$UP_PORT/" /home/$USER/.config/qBittorrent/qBittorrent.conf 
sed -i "/\[Preferences\]/a General\\Locale=zh" /home/$USER/.config/qBittorrent/qBittorrent.conf 
sed -i "/\[Preferences\]/a Downloads\\PreAllocation=false" /home/$USER/.config/qBittorrent/qBittorrent.conf 
sed -i "/\[Preferences\]/a WebUI\\CSRFProtection=false" /home/$USER/.config/qBittorrent/qBittorrent.conf 
sed -i "s/disable_tso_/;/" /root/.boot-script.sh 
echo -e "\nsystemctl enable qbittorrent-nox@$USER && reboot" >> /root/BBRx.sh 
shutdown -r +1
