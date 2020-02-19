#!/bin/bash

export $(grep -ri SYSTEM_NAME /etc/bringup/environment)
export $(grep -ri MASTER_NAME /etc/bringup/environment)
export $(grep -ri ROS_MASTER_URI /etc/bringup/environment)
export $(grep -ri ROS_HOSTNAME /etc/bringup/environment)
export $(grep -ri CATKIN_PATH /etc/bringup/environment)
source /opt/ros/indigo/setup.bash
source $CATKIN_PATH/devel/setup.bash

roslaunch asv_bringup minimal.launch