Description
===========

Installs nginx from package OR source code and sets up configuration handling similar to Debian's Apache2 scripts.

Requirements
============

Cookbooks
---------

* build-essential (for nginx::source)
* runit (for nginx::source)

Platform
--------

Debian or Ubuntu though may work where 'build-essential' works, but other platforms are untested.

Attributes
==========

All node attributes are set under the `nginx` namespace.

* version - sets the version to install.
* dir - configuration dir.
* `log_dir` - where logs go.
* user - user to run as.
* binary - path to nginx binary.
* gzip - all attributes under the `gzip` namespace configure the gzip module.
* keepalive - whether to use keepalive.
* `keepalive_timeout` - set the keepalive timeout.
* `worker_processes` - number of workers to spawn.
* `worker_connections` - number of connections per worker.
* `server_names_hash_bucket_size`
* `additional_modules` - array additional nginx module names to install (compatible with automatically-set configure_flags)
* `additional_src_modules` - hash of additional non-bundled nginx modules to install (compatible with automatically-set configure_flags). See Additional Source Modules section for details.

The following attributes are set at the 'normal' node level via the `nginx::source` recipe.

* `install_path` - for nginx::source, sets the --prefix installation.
* `src_binary` - for nginx::source, sets the binary location.
* `configure_flags` - for nginx::source, an array of flags to use for compilation.

Additional Source Modules
-------------------------

When using nginx::source, you may compile nginx with additional modules that do not come with the nginx sources package. The `additional_src_modules` hash takes keys named after nginx modules and values of hashes, each containing the following elements:

* "local" - Path to custom nginx module tarfile on local machine. .tar, .tar.gz and .tgz type packages are supported.
* "http" - URL for custom nginx module.
* "save\_as" - Sets the filename to use for local storage when pulling from an HTTP source. Useful when pulling from sources that do not have correct names or extensions. If omitted, uses filename from HTTP request.
* "module\_folder" - Overrides folder name that is expected to be in the tarfile. If omitted, uses name of the tarfile without the extension.

You must supply either "http" or "local". "local" will take precedence if both are supplied.

Here is a comprehensive example of what our role looks like if we want to install the set-misc module via Github:

    override_attributes(
      :nginx => {
        :additional_src_modules => {
          "ngx_devel_kit" => {
            "http" => "https://github.com/simpl/ngx_devel_kit/tarball/v0.2.16",
            "save_as" => "simpl-ngx_devel_kit-83bcfaf.tar.gz" #,
            # "module_folder" => "simpl-ngx_devel_kit-83bcfaf" # Not needed because it's the same as the filename
          },
          "set-misc-nginx-module" => {
            "http" => "https://github.com/agentzh/set-misc-nginx-module/tarball/v0.21",
            "save_as" => "agentzh-set-misc-nginx-module-4b0512a.tgz" #,
            # "module_folder" => "agentzh-set-misc-nginx-module-4b0512a" # Not needed because it's the same as the filename
          }
        }
      }
    )

Here is what it looks like if we're installing it from a file that's already on our box:

    override_attributes(
      :nginx => {
        :additional_src_modules => {
          "ngx_devel_kit" => {
            "local" => "/data/modules/nginx_devel_kit.tar.gz",
            "module_folder" => "simpl-ngx_devel_kit-83bcfaf"
          },
          "set-misc-nginx-module" => {
            "local" => "/data/modules/agentzh-set-misc-nginx-module-4b0512a.tgz" #,
            # "module_folder" => "agentzh-set-misc-nginx-module-4b0512a" # Not needed because it's the same as the filename.
          }
        }
      }
    )

If we run `nginx -V` we see it was compiled with these additional modules:

    $ ./nginx -V
    nginx version: nginx/1.0.12
    built by gcc 4.4.3 (Ubuntu 4.4.3-4ubuntu5) 
    TLS SNI support enabled
    configure arguments: --add-module=/var/chef/cache/agentzh-set-misc-nginx-module-4b0512a --add-module=/var/chef/cache/simpl-ngx_devel_kit-83bcfaf

Usage
=====

Provides two ways to install and configure nginx.

* Install via native package (nginx::default)
* Install via compiled source (nginx::source)

Both recipes implement configuration handling similar to the Debian Apache2 site enable/disable.

There's some redundancy in that the config handling hasn't been separated from the installation method (yet), so use only one of the recipes.

Some of the attributes mentioned above are only set in the `nginx::source` recipe. They can be overridden by setting them via a role in `override_attributes`.

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Adam Jacob (<adam@opscode.com>)
Author:: AJ Christensen (<aj@opscode.com>)

Copyright:: 2008-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
