#!/bin/bash

# Check for root user
if [[ $EUID -ne 0 ]]; then
   echo "Error: Must be run as root (or sudo)" 
   exit 1
fi

read -p " -- Are you sure? [y/n, default n] " ANS
ANS=${ANS:-n}
if [ $(echo "$ANS" | awk '{print tolower($0)}') = "n" ] || [ $(echo "$ANS" | awk '{print tolower($0)}') = "no" ]; then
    echo " -- Aborting -- "
    exit 0
fi

# Get linux release
# 14.04 for Jetson TK1
# 16.04 for Rasp 3 and Rasp Zero
RELEASE=$(lsb_release -a | grep Release | awk '{print $2}')

# Disable systemd unit files
if [ "$RELEASE" == "14.04" ]; then
    update-rc.d timesyncd disable
    update-rc.d bringup disable
else
    systemctl disable timesyncd
    systemctl disable bringup
    systemctl disable sonar
fi

# Remove systemd unit files for bringup
echo " -- Removing systemd unit files and systemv init scripts -- "
rm -rf /etc/bringup
rm -f /etc/systemd/system/bringup.service
rm -f /etc/init.d/bringup

# Remove systemd unit files for sonar
rm -rf /etc/sonar
rm -f /etc/systemd/system/sonar.service

# Restore hosts file
echo " -- Restoring hosts file -- "
sed -i '6,$d' /etc/hosts
echo "127.0.1.1       $HOSTNAME" >> /etc/hosts

# Removing timesync daemon
echo " -- Removing timesync daemon -- "
rm -f /etc/systemd/system/timesyncd.service
rm -f /etc/init.d/timesyncd
rm -rf /etc/timesyncd
rm -f /usr/bin/timesyncd
rm -f /usr/lib/libublox.so

# Enable NTP services/scripts
update-rc.d ntp enable
update-rc.d chrony enable
if [ "$RELEASE" == "14.04" ]; then
    :
else
    systemctl enable systemd-timesyncd.service
fi

# Removing udev rules
echo " -- Removing udev rules -- "
rm -f /etc/udev/rules.d/10-peripherals.rules
udevadm control --reload-rules
udevadm trigger

# Remove this folder from /etc
echo " -- Removing setup files for configuration -- "
rm -rf /etc/setup

# Remove symbolic links to /usr/bin
echo " -- Removing symbolic links to install and configure scripts -- "
rm -f /usr/bin/asv_install
rm -f /usr/bin/asv_configure

echo " -- Done uninstalling -- "