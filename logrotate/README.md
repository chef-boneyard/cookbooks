DESCRIPTION
====

Manages the logrotate package and provides a definition to manage application specific logrotate configuration.

REQUIREMENTS
====

Should work on any platform that includes a 'logrotate' package and writes logrotate configuration to /etc/logrotate.d. Tested on Ubuntu, Debian and Red Hat/CentOS.

DEFINITIONS
====

* ``logrotate_app``

This definition can be used to drop off customized logrotate config files on a per application basis.

The definition takes the following params:

* path: specifies a single path (string) or multiple paths (array) that should have logrotation stanzas created in the config file. No default, this must be specified.
* enable: true/false, if true it will create the template in /etc/logrotate.d.
* frequency: sets the frequency for rotation. Default value is 'weekly'. Valid values are: daily, weekly, monthly, yearly, see the logrotate man page for more information.
* template: sets the template source, default is "logrotate.erb".
* cookbook: select the template source from the specified cookbook. By default it will use the cookbook where the definition is used.
* create: creation parameters for the logrotate "create" config, follows the form "mode owner group".

See USAGE below.

USAGE
====

The default recipe will ensure logrotate is always up to date.

To create application specific logrotate configs, use the `logrotate_app` definition. For example, to rotate logs for a tomcat application named myapp that writes its log file to /var/log/tomcat/myapp.log:

    logrotate_app "tomcat-myapp" do
      cookbook "logrotate"
      path "/var/log/tomcat/myapp.log"
      frequency "daily"
      rotate 30
      create "644 root adm"
    end

To rotate multiple logfile paths, specify the path as an array:

    logrotate_app "tomcat-myapp" do
      cookbook "logrotate"
      path [ "/var/log/tomcat/myapp.log", "/opt/local/tomcat/catalina.out" ]
      frequency "daily"
      create "644 root adm"
      rotate 7
    end

LICENSE AND AUTHOR
====

Author:: Scott M. Likens (<scott@likens.us>)
Author:: Joshua Timberman (<joshua@opscode.com>)
Copyright:: 2009, Scott M. Likens
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
