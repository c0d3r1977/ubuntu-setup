#!/bin/bash

#for vmware - run modconfig after install
read -p "VMware setup - rdp first! - ensure /home/michael/vmware exists"
apt install gcc -y
apt install build-essential -y
cd /home/michael/vmware
chmod +x /VMware-Workstation-Full-16.2.4-20089737.x86_64.bundle
./VMware-Workstation-Full-16.2.4-20089737.x86_64.bundle
chmod +x /home/michael/vmware/unlocker/lnx-install.sh
cd /home/michael/vmware/unlocker
./lnx-install.sh
vmware-modconfig --console --install-all
#xauth add $(xauth -f ~michael/.Xauthority list|tail -1)
cp /home/michael/vmware/vmware-autostarts /etc/init.d/vmware-autostarts
chmod +x /etc/init.d/vmware-autostarts
sudo update-rc.d vmware-autostarts defaults
vmware
