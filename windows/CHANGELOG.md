## Future

* package preseeding/response_file support
* package installation location via a `target_dir` attribute.
* [COOK-666] `windows_package` should support CoApp packages
* windows_registry :force_modify action should use RegNotifyChangeKeyValue from WinAPI
* WindowsRebootHandler/`windows_reboot` LWRP should support kicking off subsequent chef run on reboot.
* Support all types of registry keys with `type` parameter in `windows_registry`.

## v1.2.12:

* [COOK-1037] - specify version for rubyzip gem
* [COOK-1007] - windows_feature does not work to remove features with
  dism
* [COOK-667] - shortcut resource + provider for Windows platforms

## v1.2.10

* [COOK-939] - add `type` parameter to `windows_registry` to allow binary registry keys.
* [COOK-940] - refactor logic so multiple values get created.

## v1.2.8

* FIX: Older Windows (Windows Server 2003) sometimes return 127 on successful forked commands
* FIX: `windows_package`, ensure we pass the WOW* registry redirection flags into reg.open

## v1.2.6

* patch to fix [CHEF-2684], Open4 is named Open3 in Ruby 1.9
* Ruby 1.9's Open3 returns 0 and 42 for successful commands
* retry keyword can only be used in a rescue block in Ruby 1.9

## v1.2.4

* windows_package - catch Win32::Registry::Error that pops up when searching certain keys

## v1.2.2

* combined numerous helper libarires for easier sharing across libaries/LWRPs
* renamed Chef::Provider::WindowsFeature::Base file to the more descriptive `feature_base.rb`
* refactored windows_path LWRP
  * :add action should MODIFY the the underlying ENV variable (vs CREATE)
  * deleted greedy :remove action until it could be made more idempotent
* added a windows_batch resource/provider for running batch scripts remotely

## v1.2.0

* [COOK-745] gracefully handle required server restarts on Windows platform
  * WindowsRebootHandler for requested and pending reboots
  * windows_reboot LWRP for requesting (receiving notifies) reboots
  * reboot_handler recipe for enabling WindowsRebootHandler as a report handler
* [COOK-714] Correct initialize misspelling
* RegistryHelper - new `get_values` method which returns all values for a particular key.

## v1.0.8

* [COOK-719] resource/provider for managing windows features
* [COOK-717] remove `windows_env_vars` resource as env resource exists in core chef
* new `Windows::Version` helper class
* refactored `Windows::Helper` mixin

## v1.0.6

* added `force_modify` action to `windows_registry` resource
* add `win_friendly_path` helper
* re-purpose default recipe to install useful supporting windows related gems

## v1.0.4

* [COOK-700] new resources and improvements to the `windows_registry` provider (thanks Paul Morton!)
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
