Description
===========

Installs and configures PowerShell 2.0.  Also includes a resource/provider for executing scripts using the PowerShell interpreter.

Requirements
============

Platform
--------

* Windows XP
* Windows Server 2003
* Windows Vista
* Windows 7
* Windows Server 2008 (R1, R2)

Attributes
==========

Resource/Provider
=================

`powershell`
------------
Execute a script using the powershell interpreter (much like the script resources for bash, csh, perl, python and ruby). A temporary file is created and executed like other script resources, rather than run inline. By their nature, Script resources are not idempotent, as they are completely up to the user's imagination. Use the `not_if` or `only_if` meta parameters to guard the resource for idempotence.

### Actions

- :run: run the script

### Attribute Parameters

- command: name attribute. Name of the command to execute.
- code: quoted string of code to execute.
- creates: a file this command creates - if the file exists, the command will not be run.
- cwd: current working directory to run the command from.
- flags: command line flags to pass to the interpreter when invoking.
- environment: A hash of environment variables to set before running this command.
- user: A user name or user ID that we should change to before running this command.
- group: A group name or group ID that we should change to before running this command.

### Examples

    # write out to an interpolated path
    powershell "write-to-interpolated-path" do
      code <<-EOH
      $stream = [System.IO.StreamWriter] "#{Chef::Config[:file_cache_path]}/powershell-test.txt"
      $stream.WriteLine("In #{Chef::Config[:file_cache_path]}...word.")
      $stream.close()
      EOH
    end
    
    # use the change working directory attribute
    powershell "cwd-then-write" do
      cwd Chef::Config[:file_cache_path]
      code <<-EOH
      $stream = [System.IO.StreamWriter] "C:/powershell-test2.txt"
      $pwd = pwd
      $stream.WriteLine("This is the contents of: $pwd")
      $dirs = dir
      foreach ($dir in $dirs) {
        $stream.WriteLine($dir.fullname)
      }
      $stream.close()
      EOH
    end
    
    # cwd to a winodws env variable
    powershell "cwd-to-win-env-var" do
      cwd "%TEMP%"
      code <<-EOH
      $stream = [System.IO.StreamWriter] "./temp-write-from-chef.txt"
      $stream.WriteLine("chef on windows rox yo!")
      $stream.close()
      EOH
    end
    
    # pass an env var to script
    powershell "read-env-var" do
      cwd Chef::Config[:file_cache_path]
      environment ({'foo' => 'BAZ'})
      code <<-EOH
      $stream = [System.IO.StreamWriter] "./test-read-env-var.txt"
      $stream.WriteLine("FOO is $foo")
      $stream.close()
      EOH
    end

Usage
=====

default
-------

Include the default recipe in a run list, to ensure PowerShell 2.0 is installed. 

On the following versions of Windows the PowerShell 2.0 package will be downloaded from Microsoft and installed:

* Windows XP
* Windows Server 2003
* Windows Server 2008 R1
* Windows Vista 

On the following versions of Windows, PowerShell 2.0 is present and must just be enabled:

* Windows 7
* Windows Server 2008 R2
* Windows Server 2008 R2 Core

**PLEASE NOTE** - The installation may require a restart of the node being configured before PowerShell (or the powershell script resource) can be used (yeah Windows!).

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
