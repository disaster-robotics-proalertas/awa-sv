#!/bin/bash

# Get processor architecture
# armv7l for Rasp 3 and Jetson TK1
# armv6l for Rasp Zero
PROC_REV=$(lscpu | grep Architecture | awk '{print $2}')

# Get linux release
# 14.04 for Jetson TK1
# 16.04 for Rasp 3 and Rasp Zero
RELEASE=$(lsb_release -a | grep Release | awk '{print $2}')

# Run install script based on architecture 
case $PROC_REV in
    # Raspberry Pi 3 and Jetson TK1
    "armv7l")
        if [ $RELEASE == "14.04" ]; then
            /bin/bash install/install_jetson
            exit 0
        else
            /bin/bash install/install_rasp
            exit 0
        fi
        ;;
    # Raspberry Pi Zero W
    "armv6l")
        /bin/bash install/install_zero
        exit 0
        ;;
    *)
        echo " -- Unsupported architecture -- "
        echo " -- Supported architectures for now are: "
        echo "      * armv6l "
        echo "      * armv7l "
        exit 1
        ;;
esac