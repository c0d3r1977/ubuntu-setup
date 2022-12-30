#!/bin/bash

WDIR=${PWD}

apt update -y
apt upgrade -y
#apt install mousepad -y

read -p "Starting drive expansion"
#lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
#resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv

#not necessary if configured during install
mkdir /storage
mkdir /backup
echo 'UUID=B6E2BFDDE2BFA053 /storage auto nosuid,nodev,nofail,x-gvfs-show,uid=1000,gid=1000 0 0' | tee -a /etc/fstab
echo 'UUID=72CEC90FCEC8CC93 /backup auto nosuid,nodev,nofail,x-gvfs-show,uid=1000,gid=1000 0 0' | tee -a /etc/fstab

read -p "Starting Cups"
apt install cups -y
systemctl start cups
systemctl enable cups
cp cupsd.conf /etc/cups/
systemctl restart cups
mkdir /home/michael/printer
cd /home/michael/printer
wget https://download.brother.com/welcome/dlf006893/linux-brprinter-installer-2.2.3-1.gz
gunzip /home/michael/printer/linux-brprinter-installer-2.2.3-1.gz
bash /home/michael/printer/linux-brprinter-installer-2.2.3-1
usermod -a -G lpadmin michael
rm -rf /home/michael/printer

cd $WDIR

read -p "Starting Samba"
mkdir upload
chmod 777 upload
apt install samba -y
systemctl start smbd
systemctl enable smbd
mv /etc/samba/smb.conf /etc/samba/smb-original-conf
cp smb.conf /etc/samba/
systemctl restart smbd
smbpasswd -a
smbpasswd -a michael
smbpasswd -e
smbpasswd -e michael
systemctl restart smbd
apt install cifs-util

read -p "Starting Docker - make sure /home/michael/docker restored"
apt install docker -y
apt install docker-compose -y
apt install acl -y
chmod 775 /home/michael/docker
setfacl -Rm g:docker:rwx /home/michael/docker
chown root:root /home/michael/docker/.env
chmod 0600 /home/michael/docker/.env

read -p "Starting Edge"
#for edge
apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" -y
apt update -y
apt install microsoft-edge-stable -y

read -p "Setting Up Cronttab"
crontab sudo-crontab.conf

#read -p "Install channels to machine instead of docker
#sudo apt install curl -y
#curl -f -s https://getchannels.com/dvr/setup.sh | sh
#sudo adduser $(id -u -n) video && sudo adduser $(id -u -n) render
#sudo apt-get install chromium-browser xvfb
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#sudo dpkg -i google-chrome-stable_current_amd64.deb

#read -p "Install Google Remote Desktop"
#sudo wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
#sudo dpkg --install chrome-remote-desktop_current_amd64.deb
#sudo apt install -y --fix-broken
#sudo usermod -a -G chrome-remote-desktop $USER
#https://remotedesktop.google.com/headless

read -p "Starting xrdp"
apt install xrdp -y
sed -i 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini

read -p "Starting rclone"
apt install rclone -y
rclone config


#for xorg, openbox
#read -p "Starting xorg, openbox, xrdp and startx"
#cp 45-allow-colord.pkla /etc/polkit-1/localauthority/50-local.d/ <- only necessary in ubuntu-desktop
#apt install xorg -y
#apt install openbox -y
#apt install pcmanfm -y
#apt install mousepad -y
#touch /root/.Xauthority
#sed -i 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini
#sed -i 's/console/anybody/g' /etc/X11/Xwrapper.config
#cp menu.xml /etc/xdg/openbox/
#cp rc.xml /etc/xdg/openbox/
#echo 'pcmanfm --desktop &' | tee -a /etc/xdg/openbox/autostart
#read -p "Run StartX as michael"
