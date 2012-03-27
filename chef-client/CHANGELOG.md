## v1.1.2:

* [COOK-1039] - support mac_os_x_server

## v1.1.0:

* [COOK-909] - trigger upstart on correct event
* [COOK-795] - add windows support with winsw
* [COOK-798] - added recipe to run chef-client as a cron job
* [COOK-986] - don't delete the validation.pem if chef-server recipe
  is detected

## v1.0.4:

* [COOK-670] - Added Solaris service-installation support for chef-client cookbook.
* [COOK-781] - chef-client service recipe fails with chef 0.9.x

## v1.0.2:

* [CHEF-2491] init scripts should implement reload

## v1.0.0:

* [COOK-204] chef::client pid template doesn't match package expectations
* [COOK-491] service config/defaults should not be pulled from Chef gem
* [COOK-525] Tell bluepill to daemonize chef-client command
* [COOK-554] Typo in backup_path
* [COOK-609] chef-client cookbook fails if init_type is set to upstart and chef is installed from deb
* [COOK-635] Allow configuration of path to chef-client binary in init script
