# modaclouds-flexiant-platform

Scripts to facilitate use of the MODAClouds integrated platform in Flexiant.

Sbin scripts:

* install-platform.sh: additional installation from OpenSuse13.1 image in Flexiant

Bin scripts. These are for running the services. The important scripts for a user are:

* _platform-env.sh: stores needed variables for running the platform.
* platform-start.sh: starts all services defined in _platform-env.sh:instance_ids
* platform-stop.sh: stop all services 
* platform-status.sh: check status of services
* platform-service.sh: manages a single service (start/stop/status)
