# modaclouds-integrated-platform

`modaclouds-integrated-platform` helps you to have a running MODAClouds Runtime Platform in already 
provisioned nodes.

1. Get your nodes
2. Install
3. Configure
4. Run


## Installation

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
* change hostname (how?)
* anything else?

From admin:

    $ sudo zypper install git
    
From the account you would like to use:

    $ git clone https://github.com/modaclouds/modaclouds-integrated-platform
    $ sudo modaclouds-integrated-platform/sbin/install-platform.sh

The last command adds mOS repo to the system, updates some system files, installs the components and configs any modaclouds service (e.g. create database in mysql for SLA Service)

##Configuration (v2 only)

    $ platform-config.sh <configfile> <thisnode>

TODO

##Running the components

For typing less, you can add the `modaclouds-runtime-platform` to the PATH:

    echo "PATH=\$PATH:$HOME/modaclouds-runtime-platform/bin" >> $HOME/.bashrc

These are the basic commands:

* `platform-start.sh`: starts all services defined in _platform-env.sh:instance_ids
* `platform-stop.sh`: stop all services 
* `platform-status.sh`: check status of services
* `platform-service.sh`: manages a single service (start/stop/status)

The logs are stored in `$HOME/var/log`. There is one log file per service.

NOTE: Not all components are added yet. This is ongoing work.
