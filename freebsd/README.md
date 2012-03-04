Description
===========

Handles FreeBSD-specific features and quirks.

Requirements
============

Platform
--------

* FreeBSD

Tested on FreeBSD 7.2, 8.0, 8.1, 8.2 and 9.0.

Attributes
==========

Resources/Providers
===================

The port\_options LWRP provides an easy way to set port options from within a cookbook.

It can be used in two different ways:

* template-based: specifying a source will write it to the correct destination with no change;
* options hash: if a options hash is passed instead, it will be merged on top of default and current options, and the result will be written back.

Note that the options hash take simple options names as keys and a boolean as value; when saving
to file, this is converted to the format that FreeBSD ports expect:

    | LWRP option name | value | options file        |
    | APACHE           | true  | WITH_APACHE=true    |
    | APACHE           | false | WITHOUT_APACHE=true |

# Actions

- :create: create the port options file according to the given options. Default action.

# Attribute Parameters

- name: name attribute. The name of the port whose options file you want to manipulate;
- source: if the attribute is set, it will be used to look up a template, which will then be saved as a port options file;
- options: a hash with the option name as the key, and a boolean as value.

# Examples

    # freebsd-php5-options will be written out as /var/db/ports/php5/options
    freebsd_port_options "php5" do
      source "freebsd-php5-options.erb"
      action :create
    end

    # Default options will be read from /usr/ports/lang/php5;
    # current options from /var/db/ports/php5/options (if exists);
    # the APACHE options will be set to true, the others will be unchanged
    freebsd_port_options "php5" do
      options "APACHE" => true
      action :create
    end

Usage
=====

