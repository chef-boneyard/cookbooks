Description
===========

Provides a set of Windows-specific primitives (Chef resources) meant to aid in the creation of cookbooks/recipes targeting the Windows platform.

Requirements
============

Platform
--------

* Windows XP
* Windows Server 2003
* Windows Vista
* Windows 7
* Windows Server 2008 (R1, R2)

Resource/Provider
=================

`windows_package`
-----------------

Manage Windows application packages in an unattended, idempotent way.

The following application installers are currently supported:

* MSI packages
* InstallShield
* Wise InstallMaster
* Inno Setup
* Nullsoft Scriptable Install System

If the proper installer type is not passed into the resource's installer_type attribute, the provider will do it's best to identify the type by introspecting the installation package.  If the installation type cannot be properly identified the `:custom` value can be passed into the installer_type attribute along with the proper flags for silent/quiet installation (using the `options` attribute..see example below).

__PLEASE NOTE__ - For proper idempotence the resource's `package_name` should be the same as the 'DisplayName' registry value in the uninstallation data that is created during package installation.  The easiest way to definitively find the proper 'DisplayName' value is to install the package on a machine and search for the uninstall information under the following registry keys:

* `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall`
* `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall`
* `HKEY_LOCAL_MACHINE\Software\Wow6464Node\Microsoft\Windows\CurrentVersion\Uninstall`

For maximum flexibility the `source` attribute supports both remote and local installation packages.

### Actions

- :install: install a package
- :remove: remove a package. The remove action is completely hit or miss as many application uninstallers do not support a full silent/quiet mode.

### Attribute Parameters

- package_name: name attribute. The 'DisplayName' of the application installation package.
- source: The source of the windows installer.  This can either be a URI or a local path.
- installer_type: They type of windows installation package. valid values are: :msi, :inno, :nsis, :wise, :installshield, :custom.  If this value is not provided, the provider will do it's best to identify the installer type through introspection of the file.
- checksum: useful if source is remote, the SHA-256 checksum of the file--if the local file matches the checksum, Chef will not download it
- options: Additional options to pass the underlying installation command

### Examples

    # install PuTTY (InnoSetup installer)
    windows_package "PuTTY version 0.60" do
      source "http://the.earth.li/~sgtatham/putty/latest/x86/putty-0.60-installer.exe"
      installer_type :inno
      action :install
    end
    
    # install 7-Zip (MSI installer)
    windows_package "7-Zip 9.20 (x64 edition)" do
      source "http://downloads.sourceforge.net/sevenzip/7z920-x64.msi"
      action :install
    end
    
    # install Notepad++ (Y U No Emacs?) using a local installer
    windows_package "Notepad++" do
      source "c:/installation_files/npp.5.9.2.Installer.exe"
      action :install
    end
    
    # install VLC for that Xvid (NSIS installer)
    windows_package "VLC media player 1.1.10" do
      source "http://superb-sea2.dl.sourceforge.net/project/vlc/1.1.10/win32/vlc-1.1.10-win32.exe"
      action :install
    end
    
    # install Firefox as custom installer and manually set the silent install flags
    windows_package "Mozilla Firefox 5.0 (x86 en-US)" do
      source "http://archive.mozilla.org/pub/mozilla.org/mozilla.org/firefox/releases/5.0/win32/en-US/Firefox%20Setup%205.0.exe"
      options "-ms"
      installer_type :custom
      action :install
    end
    
    # Google Chrome FTW (MSI installer)
    windows_package "Google Chrome" do
      source "https://dl-ssl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B806F36C0-CB54-4A84-A3F3-0CF8A86575E0%7D%26lang%3Den%26browser%3D3%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dfalse/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi"
      action :install
    end
    
    # remove Google Chrome (but why??)
    windows_package "Google Chrome" do
      action :remove
    end
    
    # remove 7-Zip
    windows_package "7-Zip 9.20 (x64 edition)" do
      action :remove
    end
    

`windows_registry`
-----------------

Creates and modifies Windows registry keys.

### Actions

- :create: create a new registry key with the provided values.
- :modify: modify an existing registry key with the provided values.
- :force_modify: modify an existing registry key with the provided values.  ensures the value is actually set by checking multiple times. useful for fighting race conditions where two processes are trying to set the same registry key.  This will be updated in the near future to use 'RegNotifyChangeKeyValue' which is exposed by the WinAPI and allows a process to register for notification on a registry key change.
- :remove: removes a value from an existing registry key

### Attribute Parameters

- key_name: name attribute. The registry key to create/modify.
- values: hash of the values to set under the registry key. The individual hash items will become respective 'Value name' => 'Value data' items in the registry key.

