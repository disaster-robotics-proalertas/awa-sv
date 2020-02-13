#!/bin/bash
source /opt/ros/kinetic/setup.bash

# If processor is Rasp Zero, don't source catkin workspace
PROC_REV=$(cat /proc/cpuinfo | grep Revision | awk '{print $3}')
if [ "$PROC_REV" == "9000c1" ]; then
    :
else
    source $CATKIN_PATH/devel/setup.bash
fi

sed -i "/sonar/ s/.*/$(/usr/bin/nmap -sP 192.168.1.0/24 >/dev/null && arp -an | grep 98:7b:f3:1b:d4:f9 | awk '{print $2}' | sed 's/[()]//g')\tsonar/g" /etc/hosts
roslaunch ros_nmea_depth lowrance.launch