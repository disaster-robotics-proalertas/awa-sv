# Autonomous Water Assessment Surface Vehicle (AWA-SV)
 
This meta-repository contains a collection of repositories for the software environment of the Autonomous Water Assessment Surface Vehicle (AWA-SV), developed at the Autonomous Systems Lab ([LSA](https://lsa-pucrs.github.io/)), [PUCRS](http://www.pucrs.br/), Brazil. The AWA-SV was designed to perform water quality measurements, bathymetry and surface-level video recording (stereo, RGB and thermal), primarily in riverine environments, for scientific research and technological development applications. For more information, visit the vehicle's [wiki page]().

## Disclaimer

The vehicle was developed and tested using [Raspberry Pi 3](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/), [NAVIO 2](https://emlid.com/br/navio/) and [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/) boards. The software environment was developed and tested using the [Raspbian Stretch] and Ubuntu operating systems, as well as ROS [Indigo](http://wiki.ros.org/indigo)/[Kinetic](http://wiki.ros.org/kinetic). Thus, **we can not guarantee this setup will work with other boards, processor architectures, OSes and/or ROS versions**.

## Getting started

This tutorial assumes you have successfully replicated the vehicle physically, using the [mechanical]() and [hardware]() specifications in the [wiki page](). As the AWA-SV has a centralized processing network, the central computer will be referred to as "master", while the peripheral computers will be referred to as "modules". The setup instructions for master and modules are the same, otherwise specified.

1. Follow the steps [here](), to download and clone a NAVIO raspbian image to a microSD card (preferrably with more than 16 GB).

2. Enable ssh by creating an empty file named "ssh" on the root directory of the boot partition of the microSD card.

3. Enable wpa_supplicant by creating a file named "wpa_supplicant" on the root directory of the boot partition of the microSD card. Fill it out as:

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=BR      # Or your country, for example, GB

network={
     ssid="Your network name/SSID"
     psk="Your WPA/WPA2 security key"
     key_mgmt=WPA-PSK
}
```

4. Unmount the microSD card and plug it into your master/module computer (Raspberry Pi 3 or Zero W, for example).

5. Connect power and turn on the vehicle.

6. Install nmap:

```
$ sudo apt-get install nmap
```

7. Locate your master/module's IP address using nmap. It should show up as "Raspberry Pi Foundation":

```
$ sudo nmap -sP <your_network_ip_range>/<netmask>

Starting Nmap 7.01 ( https://nmap.org ) at ...
Nmap scan report for ...
Host is up (0.0018s latency).
MAC Address: ... (Technicolor CH USA)
Nmap scan report for <YOUR_RASPBERRY_PI_IP>
Host is up (1.1s latency).
MAC Address: ... (Raspberry Pi Foundation)
Nmap scan report for ...
Host is up (0.0027s latency).
Nmap done: 256 IP addresses (3 hosts up) scanned in 11.74 seconds
```

More information on how to use nmap [here](https://www.tecmint.com/nmap-command-examples/).

8. Log in to the master/module using SSH (default username for NAVIO raspbian is "pi", password "raspberry"):

```
$ ssh pi@<YOUR_RASPBERRY_PI_IP>
```

9. On the raspberry, change the master/module's hostname as desired. For example, for awa1:

```
$ sudo echo "awa1" > /etc/hostname
```

10. Reboot for the hostname change to take effect:

```
$ sudo reboot
```

11. Log in to the master/module once again with SSH (as in step 8).

12. Install ROS. For raspbian on Raspberry Pi 3, [follow these instructions](http://wiki.ros.org/kinetic/Installation/Ubuntu). For raspbian on Raspberry Pi 1 or Zero (W), [follow these instructions](http://wiki.ros.org/ROSberryPi/Installing%20ROS%20Kinetic%20on%20the%20Raspberry%20Pi). For TegraK1 Ubuntu (jetson1 and jetson2 modules), [follow these instructions](http://wiki.ros.org/indigo/Installation/UbuntuARM).

13. Create and initialize a catkin workspace. For raspbian on Pi 1/Zero/Zero W, this will be done during the installation procedure in step 12. For Pi 3/Ubuntu, [follow these instructions](http://wiki.ros.org/ROS/Tutorials/InstallingandConfiguringROSEnvironment#Create_a_ROS_Workspace).

13. Clone this repository:

```
$ git clone https://github.com/disaster-robotics-proalertas/awa-sv/ $HOME/awa-sv
```

14. Go into the repository and run:

```
$ cd $HOME/awa-sv
$ git submodule update --init
```

15. Go into the "setup" folder and run the "install" script as root:

```
$ cd $HOME/awa-sv/setup
$ sudo ./install
```

The installation procedure creates symbolic links for the install and configuration scripts. You can run them anywhere in the master/module with the "asv_install" and "asv_configure" commands respectively.

16. After installation finishes, you can configure your master/module. Basic usage of the configuration script is:

```
$ sudo asv_configure <master_name> [MODULES]
```

For example, for configuration of the master "awa1", with the "quality1" and "sampler" modules:

```
$ sudo asv_configure awa1 quality1 sampler
```

If possible, the script performs remote configuration and rebooting of the specified modules.

Typically when configuring modules, only the master name is specified, with no other modules. For example, configuring the "quality1" module:

```
$ ssh pi@<quality1_IP_address>
$ sudo asv_configure awa1
```

To change modules, log into the master and run the "asv_configure" command as above, changing the desired modules. For example, for "awa1" with the "sampler" and "jetson1" modules:

```
$ sudo asv_configure awa1 sampler jetson1
```

## Acknowledgements

* ETH Zurich Autonomous System Lab's [System monitoring tools for ROS](https://github.com/ethz-asl/ros-system-monitor) package.

## Contributors

* [Renan Maidana](https://github.com/rgmaidana)
* [Guilherme Heck](https://github.com/heckgui)
* [Alexandre Amory](https://github.com/amamory)
* [Igor Souza](https://github.com/igorSouzaA)
