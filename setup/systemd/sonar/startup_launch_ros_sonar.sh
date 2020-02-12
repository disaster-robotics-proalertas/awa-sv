#!/bin/bash
source /opt/ros/kinetic/setup.bash

sed -i "/sonar/ s/.*/$(/usr/bin/nmap -sP 192.168.1.0/24 >/dev/null && arp -an | grep 98:7b:f3:1b:d4:f9 | awk '{print $2}' | sed 's/[()]//g')\tsonar/g" /etc/hosts
roslaunch ros_nmea_depth lowrance.launch