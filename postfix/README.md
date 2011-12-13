Description
===========

Installs and configures postfix for client or outbound relayhost, or
to do SASL authentication.

Changes
=======

## v0.8.4:

* Current public release.

Roadmap
-------

* [COOK-880] - add client/server recipes for search
* [COOK-881] - add (encrypted) data bag support for sasl credentials

Requirements
============

## Platform:

* Ubuntu 10.04+
* Debian 6.0+

Attributes
==========

See `attributes/default.rb` for default values.

* `node['postfix']['mail_type']` - Sets the kind of mail
  configuration. `master` will set up a server (relayhost).
* `node['postfix']['myhostname']` -  corresponds to the myhostname
  option in `/etc/postfix/main.cf`.
* `node['postfix']['mydomain']` - corresponds to the mydomain option
  in `/etc/postfix/main.cf`.
* `node['postfix']['myorigin']` - corresponds to the myorigin option
  in `/etc/postfix/main.cf`.
* `node['postfix']['relayhost']` - corresponds to the relayhost option
  in `/etc/postfix/main.cf`.
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
* `node['postfix']['smtp_tls_cafile']` - corresponds to the `smtp_tls_CAfile`
  option in `/etc/postfix/main.cf`.
* `node['postfix']['smtp_use_tls']` - corresponds to the
  `smtp_use_tls` option in `/etc/postfix/main.cf`.
* `node['postfix']['smtp_sasl_user_name']` - mapped in the
  `sasl_passwd` file as the user to authenticate as.
* `node['postfix']['smtp_sasl_passwd']` - mapped in the `sasl_passwd`
  file as the password to use.

Recipes
=======

default
-------

Installs the postfix package and manages the service and the main
configuration files (`/etc/postfix/main.cf` and
`/etc/postfix/master.cf`). See __Usage__ and __Examples__ to see how
to affect behavior of this recipe through configuration.

sasl\_auth
----------

Sets up the system to authenticate with a remote mail relay using SASL
authentication.


Usage
=====

On systems that should simply send mail directly to a relay, or out to
the internet, use `recipe[postfix]` and modify the
`node['postfix']['relayhost']` attribute via a role.

On systems that should be the MX for a domain, set the attributes
accordingly and make sure the `node['postfix']['mail_type']` attribute
is `master`.

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
        "smtp_sasl_passwd" => "your_password,
        "smtp_sasl_user_name" => "your_username"
      }
    )

For an example of using encrypted data bags to encrypt the SASL
password, see the following blog post:

* http://jtimberman.github.com/blog/2011/08/06/encrypted-data-bag-for-postfix-sasl-authentication/

License and Author
==================

Author:: Joshua Timberman <joshua@opscode.com>

Copyright:: 2009-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
