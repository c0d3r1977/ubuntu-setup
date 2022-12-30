#!/bin/bash

ln -s /home/michael/vmware/vmware-autostart-macOSX.service /etc/systemd/system/vmware-autostart-macOSX.service
ln -s /home/michael/vmware/vmware-autostart-keddaServerVpn.service /etc/systemd/system/vmware-autostart-keddaServerVpn.service
systemctl daemon-reload
systemctl enable vmware-autostart-macOSX.service
systemctl enable vmware-autostart-keddaServerVpn.service
systemctl start vmware-autostart-macOSX.service
systemctl start vmware-autostart-keddaServerVpn.service

