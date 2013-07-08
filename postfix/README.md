Description
===========

Installs and configures postfix for client or outbound relayhost, or
to do SASL authentication.

On RHEL-family systems, sendmail will be replaced with postfix.

Requirements
============

## Platform:

* Ubuntu 10.04+
* Debian 6.0+
* RHEL/CentOS/Scientific 5.7+, 6.2+
* Amazon Linux (as of AMIs created after 4/9/2012)

May work on other platforms with or without modification.

Attributes
==========

See `attributes/default.rb` for default values.

* `node['postfix']['mail_type']` - Sets the kind of mail
  configuration. `master` will set up a server (relayhost).
* `node['postfix']['myhostname']` - corresponds to the myhostname
  option in `/etc/postfix/main.cf`.
* `node['postfix']['mydomain']` - corresponds to the mydomain option
  in `/etc/postfix/main.cf`.
* `node['postfix']['myorigin']` - corresponds to the myorigin option
  in `/etc/postfix/main.cf`.
* `node['postfix']['relayhost']` - corresponds to the relayhost option
  in `/etc/postfix/main.cf`.
* `node['postfix']['relayhost_role']` - name of a role used for search
  in the client recipe.
* `node['postfix']['multi_environment_relay']` - set to true if nodes
  should not constrain search for the relayhost in their own
  environment.
* `node['postfix']['inet_interfaces']` - if set, corresponds to the
  inet_interfaces option in `/etc/postfix/main.cf`. nil by default,
  which will result in 'all' for master `mail_type` and
  'loopback-only' for non-master (anything else) `mail_type`.
* `node['postfix']['mail_relay_networks']` - corresponds to the
  mynetworks option in `/etc/postfix/main.cf`.
* `node['postfix']['smtpd_use_tls']` - set to "yes" to use TLS for
  SMTPD, which will use the snakeoil certs.
* `node['postfix']['smtp_sasl_auth_enable']` - set to "yes" to enable
  SASL authentication for SMTP.
* `node['postfix']['smtp_sasl_password_maps']` - corresponds to the
  `smtp_sasl_password_maps` option in `/etc/postfix/main.cf`.
* `node['postfix']['smtp_sasl_security_options']` - corresponds to the
  `smtp_sasl_security_options` option in `/etc/postfix/main.cf`.
* `node['postfix']['smtp_tls_cafile']` - corresponds to the
  `smtp_tls_CAfile` option in `/etc/postfix/main.cf`.
* `node['postfix']['smtp_use_tls']` - corresponds to the
  `smtp_use_tls` option in `/etc/postfix/main.cf`.
* `node['postfix']['smtp_sasl_user_name']` - mapped in the
  `sasl_passwd` file as the user to authenticate as.
* `node['postfix']['smtp_sasl_passwd']` - mapped in the `sasl_passwd`
  file as the password to use.
* `node['postfix']['aliases']` - hash of aliases to create with
  `recipe[postfix::aliases]`, see below under __Recipes__ for more
  information.
* `node['postfix']['use_procmail']` - set to true if nodes should use
  procmail as the delivery agent (mailbox_command).
* `node['postfix']['milter_default_action']` - corresponds to the
  `milter_default_action` option in `/etc/postfix/main.cf`.
* `node['postfix']['milter_protocol']` - corresponds to the
  `milter_protocol` option in `/etc/postfix/main.cf`.
* `node['postfix']['smtpd_milters']` - corresponds to the
  `smtpd_milters` option in `/etc/postfix/main.cf`.
* `node['postfix']['non_smtpd_milters']` - corresponds to the
  `non_smtpd_milters` option in `/etc/postfix/main.cf`.
* `node['postfix']['inet_interfaces']` - interfaces to listen to, all
  or loopback-only
* `node['postfix']['sender_canonical_classes']` - controls what
  addresses are subject to `sender_canonical_maps` address mapping,
  specify one or more of: `envelope_sender`, `header_sender` - defaults to
  nil
* `node['postfix']['recipient_canonical_classes']` - controls what
  addresses are subject to `recipient_canonical_maps` address mapping,
  specify one or more of: `envelope_recipient`, `header_recipient` -
  defaults to nil
* `node['postfix']['canonical_classes']` - controls what addresses are
  subject to `canonical_maps` address mapping, specify one or more of:
  `envelope_sender`, `envelope_recipient`, `header_sender`,
  `header_recipient` - defaults to nil
* `node['postfix']['sender_canonical_maps']` - optional address
  mapping lookup tables for envelope and header sender addresses, eg.
  `hash:/etc/postfix/sender_canonical` - defaults to nil
* `node['postfix']['recipient_canonical_maps']` - optional address
  mapping lookup tables for envelope and header recipient addresses,
  eg. `hash:/etc/postfix/recipient_canonical` - defaults to nil
* `node['postfix']['canonical_maps']` - optional address mapping
  lookup tables for message headers and envelopes, eg.
  `hash:/etc/postfix/canonical` - defaults to nil

Recipes
=======

default
-------

Installs the postfix package and manages the service and the main
configuration files (`/etc/postfix/main.cf` and
`/etc/postfix/master.cf`). See __Usage__ and __Examples__ to see how
to affect behavior of this recipe through configuration.

