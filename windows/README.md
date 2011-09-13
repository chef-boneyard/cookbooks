Description
===========

Provides a set of Windows-specific primitives (Chef resources) meant to aid in the creation of cookbooks/recipes targeting the Windows platform.

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

* chef_handler (`windows::reboot_handler` leverages the chef_handler LWRP)

Attributes
==========

* `node['windows']['allow_pending_reboots']` - used to configure the `WindowsRebootHandler` (via the `windows::reboot_handler` recipe) to act on pending reboots. default is true (ie act on pending reboots).  The value of this attribute only has an effect if the `windows::reboot_handler` is in a node's run list.

Resource/Provider
=================

`windows_auto_run`
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


`windows_feature`
-----------------

Windows Roles and Features can be thought of as built-in operating system packages that ship with the OS.  A server role is a set of software programs that, when they are installed and properly configured, lets a computer perform a specific function for multiple users or other computers within a network.  A Role can have multiple Role Services that provide functionality to the Role.  Role services are software programs that provide the functionality of a role. Features are software programs that, although they are not directly parts of roles, can support or augment the functionality of one or more roles, or improve the functionality of the server, regardless of which roles are installed.  Collectively we refer to all of these attributes as 'features'.

This resource allows you to manage these 'features' in an unattended, idempotent way.

There are two providers for the `windows_features` which map into Microsoft's two major tools for managing roles/features: [Deployment Image Servicing and Management (DISM)](http://msdn.microsoft.com/en-us/library/dd371719(v=vs.85).aspx) and [Servermanagercmd](http://technet.microsoft.com/en-us/library/ee344834(WS.10).aspx) (The CLI for Server Manager).  As Servermanagercmd is deprecated, Chef will set the default provider to `Chef::Provider::WindowsFeature::DISM` if DISM is present on the system being configured.  The default provider will fall back to `Chef::Provider::WindowsFeature::ServerManagerCmd`.

For more information on Roles, Role Services and Features see the [Microsoft TechNet article on the topic](http://technet.microsoft.com/en-us/library/cc754923.aspx).  For a complete list of all features that are available on a node type either of the following commands at a command prompt:

    dism /online /Get-Features
    servermanagercmd -query

### Actions

- :install: install a Windows role/feature
- :remove: remove a Windows role/feature

### Attribute Parameters

- feature_name: name of the feature/role to install.  The same feature may have different names depending on the provider used (ie DHCPServer vs DHCP; DNS-Server-Full-Role vs DNS).

### Providers

- **Chef::Provider::WindowsFeature::DISM**: Uses Deployment Image Servicing and Management (DISM) to manage roles/features.
- **Chef::Provider::WindowsFeature::ServerManagerCmd**: Uses Server Manager to manage roles/features.

### Examples

    # enable the node as a DHCP Server
    windows_feature "DHCPServer" do
      action :install
    end
    
    # enable TFTP
    windows_feature "TFTP" do
      action :install
    end
    
    # disable Telnet client/server
    %w{ TelnetServer TelnetClient }.each do |feature|
      windows_feature feature do
        action :remove
      end
    end
    
    # 

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


`windows_reboot`
------------------

Sets required data in the node's run_state to notify `WindowsRebootHandler` a reboot is requested.  If Chef run completes successfully a reboot will occur if the `WindowsRebootHandler` is properly registered as a report handler.  As an action of `:request` will cause a node to reboot every Chef run, this resource is usually notified by other resources...ie restart node after a package is installed (see example below).

### Actions
- :request: requests a reboot at completion of successful Cher run.  requires `WindowsRebootHandler` to be registered as a report handler.
- :cancel: remove reboot request from node.run_state.  this will cancel *ALL* previously requested reboots as this is a binary state.

### Attribute Parameters
- :timeout: Name attribute. timeout delay in seconds to wait before proceeding with the requested reboot. default is 60 seconds
- :reason: comment on the reason for the reboot. default is 'Opscode Chef initiated reboot'

### Examples

    # if the package installs, schedule a reboot at end of chef run
    windows_reboot 60 do
      reason 'cause chef said so'
      action :nothing
    end
    windows_package 'some_package' do
      action :install
      notifies :request, 'windows_reboot[60]'
    end

    # cancel the previously requested reboot
    windows_reboot 60 do
      action :cancel
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

    Registry.value_exists?('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','BGINFO')
    Registry.key_exists?('HKLM\SOFTWARE\Microsoft')
    BgInfo = Registry.get_value('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','BGINFO')


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


Exception/Report Handlers
=========================

`WindowsRebootHandler`
----------------------

Required reboots are a necessary evil of configuring and managing Windows nodes.  This report handler (ie fires at the end of successful Chef runs) acts on requested (Chef initiated) or pending (as determined by the OS per configuration action we performed) reboots.  The `allow_pending_reboots` initialization argument should be set to false if you do not want the handler to automatically reboot a node if it has been determined a reboot is pending.  Reboots can still be requested explicitly via the `windows_reboot` LWRP.

## Initialization Arguments

- allow_pending_reboots: indicator on whether the handler should act on a the Window's 'pending reboot' state. default is true
- timeout: timeout delay in seconds to wait before proceeding with the reboot. default is 60 seconds
- reason:  comment on the reason for the reboot. default is 'Opscode Chef initiated reboot'

Usage
=====

Just place an explicit dependency on this cookbook (using depends in the cookbook's metadata.rb) from any cookbook where you would like to use the Windows-specific resources/providers that ship with this cookbook.

default
-------

Convenience recipe that installs supporting gems for many of the resources/providers that ship with this cookbook.

reboot_handler
--------------

Leverages the `chef_handler` LWRP to register the `WindowsRebootHandler` report handler that ships as part of this cookbook. By default this handler is set to automatically act on pending reboots.  If you would like to change this behavior override `node['windows']['allow_pending_reboots']` and set the value to false.  For example:

    % cat roles/base.rb
    name "base"
    description "base role"
    override_attributes(
      "windows" => {
        "allow_pending_reboots" => false
      }
    )

This will still allow a reboot to be explicitly requested via the `windows_reboot` LWRP.

Changes/Roadmap
===============

## Future

* package preseeding/response_file support
* package installation location via a `target_dir` attribute.
* [COOK-666] windows_package should support CoApp packages
* windows_registry :force_modify action should use RegNotifyChangeKeyValue from WinAPI
* WindowsRebootHandler/windows_reboot LWRP should support kicking off subsequent chef run on reboot.

## v1.2.0

* [COOK-745] gracefully handle required server restarts on Windows platform
  * WindowsRebootHandler for requested and pending reboots
  * windows_reboot LWRP for requesting (receiving notifies) reboots
  * reboot_handler recipe for enabling WindowsRebootHandler as a report handler
* [COOK-714] Correct initialize misspelling
* RegistryHelper - new get_values method which returns all values for a particular key.

## v1.0.8

* [COOK-719] resource/provider for managing windows features
* [COOK-717] remove windows_env_vars resource as env resource exists in core chef
* new `Windows::Version` helper class
* refactored `Windows::Helper` mixin

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
