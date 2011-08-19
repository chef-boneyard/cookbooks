Description
===========

Provides a set of primitives for managing firewalls and associated rules.

PLEASE NOTE - The resource/providers in this cookbook are under heavy development.
An attempt is being made to keep the resource simple/stupid by starting with less 
sophisticated firewall implementations first and refactor/vet the resource definition 
with each successive provider.

Requirements
============

Platform
--------

* Ubuntu

Tested on:

* Ubuntu 10.04
* Ubuntu 11.04

Resources/Providers
===================

`firewall`
----------

### Actions

- :enable: enable the firewall.  this will make any rules that have been defined 'active'.
- :disable: disable the firewall. drop any rules and put the node in an unprotected state.

### Attribute Parameters

- name: name attribute. arbitrary name to uniquely identify this resource

### Providers

- `Chef::Provider::Firewall::Ufw`
    - platform default: Ubuntu

### Examples
    
    # enable platform default firewall
    firewall "ufw" do
      action :enable
    end

`firewall_rule`
---------------

### Actions

- :allow: the rule should allow incoming traffic.
- :deny: the rule should deny incoming traffic

### Attribute Parameters

- name: name attribute. arbitrary name to uniquely identify this firewall rule
- protocol: valid values are: :udp, :tcp. default is all protocols
- port: port number.
- source: ip address or subnet incoming traffic originates from. default is `0.0.0.0/0` (ie Anywhere)
- destination: ip address or subnet traffic routing to
- position: position to insert rule at. if not provided rule is inserted at the end of the rule list.

### Providers

- `Chef::Provider::FirewallRule::Ufw`
    - platform default: Ubuntu

### Examples

    # open standard ssh port, enable firewall
    firewall_rule "ssh" do
      port 22
      action :allow
      notifies :enable, "firewall[ufw]"
    end
    
    # open standard http port to tcp traffic only; insert as first rule; enable firewall
    firewall_rule "http" do
      port 80
      protocol :tcp
      position 1
      action :allow
      notifies :enable, "firewall[ufw]"
    end
    
    firewall "ufw" do
      action :nothing
    end

Changes/Roadmap
===============

## Future

* [COOK-688] create iptables providers for all resources
* [COOK-689] create windows firewall providers for all resources
* [COOK-690] create firewall_chain resource
* [COOK-693] create pf firewall providers for all resources

## 0.5.2

* add missing 'requires' statements. fixes 'NameError: uninitialized constant' error.  
thanks to Ernad Husremović for the fix.

## 0.5.0

* [COOK-686] create firewall and firewall_rule resources
* [COOK-687] create UFW providers for all resources

License and Author
==================

Author:: Seth Chisamore (<schisamo@opscode.com>)

Copyright:: Copyright (c) 2011 Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
