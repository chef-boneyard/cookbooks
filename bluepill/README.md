Description
===========

Installs bluepill RubyGem and configures it to manage services. Also includes a LWRP.

Requirements
============

Bluepill is a pure Ruby service management tool/library, so this cookbook should work on any system. The attributes do set up paths based on FHS locations, see below.

Attributes
==========

Default locations for bluepill are in "FHS compliant" locations.

* `node["bluepill"]["bin"]` - Path to bluepill program, default is 'bluepill' in the RubyGems binary directory.
* `node["bluepill"]["logfile"]` - Location of the bluepill log file, default "/var/log/bluepill.log".
* `node["bluepill"]["conf_dir"]` - Location of service config files (pills), default "/etc/bluepill".
* `node["bluepill"]["pid_dir"]` - Location of pidfiles, default "/var/run/bluepill"
* `node["bluepill"]["state_dir"]` - Location of state directory, default "/var/lib/bluepill"
* `node["bluepill"]["init_dir"]` - Location of init script directory, default selected by platform.

Resources/Providers
===================

This cookbook contains an LWRP, `bluepill_service`. This can be used with the normal Chef service resource, by using the `provider` parameter, or by specifying the `bluepill_service` shortcut. These two resources are equivalent.

    service "my_app" do
      provider bluepill_service
      action [:enable, :load, :start]
    end

    bluepill_service "my_app" do
      action [:enable, :load, :start]
    end

The load action should probably always be specified, to ensure that if bluepill isn't running already it gets started. The 

The recipe using the service must contain a template resource for the pill and it must be named `my_app.pill.erb`, where `my_app` is the service name passed to the bluepill service resource. 

Usage
=====

Be sure to include the bluepill recipe in the run list to ensure that the gem and bluepill-related directories are created. This will also make the cookbook available on the system and other cookbooks won't need to explicitly depend on it in the metadata.

If the default directory locations in the attributes/default.rb aren't what you want, change them by setting them either in the attributes file itself, or create attributes in a role applied to any systems that will use bluepill.

Example pill template resource and .erb file:

    template "/etc/bluepill/my_app" do
      source "my_app.pill.erb"
    end

    Bluepill.application("my_app") do |app|
      app.process("my_app") do |process|
        process.pid_file = "/var/run/my_app.pid"
        process.start_command = "/usr/bin/my_app"
      end
    end

See bluepill's documentation for more information on creating pill templates.
    
Changes
=======

## v0.2.2:

* Fixes COOK-524, COOK-632

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright 2010, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
