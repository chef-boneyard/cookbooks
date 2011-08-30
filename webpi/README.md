Description
===========

Microsoft Web Platform Installer (WebPI) automates the installation of Microsoft's entire Web Platform.  This cookbook makes it easy to get WebpiCmdLine.exe the lightweight CLI version of WebPI onto a Windows node.  It also exposes a resource for installing WebPI products idempotently.

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

* windows

Attributes
==========

* `node['webpi']['home']` - location to install WebPI files to.  default is `%SYSTEMDRIVE%\webpi`

Resource/Provider
=================

`webpi_product`
---------------

### Actions

- :install: install a product using WebpiCmdLine

### Attribute Parameters

- product_id: name attribute. Specifies the ID of a product to install.
- accept_eula: specifies that WebpiCmdline should Auto-Accept Eula’s. default is false.

### Examples

    # install IIS 7 Recommended Configuration
    webpi_product "IIS7" do
      accept_eula true
      action :install
    end
    
    # install Windows PowerShell 2.0
    webpi_product "PowerShell2" do
      accept_eula true
      action :install
    end

Usage
=====

default
-------

Downloads and unzips `WebpiCmdLine.exe` to the location specified by `node['webpi']['home']`.  `WebpiCmdLine.exe` is used required by the `webpi_product` LWRP for taking all actions.

Changes/Roadmap
===============

## Future

* resource/provider for managing WebPI Applications
* support for alternate custom feeds across all WebPI resources (product and application)

## 1.0.0:

* initial release

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
