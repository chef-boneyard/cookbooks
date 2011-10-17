Description
===========

Installs and configures the latest version of Gunicorn (via pip), aka `Green Unicorn`, a Python WSGI HTTP Server for UNIX. It's a pre-fork worker model ported from Ruby's Unicorn project.  Includes an LWRP for managing Gunicorn config files.  By default Gunicorn is installed system-wide but you can target a particular `virtualenv` by overriding the `node["gunicorn"]["virtualenv"]` attribute.

Requirements
============

Platform
--------

* Debian, Ubuntu
* CentOS, Red Hat, Fedora

Cookbooks
---------

* python

Attributes
==========

* `node["gunicorn"]["virtualenv"]` - the virtualenv you want to target Gunicorn installation into.  The virtualenv will be created if it doesn't exist.

Resource/Provider
=================

This cookbook includes LWRPs for managing gunicorn config files.

`gunicorn_config`
-----------------

Creates a Gunicorn configuration file at the path specified.  Meant to be deployed with a service init scheme/supervisor such as runit.  Please see the `appliation::gunicorn` recipe for a complete working example. In depth information about Gunicorn's configuration values can be [found in the Gunicorn documentation](http://gunicorn.org/configure.html).

# Actions

- :create: create a Gunicorn configuration file.
- :delete: delete an existing Gunicorn configuration file.

# Attribute Parameters

- path: name attribute. The path where the configuration file will be created
- template: template to use when rendering the configuration file. default is `gunicorn.py.erb` (part of this cookbook)
- cookbook: cookbook to look for template file in. default is this cookbook `gunicorn`
- listen: the socket to bind to. A string of the form: 'HOST', 'HOST:PORT', 'unix:PATH'. default is `0.0.0.0:8000` or listen on port 8000 on all interfaces
- backlog: The maximum number of pending connections. default is `2048`
- preload_app: Whether application code should be loaded before the worker processes are forked. default is `false`
- worker_processes: The number of worker process for handling requests. default is `4`
- worker_class: The type of workers to use. default is `sync`
- worker_timeout: The number of seconds to wait before a worker is killed and restarted. default is `60`
- worker_keepalive: The number of seconds to wait for requests on a Keep-Alive connection. default is `2`
- worker_max_requests: The maximum number of requests a worker will process before restarting. default is `0` or restarts disabled
- server_hooks: A hash with whose values will be rendered as a [Gunicorn server hook](http://gunicorn.org/configure.html#server-hooks) callables (functions) named after the hash item's key name. default is `{}` or no serves hooks
- owner: The owner for the configuration file.
- group: The group owner of the configuration file (string or id).
- pid: A filename to use for the PID file. default is no pidfile

# Example
    
    # create a config with the default values
    gunicorn_config "/etc/gunicorn/myapp.py" do
      action :create
    end
    
    # tweak some worker related values...we're web scale baby
    gunicorn_config "/etc/gunicorn/myapp.py" do
      worker_processes 8
      backlog 4096
      action :create
    end
    
    # use the 'pre_fork' server hook to 
    # sleep for a second before forking
    gunicorn_config "/etc/gunicorn/myapp.py" do
      server_hooks({:pre_fork => 'import time;time.sleep(1)'})
      action :create
    end
    
Usage
=====

Simply include the recipe where you want Gunicorn installed.

License and Author
==================

Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright:: 2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