For a more dynamic approach to discovery for the relayhost, see the
`client` and `server` recipes below.

client
------

Use this recipe to have nodes automatically search for the mail relay
based which node has the `node['postfix']['relayhost']` role. Sets the
`node['postfix']['relayhost']` attribute to the first result from the
search.

Includes the default recipe to install, configure and start postfix.

Does not work with `chef-solo`.

sasl\_auth
----------

Sets up the system to authenticate with a remote mail relay using SASL
authentication.

server
------

To use Chef Server search to automatically detect a node that is the
relayhost, use this recipe in a role that will be relayhost. By
default, the role should be "relayhost" but you can change the
attribute `node['postfix']['relayhost_role']` to modify this.

**Note** This recipe will set the `node['postfix']['mail_type']` to
"master" with an override attribute.

aliases
-------

Manage `/etc/aliases` with this recipe. Currently only Ubuntu 10.04
platform has a template for the aliases file. Add your aliases
template to the `templates/default` or to the appropriate
platform+version directory per the File Specificity rules for
templates. Then specify a hash of aliases for the
`node['postfix']['aliases']` attribute.
Arrays are supported as alias values, since postfix supports
comma separated values per alias, simply specify your alias
as an array to use this handy feature.

http://wiki.opscode.com/display/chef/Templates#Templates-TemplateLocationSpecificity

Usage
=====

On systems that should simply send mail directly to a relay, or out to
the internet, use `recipe[postfix]` and modify the
`node['postfix']['relayhost']` attribute via a role.

On systems that should be the MX for a domain, set the attributes
accordingly and make sure the `node['postfix']['mail_type']` attribute
is `master`. See __Examples__ for information on how to use
`recipe[postfix::server]` to do this automatically.

If you need to use SASL authentication to send mail through your ISP
(such as on a home network), use `recipe[postfix::sasl_auth]` and set
the appropriate attributes.

For each of these implementations, see __Examples__ for role usage.

Examples
--------

The example roles below only have the relevant postfix usage. You may
have other contents depending on what you're configuring on your
systems.

The `base` role is applied to all nodes in the environment.

    name "base"
    run_list("recipe[postfix]")
    override_attributes(
      "postfix" => {
        "mail_type" => "client",
        "mydomain" => "example.com",
        "myorigin" => "example.com",
        "relayhost" => "[smtp.example.com]",
        "smtp_use_tls" => "no"
      }
    )

The `relayhost` role is applied to the nodes that are relayhosts.
Often this is 2 systems using a CNAME of `smtp.example.com`.

    name "relayhost"
    run_list("recipe[postfix]")
    override_attributes(
      "postfix" => {
        "mail_relay_networks" => "10.3.3.0/24",
        "mail_type" => "master",
        "mydomain" => "example.com",
        "myorigin" => "example.com"
      }
    )

The `sasl_relayhost` role is applied to the nodes that are relayhosts
and require authenticating with SASL. For example this might be on a
household network with an ISP that otherwise blocks direct internet
access to SMTP.

    name "sasl_relayhost"
    run_list("recipe[postfix], recipe[postfix::sasl_auth]")
    override_attributes(
      "postfix" => {
        "mail_relay_networks" => "10.3.3.0/24",
        "mail_type" => "master",
        "mydomain" => "example.com",
        "myorigin" => "example.com",
        "relayhost" => "[smtp.comcast.net]:587",
        "smtp_sasl_auth_enable" => "yes",
        "smtp_sasl_passwd" => "your_password",
        "smtp_sasl_user_name" => "your_username"
      }
    )

For an example of using encrypted data bags to encrypt the SASL
password, see the following blog post:

* http://jtimberman.github.com/blog/2011/08/06/encrypted-data-bag-for-postfix-sasl-authentication/

**Examples using the client & server recipes**

If you'd like to use the more dynamic search based approach for discovery, use the server and client recipes. First, create a relayhost role.

    name "relayhost"
    run_list("recipe[postfix::server]")
    override_attributes(
      "postfix" => {
        "mail_relay_networks" => "10.3.3.0/24",
        "mydomain" => "example.com",
        "myorigin" => "example.com"
      }
    )

Then, add the `postfix::client` recipe to the run list of your `base` role or equivalent role for postfix clients.

    name "base"
    run_list("recipe[postfix::client]")
    override_attributes(
      "postfix" => {
        "mail_type" => "client",
        "mydomain" => "example.com",
        "myorigin" => "example.com"
      }
    )

If you wish to use a different role name for the relayhost, then also set the attribute in the `base` role. For example, `postfix_master` as the role name:

    name "postfix_master"
    description "a role for postfix master that isn't relayhost"
    run_list("recipe[postfix::server]")
    override_attributes(
      "postfix" => {
        "mail_relay_networks" => "10.3.3.0/24",
        "mydomain" => "example.com",
        "myorigin" => "example.com"
      }
    )

The base role would look something like this:

    name "base"
    run_list("recipe[postfix::client]")
    override_attributes(
      "postfix" => {
        "relayhost_role" => "postfix_master",
        "mail_type" => "client",
        "mydomain" => "example.com",
        "myorigin" => "example.com"
      }
    )

License and Author
==================

Author:: Joshua Timberman <joshua@opscode.com>

Copyright:: 2009-2012, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
