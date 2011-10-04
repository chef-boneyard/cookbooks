Description
===========

Installs and configures Microsoft Internet Information Services (IIS) 7.

Requirements
============

Platform
--------

* Windows XP
* Windows Vista
* Windows Server 2003 R2
* Windows 7
* Windows Server 2008 (R1, R2)

Cookbooks
---------

* windows
* webpi

Attributes
==========

* `node['iis']['accept_eula']` - indicate that you accept the terms of the end user license. default is 'false'

* `node['iis']['home']` - IIS main home directory. default is `%WINDIR%\System32\inetsrv`
* `node['iis']['conf_dir']` - location where main IIS configs lives. default is `%WINDIR%\System32\inetsrv\config`
* `node['iis']['pubroot']` - . default is `%SYSTEMDRIVE%\inetpub`
* `node['iis']['docroot']` - IIS web site home directory. default is `%SYSTEMDRIVE%\inetpub\wwwroot`
* `node['iis']['log_dir']` - location of IIS logs. default is `%SYSTEMDRIVE%\inetpub\logs\LogFiles`
* `node['iis']['cache_dir']` - location of cached data. default is `%SYSTEMDRIVE%\inetpub\temp`

Resource/Provider
=================

`iis_site`
----------

Allows easy management of IIS virtual sites (ie vhosts).

### Actions

- :add: - add a new virtual site
- :delete: - delete an existing virtual site
- :start: - start a virtual site
- :stop: - stop a virtual site
- :restart: - restart a virtual site

### Attribute Parameters

- product_id: name attribute. Specifies the ID of a product to install.
- accept_eula: specifies that WebpiCmdline should Auto-Accept Eula’s. default is false.

- site_name: name attribute. 
- site_id: . if not given IIS generates a unique ID for the site
- path: IIS will create a root application and a root virtual directory mapped to this specified local path
- protocol: http protocol type the site should respond to. valid values are :http, :https. default is :http
- port: port site will listen on. default is 80
- host_header: host header (also known as domains or host names) the site should map to. default is all host headers

### Examples

    # stop and delete the default site
    iis_site 'Default Web Site' do
      action [:stop, :delete]
    end
    
    # create and start a new site that maps to 
    # the physical location C:\inetpub\wwwroot\testfu
    iis_site 'Testfu Site' do
      protocol :http
      port 80
      path "#{node['iis']['docroot']}/testfu"
      action [:add,:start]
    end
    
    # do the same but map to testfu.opscode.com domain
    iis_site 'Testfu Site' do
      protocol :http
      port 80
      path "#{node['iis']['docroot']}/testfu"
      host_header "testfu.opscode.com"
      action [:add,:start]
    end

Usage
=====

Installing any of the IIS or any of it's modules requires you to explicitly indicate that you accept the terms of the end user license. The hooks have been added to all recipes to do this via an attribute.  Create a role to set the `node['iis']['accept_eula']` attribute to 'true'.  For example:

    % cat roles/iis.rb
    name "iis"
    description "IIS Web Server"
    run_list(
      "recipe[iis]",
      "recipe[iis::mod_mvc3]",
      "recipe[iis::mod_urlrewrite]"
    )
    default_attributes(
      "iis" => {
        "accept_eula" => true
      }
    )


default
-------

Installs and configures IIS 7 using the Recommended Configuration, which includes the following modules/extensions:

* Static Content
* Default Document
* Directory Browse
* HTTP Errors
* HTTP Logging
* Logging Libraries
* Request Monitor
* Request Filtering
* HTTP Static Compression
* Management Console
* ASP.NET
* NetFX Extensibility
* ISAPI Filter
* ISAPI Extensions

mod_*
-----

This cookbook also contains recipes for installing individual IIS modules (extensions).  These recipes can be included in a node's run_list to build the minimal desired custom IIS installation.

* `mod_aspnet` - installs ASP.NET runtime components
* `mod_auth_basic` - installs Basic Authentication support
* `mod_auth_windows` - installs Windows Authentication (authenticate clients by using NTLM or Kerberos) support
* `mod_compress_dynamic` - installs dynamic content compression support. *PLEASE NOTE* - enabling dynamic compression always gives you more efficient use of bandwidth, but if your server's processor utilization is already very high, the CPU load imposed by dynamic compression might make your site perform more slowly.
* `mod_compress_static` - installs static content compression support
* `mod_deploy` - installs web deploy 2.0 support. Web Deploy (Web Deployment Tool) simplifies the migration, management and deployment of IIS Web servers, Web applications and Web sites.
* `mod_isapi` - installs ISAPI (Internet Server Application Programming Interface) extension and filter support.
* `mod_logging` - installs and enables HTTP Logging (logging of Web site activity), Logging Tools (logging tools and scripts) and Custom Logging (log any of the HTTP request/response headers, IIS server variables, and client-side fields with simple configuration) support
* `mod_management` - installs Web server Management Console which supports management of local and remote Web servers
* `mod_mvc3` - installs ASP.NET MVC 3 runtime components
* `mod_security` - installs URL Authorization (Authorizes client access to the URLs that comprise a Web application), Request Filtering (configures rules to block selected client requests) and IP Security (allows or denies content access based on IP address or domain name) support.
* `mod_tracing` -  installs support for tracing ASP.NET applications and failed requests.
* `mod_urlrewrite` - installs support for url rewrite rules using rule templates, rewrite maps, .NET providers.

Changes/Roadmap
===============

## Future

* `:modify` action for iis_site
* resource/provider for managing IIS applications and application pools
* resource/provider for managing IIS virtual directories
* IIS 6.0 support

## 1.0.0:

* [COOK-718] initial release

License and Author
==================

Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright:: 2011, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