### Examples
  
    # make the local windows proxy match the one set for Chef
    proxy = URI.parse(Chef::Config[:http_proxy])
    windows_registry 'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings' do
      values 'ProxyEnable' => 1, 'ProxyServer' => "#{proxy.host}:#{proxy.port}", 'ProxyOverride' => '<local>'
    end
    
    # enable Remote Desktop and poke the firewall hole
    windows_registry 'HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server' do
      values 'FdenyTSConnections' => 0
    end
    
    # Delete an item from the registry
    windows_registry 'HKCU\Software\Test' do
      #Key is the name of the value that you want to delete the value is always empty
      values 'ValueToDelete' => ''
      action :remove
    end
    
### Library Methods

    Registry::value_exists?('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','BGINFO')
    Registry::key_exists?('HKLM\SOFTWARE\Microsoft')
    BgInfo = Registry::get_value('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','BGINFO')

'windows_auto_run'
------------------

### Actions
- :create: Create an item to be run at login
- :remove: Remove an item that was previously setup to run at login

### Attribute Parameters
- :name: Name attribute. The name of the value to be stored in the registry
- :program: The program to be run at login
- :args: The arguments for the program

### Examples

  # Run BGInfo at login
  windows_auto_run 'BGINFO' do
    program "C:/Sysinternals/bginfo.exe"
    args "\"C:/Sysinternals/Config.bgi\" /NOLICPROMPT /TIMER:0"
    not_if { Registry.value_exists?(Windows::KeyHelper::AUTO_RUN_KEY, 'BGINFO') }
    action :create
  end

'windows_path'
--------------

### Actions
- :add: Add an item to the system path
- :remove: Remove an item from the system path

### Attribute Parameters
- :path: Name attribute. The name of the value to add to the system path

### Examples

    #Add Sysinternals to the system path
    windows_path 'C:\Sysinternals' do
      action :add
    end
    
    #Remove Sysinternals from the system path
    windows_path 'C:\Sysinternals' do
      action :remove
    end

`windows_zipfile`
-----------------

Most version of Windows do not ship with native cli utility for managing compressed files.  This resource provides a pure-ruby implementation for managing zip files. Be sure to use the `not_if` or `only_if` meta parameters to guard the resource for idempotence or action will be taken on the zip file every Chef run.

### Actions

- :unzip: unzip a compressed file

### Attribute Parameters

- path: name attribute. The path where files will be unzipped to.
- source: The source of the zip file. This can either be a URI or a local path.
- overwrite: force an overwrite of the files if the already exists.

### Examples

    # unzip a remote zip file locally
    windows_zipfile "c:/bin" do
      source "http://download.sysinternals.com/Files/SysinternalsSuite.zip"
      action :unzip
      not_if {::File.exists?("c:/bin/PsExec.exe")}
    end
    
    # unzip a local zipfile
    windows_zipfile "c:/the_codez" do
      source "c:/foo/baz/the_codez.zip"
      action :unzip
    end

Usage
=====

Just place an explicit dependency on this cookbook (using depends in the cookbook's metadata.rb) from any cookbook where you would like to use these Windows-specific resources.

default
-------

Convenience recipe that installs many useful supporting Windows gems.

Changes/Roadmap
===============

## Future

* package preseeding/response_file support
* package installation location via a `target_dir` attribute.
* [COOK-666] windows_package should support CoApp packages
* windows_registry :force_modify action should use RegNotifyChangeKeyValue from WinAPI

## v1.0.6

* added force_modify action to windows_registry resource
* add win_friendly_path helper
* re-purpose default recipe to install useful supporting windows related gems

## v1.0.4

* [COOK-700] new resources and improvements to the windows_registry provider (thanks Paul Morton!)
  * Open the registry in the bitednes of the OS
  * Provide convenience methods to check if keys and values exit
  * Provide convenience method for reading registry values
  * NEW - `windows_auto_run` resource/provider
  * NEW - `windows_env_vars` resource/provider
  * NEW - `windows_path` resource/provider
* re-write of the windows_package logic for determining current installed packages
* new checksum attribute for windows_package resource...useful for remote packages

## v1.0.2:

* [COOK-647] account for Wow6432Node registry redirecter
* [COOK-656] begin/rescue on win32/registry

## 1.0.0:

* [COOK-612] initial release

License and Author
==================

Author:: Seth Chisamore (<schisamo@opscode.com>)
Author:: Doug MacEachern (<dougm@vmware.com>)
Author:: Paul Morton (<pmorton@biaprotect.com>)

Copyright:: 2011, Opscode, Inc.
Copyright:: 2010, VMware, Inc.
Copyright:: 2011, Business Intelligence Associates, Inc


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
