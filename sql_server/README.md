Description
===========

Installs and configures Microsoft SQL Server 2008 R2 server and client.  By default the Express edition is installed, but the `sql_server::server` recipe supports installation of other editions (see __Usage__ below).

Requirements
============

Platform
--------

Tested on

* Windows Server 2008 R2

May work on other versions of Windows.

Attributes
==========

default
-------

The following attributes are used by both client and server recipes.

* `node['sql_server']['accept_eula']` - indicate that you accept the terms of the end user license, default is 'false'
* `node['sql_server']['product_key']` - Specifies the product key for the edition of SQL Server, default is `nil` (not needed for SQL Server 2008 R2 Express installs)

client
------

This file also contains download url, checksum and package name for all client installation packages.  See the __Usage__ section below for more details.

server
------

* `node['sql_server']['install_dir']` - main directory for installation, default is `C:\Program Files\Microsoft SQL Server`
* `node['sql_server']['port']` - static TCP port server should listen on for client connections, default is `1433`
* `node['sql_server']['instance_name']` - name of the default instance, default is `SQLEXPRESS`
* `node['sql_server']['instance_dir']` - root directory of the default instance, default is `C:\Program Files\Microsoft SQL Server`

This file also contains download url, checksum and package name for the server installation package.

Usage
=====

default
-------

Includes the `sql_server::client` recipe.

client
------

Installs required the SQL Server Native Client and all required dependancies. These include:

* [Microsoft SQL Server 2008 R2 Native Client](http://www.microsoft.com/download/en/details.aspx?id=16978#SNAC)
* [Microsoft SQL Server 2008 R2 Command Line Utilities (ie `sqlcmd`)](http://www.microsoft.com/download/en/details.aspx?id=16978#SQLCMD)
* [Microsoft SQL Server System CLR Types](http://www.microsoft.com/download/en/details.aspx?id=16978#SQLSYSCLR)
* [Microsoft SQL Server 2008 R2 Management Objects](http://www.microsoft.com/download/en/details.aspx?id=16978#SMO)
* [Windows PowerShell Extensions for SQL Server 2008 R2](http://www.microsoft.com/download/en/details.aspx?id=16978#PowerShell)

The SQL Server Native Client contains the SQL Server ODBC driver and the SQL Server OLE DB provider in one native dynamic link library (DLL) supporting applications using native-code APIs (ODBC, OLE DB and ADO) to Microsoft SQL Server.  In simple terms these packages should allow any other node to act as a client of a SQL Server instance.

The [TinyTDS](https://github.com/rails-sqlserver/tiny_tds) gem is also installed as this is used in the SQL Server providers for the `database` and `database_user` resources (see the `database` cookbook for more details).

server
------

Installs SQL Server 2008 R2 Express.  The installation is done using the `windows_package` resource and [ConfigurationFile](http://msdn.microsoft.com/en-us/library/dd239405.aspx) generated from a `template` resource.  The installation is slightly opinionated and does the following:

* Enables [Mixed Mode](http://msdn.microsoft.com/en-us/library/aa905171\(v=sql.80\).aspx) (Windows Authentication and SQL Server Authentication) authentication
* Auto-generates and sets a strong password for the 'sa' account
* sets a static TCP port which is configurable via an attribute.

Installing any of the SQL Server server or client packages in an unattended/automated way requires you to explicitly indicate that you accept the terms of the end user license. The hooks have been added to all recipes to do this via an attribute.  Create a role to set the `node['sql_server']['accept_license_terms']` attribute to 'true'.  For example:

    % cat roles/sql_server.rb
    name "sql_server"
    description "SQL Server database master"
    run_list(
      "recipe[sql_server::server]"
    )
    default_attributes(
      "sql_server" => {
        "accept_eula" => true
      }
    )

Out of the box this recipe installs the Express edition of SQL Server 2008 R2.  If you would like to install the Standard edition create a role as follows:

    % cat roles/sql_server.rb
    name "sql_server_standard"
    description "SQL Server Stadard edition database master"
    run_list(
      "recipe[sql_server::server]"
    )
    default_attributes(
      "sql_server" => {
        "instance_name" => "MSSQLSERVER",
        "product_key" => "YOUR_PRODUCT_KEY_HERE",
        "accept_eula" => true,
        "server" => {
          "url" => "DOWNLOAD_LOCATION_OF_INSTALLATION_PACKAGE",
          "checksum" => "SHA256_OF_INSTALLATION_PACKAGE"
        }
      }
    )

Depending on your base Windows installation you may also need to open the configured static port in the Windows Firewall.  In the name of security we do not do this by default but the follow code should get the job done:

    # unlock port in firewall
    # this should leverage firewall_rule resource
    # once COOK-689 is completed
    firewall_rule_name = "#{node['sql_server']['instance_name']} Static Port"

    execute "open-static-port" do
      command "netsh advfirewall firewall add rule name=\"#{firewall_rule_name}\" dir=in action=allow protocol=TCP localport=#{node['sql_server']['port']}"
      returns [0,1,42] # *sigh* cmd.exe return codes are wonky
      not_if { SqlServer::Helper.firewall_rule_enabled?(firewall_rule_name) }
    end

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
