#!/bin/bash

source /opt/ros/kinetic/setup.bash

# If processor is Rasp 3
PROC_REV=$(cat /proc/cpuinfo | grep Revision | awk '{print $3}')
if [ "$PROC_REV" == "a22082" ]; then
    source /home/pi/ros_wps/devel/setup.bash
fi

roslaunch asv_bringup minimal.launch