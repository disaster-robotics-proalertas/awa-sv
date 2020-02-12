#!/bin/bash

source /opt/ros/kinetic/setup.bash

# If processor is Rasp Zero, don't source catkin workspace
PROC_REV=$(cat /proc/cpuinfo | grep Revision | awk '{print $3}')
if [ "$PROC_REV" == "9000c1" ]; then
    continue
else
    source $CATKIN_PATH/devel/setup.bash
fi

roslaunch asv_bringup minimal.launch