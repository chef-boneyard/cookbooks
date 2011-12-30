Description
===========

Configures a server to be an OpenLDAP master, OpenLDAP replication
slave, or OpenLDAP client.

Requirements
============

## Platform:

Ubuntu 8.10 was primarily used in testing this cookbook. Other Ubuntu
versions and Debian may work. CentOS and Red Hat are not fully
supported, but we take patches.

## Cookbooks:

* openssh 
* nscd

Attributes
==========

Be aware of the attributes used by this cookbook and adjust the
defaults for your environment where required, in
attributes/openldap.rb.

## Client node attributes

* `openldap[:basedn]` - basedn 
* `openldap[:server]` - the LDAP server fully qualified domain name,
  default `'ldap'.node[:domain]`.

## Server node attributes

* `openldap[:slapd_type]` - master | slave
* `openldap[:slapd_rid]` - unique integer ID, required if type is slave.
* `openldap[:slapd_master]` - hostname of slapd master, attempts to
  search for slapd_type master.

## Apache configuration attributes

Attributes useful for Apache authentication with LDAP.

COOK-128 - set automatically based on openldap[:server] and
openldap[:basedn] if those attributes are set. openldap[:auth_bindpw]
remains nil by default as a default value is not easily predicted.

* `openldap[:auth_type]` - determine whether binddn and bindpw are
  required (openldap no, ad yes)
* `openldap[:auth_url]` - AuthLDAPURL
* `openldap[:auth_binddn]` - AuthLDAPBindDN
* `openldap[:auth_bindpw]` - AuthLDAPBindPassword

Usage
=====

Edit Rakefile variables for SSL certificate.

On client systems, 

    include_recipe "openldap::auth"
  
This will get the required packages and configuration for client
systems. This will be required on server systems as well, so this is a
good candidate for inclusion in a base role.

On server systems, set the server node attributes in the Chef node, or
in a JSON attributes file. Include the openldap::server recipe:

    include_recipe "openldap::server"
  
When initially installing a brand new LDAP master server on Ubuntu
8.10, the configuration directory may need to be removed and recreated
before slapd will start successfully. Doing this programmatically may
cause other issues, so fix the directory manually :-).

    $ sudo slaptest -F /etc/ldap/slapd.d
    str2entry: invalid value for attributeType objectClass #1 (syntax 1.3.6.1.4.1.1466.115.121.1.38)
    => ldif_enum_tree: failed to read entry for /etc/ldap/slapd.d/cn=config/olcDatabase={1}bdb.ldif
    slaptest: bad configuration directory!

Simply remove the configuration, rerun chef-client. For some reason
slapd isn't getting started even though the service resource is
notified to start, so start it manually.

    $ sudo rm -rf /etc/ldap/slapd.d/ /etc/ldap/slapd.conf
    $ sudo chef-client
    $ sudo /etc/init.d/slapd start
  
### A note about certificates

Certificates created by the Rakefile are self signed. If you have a
purchased CA, that can be used. Be sure to update the certificate
locations in the templates as required. We suggest copying this
cookbook to the site-cookbooks for such modifications, so you can
still pull from our master for updates, and then merge your changes
in.
  
## New Directory:

If installing for the first time, the initial directory needs to be created. Create an ldif file, and start populating the directory.
  
## Passwords:

Set the password, openldap[:rootpw] for the rootdn in the node's attributes. This should be a password hash generated from slappasswd. The default slappasswd command on Ubuntu 8.10 and Mac OS X 10.5 will generate a SHA1 hash:

    $ slappasswd -s "secretsauce"
    {SSHA}6BjlvtSbVCL88li8IorkqMSofkLio58/
  
Set this by default in the attributes file, or on the node's entry in the webui.  
  
License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Copyright:: 2009, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
