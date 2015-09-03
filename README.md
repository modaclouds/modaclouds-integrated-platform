# modaclouds-integrated-platform

`modaclouds-integrated-platform` helps you to have a running MODAClouds Runtime Platform in already 
provisioned nodes.

1. Get your nodes
2. Install
3. Configure
4. Run


## Installation

You have to follow this installation step for each VM.

These steps are suitable for any OpenSuse13.1 image.

There is such an image ready in Flexiant, called OpenSuse13.1_v0, shared with MODAClouds group. This image is the same image in OpenSuse repositories, with some configuration:

* admin and root password are the same. Send an email to info@modaclouds.eu to obtain it.
* admin can use sudo without password
* there is a developer account if you want to use it (if not, skip steps related to developer). To switch user to developer: `sudo su - developer`

You are advised to:

* change root&admin&developer password
* upload your public keys
  * `ssh-copy-id admin@IP`
  * `ssh-copy-id developer@IP`
* anything else?

From admin:

    $ sudo zypper install git
    
From the account you would like to use:

    $ git clone https://github.com/modaclouds/modaclouds-integrated-platform
    $ sudo modaclouds-integrated-platform/sbin/install-platform.sh <vm-hostname>

The last command adds mOS repo to the system, updates some system files, installs the components and configs any modaclouds service (e.g. create database in mysql for SLA Service). 

**IMPORTANT**:

* It modifies /etc/HOSTNAME and and a line in /etc/hosts. Please check the values are right, especially if
  you had to run the script several times.
* Avoid hostnames with underscore ('\_') or dash ('-') characters.


##Configuration

After the installation, a little configuration step is needed in each VM to know the addresses 
of the VMs and what services will run in each one. This script must be run every time you want to 
redistribute the services among VMs, or a node address changes.

    $ platform-config.sh <configfile>

You have several configfiles in ~/modaclouds/lib/config-\* files. Select the one that better fits the 
distribution you need and modify it:
* In _addresses_ var, enter a line for each node, with the *hostname* and its address.
* For each node in _addresses_ var, there must be an _instances_ var prefixed with the hostname.

The file you use will be copied to ~/.modaclouds/config.sh,
so the next time you need to reconfigure, you can simply use:

    $ platform-config.sh ~/.modaclouds/config.sh

**NOTE**: The script knows the current node by reading the contents of /etc/HOSTNAME, so it is important
to match the names in the config file with the hostname.


##Running the components

For typing less, you can add the `modaclouds-integrated-platform` to the PATH:

    echo "PATH=\$PATH:$HOME/modaclouds-integrated-platform/bin" >> $HOME/.bashrc

These are the basic commands:

* `platform-start.sh`: starts all services defined in \_platform-env.sh:instance\_ids
* `platform-stop.sh`: stop all services 
* `platform-status.sh`: check status of services
* `platform-service.sh`: manages a single service (start/stop/status)

The logs are stored in `$HOME/var/log`. There is one log file per service.

