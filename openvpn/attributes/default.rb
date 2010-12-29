#
# Cookbook Name:: openvpn
# Attributes:: openvpn
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default["openvpn"]["local"]   = node["ipaddress"]
default["openvpn"]["proto"]   = "udp"
default["openvpn"]["type"]    = "server"
default["openvpn"]["subnet"]  = "10.8.0.0"
default["openvpn"]["netmask"] = "255.255.0.0"
default["openvpn"]["gateway"] = "vpn.#{node["domain"]}"
default["openvpn"]["log"]     = "/var/log/openvpn.log"
default["openvpn"]["key_dir"] = "/etc/openvpn/keys"
default["openvpn"]["signing_ca_key"]  = "#{node["openvpn"]["key_dir"]}/ca.key"
default["openvpn"]["signing_ca_cert"] = "#{node["openvpn"]["key_dir"]}/ca.crt"
default["openvpn"]["push"] = []

# Used by helper library to generate certificates/keys
default["openvpn"]["key"]["ca_expire"] = 3650
default["openvpn"]["key"]["expire"]    = 3650
default["openvpn"]["key"]["size"]      = 1024
default["openvpn"]["key"]["country"]   = "US"
default["openvpn"]["key"]["province"]  = "CA"
default["openvpn"]["key"]["city"]      = "SanFrancisco"
default["openvpn"]["key"]["org"]       = "Fort-Funston"
default["openvpn"]["key"]["email"]     = "me@example.com"
