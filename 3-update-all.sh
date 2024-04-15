#!/bin/bash
#rm -rf /var/lib/dpkg/lock-frontend
#rm -rf /var/lib/dpkg/lock
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo flatpak update -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y
echo "===== Finished ====="
read
