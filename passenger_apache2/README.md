Description
====

Installs passenger for Apache 2.

Changes
====

## v0.99.0:

* Upgrade to passenger 3.0.7
* Attributes are all "default"
* Install curl development headers
* Move PassengerMaxPoolSize to config of module instead of vhost.

Requirements
====

## Platform

Tested on Ubuntu 10.04. Should work on any Ubuntu/Debian platforms.

## Cookbooks

Opscode cookbooks:

* apache2
* build-essential

Attributes 
====

* `passenger[:version]` - Specify the version of passenger to install.
* `passenger[:max_pool_size]` - Sets PassengerMaxPoolSize in the Apache module config.
* `passenger[:root_path]` - The location of the passenger gem.
* `passenger[:module_path]` - The location of the compiled passenger apache module.

Usage
====

For example, to run a Rails application on passenger:

    include_recipe "rails"
    include_recipe "passenger"
    
    web_app "myproj" do
      docroot "/srv/myproj/public"
      server_name "myproj.#{node[:domain]}"
      server_aliases [ "myproj", node[:hostname] ]
      rails_env "production"
    end

A sample config template is provided, `web_app.conf.erb`. If this is suitable for your application, add 'cookbook "passenger"' to the define above to use that template. Otherwise, copy the template to the cookbook where you're using `web_app`, and modify as needed. The cookbook parameter is optional, if omitted it will search the cookbook where the define is used.

License and Author
====

Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Joshua Sierles (<joshua@37signals.com>)
Author:: Michael Hale (<mikehale@gmail.com>)

Copyright:: 2009-2011, Opscode, Inc
Copyright:: 2009, 37signals
Coprighty:: 2009, Michael Hale

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
