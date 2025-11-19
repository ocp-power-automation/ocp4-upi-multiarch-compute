#!/bin/bash

dnf install -y dnsmasq httpd
systemctl daemon-reload

systemctl enable httpd
systemctl enable dnsmasq

systemctl start httpd
systemctl start dnsmasq
systemctl restart NetworkManager

mkdir -p /var/www/html/ignition
sudo curl -k -H "Accept: application/vnd.coreos.ignition+json;version=3.4.0" -o /var/www/html/ignition/worker.ign https://${1}:22623/config/worker
sudo restorecon -r /var/www/html/ignition
