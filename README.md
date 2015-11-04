# modaclouds-integrated-platform

The MODAClouds integrated platform is composed of:

* [Design time environment - Creator 4Clouds](#design-time-platform)
* [Runtime environment - Energizer 4Clouds](#runtime-platform--emergizer-4clouds)

# Design Time Platform

You can download a [https://hub.docker.com/r/deibpolimi/modaclouds-designtime/](Docker image of Creator 4Clouds) with all the needed components ready to run. Follow the steps in the link to install docker and run the Docker image. When the image is running it opens a Remote Desktop server. You can connect to it (using Remote Desktop Connection in Windows, for example) using the `modaclouds` password. Now you are in.

# Runtime Platform

`modaclouds-integrated-platform` helps you to have a running MODAClouds Runtime Platform in already 
provisioned nodes.

1. Get your nodes
2. Install
3. Configure
4. Run


## Quick Start Guide ##

(Detailed Guide below)

    sudo zypper install git
    git clone https://github.com/modaclouds/modaclouds-integrated-platform
    sudo modaclouds-integrated-platform/sbin/install-platform.sh node1

    echo "PATH=\$PATH:$HOME/modaclouds-integrated-platform/bin" >> $HOME/.bashrc
    . $HOME/.bashrc

    platform-config.sh $HOME/modaclouds-integrated-platform/lib/config-1vm.sh node1
    platform-start.sh

## Installation

You have to follow this installation step for each VM.

You have to choose a hostname avoiding underscores ('\_') and dash ('-') characters.
The easiest way to start is using `node1` as hostname. 
This way, there is no need to change the configuration file.

The following steps are suitable for any OpenSuse13.1 image (change node1 for your chosen hostname).

    $ sudo zypper install git
    $ git clone https://github.com/modaclouds/modaclouds-integrated-platform
    $ sudo modaclouds-integrated-platform/sbin/install-platform.sh node1

    $ echo "PATH=\$PATH:$HOME/modaclouds-integrated-platform/bin" >> $HOME/.bashrc
    $ . $HOME/.bashrc

The install-platform command adds mOS repo to the system, updates some system files, installs the components and configs any modaclouds service (e.g. create database in mysql for SLA Service). 

**IMPORTANT**:

* It modifies /etc/HOSTNAME and and a line in /etc/hosts. Please check the values are right, especially if
  you had to run the script several times.
* Avoid hostnames with underscore ('\_') or dash ('-') characters.


##Configuration

After the installation, a little configuration step is needed in each VM to know the addresses 
of the VMs and what services will run in each one. This script must be run every time you want to 
redistribute the services among VMs, or a node address changes.

    $ platform-config.sh <configfile> <nodeid>

You have several configfiles in ~/modaclouds-integrated-platform/lib/config-\* files. Select the one that better fits the 
distribution you need and modify it:

* In _addresses_ var, change the address for the node.
* For each node in _addresses_ var, there must be an _instances_ var.

The file you use will be copied to ~/.modaclouds/config.sh,
so the next time you need to reconfigure, you can simply use:

    $ platform-config.sh ~/.modaclouds/config.sh <nodeid>


##Running the components

For typing less, you can add the `modaclouds-integrated-platform` to the PATH:


These are the basic commands:

* `platform-start.sh`: starts all services defined in \_platform-env.sh:instance\_ids
* `platform-stop.sh`: stop all services 
* `platform-status.sh`: check status of services
* `platform-service.sh`: manages a single service (start/stop/status)

The logs are stored in `$HOME/var/log`. There is one log file per service.

## Updating from v1.0 to v2.0

You may have a hostname not suitable for v2 that was not a problem in v1 (remember: no '\_' or '-' are allowed. To modify the hostname, follow these steps:

    $ sudo su
    # HOSTNAME=node1
    # echo $HOSTNAME > /etc/HOSTNAME
    # hostname -F /etc/HOSTNAME

The easiest way to start is using `node1` as hostname. This way, there is no need to change the configuration file.

You also must have an entry in /etc/hosts for that hostname associated to the IP of the network interface. Do not use localhost. The line to add/modify should be like:

    192.168.1.1 node1.localdomain node1

You only have to update your code and run the configuration script using the config file of your needs. In the following, we will use the configuration file using a single VM:

    cd ~/modaclouds-integrated-platform
    git pull
    platform-config ~/modaclouds-integrated-platform ~/modaclouds-integrated-platform/lib/config1-vm.sh

Check the content of `bin/_common.sh` file. It should have VERSION variable greater or equal than 2.0. See the Configuration section for more details about the last step.

## License ##

Licensed under the [Apache License, Version 2.0][1]

[1]: http://www.apache.org/licenses/LICENSE-2.0
