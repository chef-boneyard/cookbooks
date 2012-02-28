## v1.2.4

* [COOK-992] - fix FATAL nameerror
* [COOK-827] - `mysql:server_ec2` recipe can't mount `data_dir`
* [COOK-945] - FreeBSD support

## v1.2.2

* [COOK-826] mysql::server recipe doesn't quote password string
* [COOK-834] Add 'scientific' and 'amazon' platforms to mysql cookbook

## v1.2.1

* [COOK-644] Mysql client cookbook 'package missing' error message is confusing
* [COOK-645] RHEL6/CentOS6 - mysql cookbook contains 'skip-federated' directive which is unsupported on MySQL 5.1

## v1.2.0

* [COOK-684] remove mysql_database LWRP

## v1.0.8:

* [COOK-633] ensure "cloud" attribute is available

## v1.0.7:

* [COOK-614] expose all mysql tunable settings in config
* [COOK-617] bind to private IP if available

## v1.0.6:

* [COOK-605] install mysql-client package on ubuntu/debian

## v1.0.5:

* [COOK-465] allow optional remote root connections to mysql
* [COOK-455] improve platform version handling
* externalize conf_dir attribute for easier cross platform support
* change datadir attribute to data_dir for consistency

## v1.0.4:

* fix regressions on debian platform
* [COOK-578] wrap root password in quotes
* [COOK-562] expose all tunables in my.cnf
