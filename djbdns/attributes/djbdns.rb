#
# Cookbook Name:: djbdns
# Recipe:: default
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Joshua Sierles (<joshua@37signals.com>)
#
# Copyright 2009, Opscode, Inc
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
djbdns Mash.new unless attribute?("djbdns")

djbdns[:tinydns_ipaddress] = "127.0.0.1" unless djbdns.has_key?(:tinydns_ipaddress)
djbdns[:tinydns_internal_ipaddress] = "127.0.0.1" unless djbdns.has_key?(:tinydns_internal_ipaddress)
djbdns[:axfrdns_ipaddress] = "127.0.0.1" unless djbdns.has_key?(:axfrdns_ipaddress)
djbdns[:public_dnscache_ipaddress] = ipaddress unless djbdns.has_key?(:public_dnscache_ipaddress)

djbdns[:public_dnscache_allowed_networks] = [ipaddress.split(".")[0,2].join(".")] unless djbdns.has_key?(:public_dnscache_allowed_networks)
djbdns[:tinydns_internal_resolved_domain] = domain unless djbdns.has_key?(:tinydns_internal_resolved_domain)

case lsb[:codename]
when "intrepid","jaunty"
  djbdns[:bin_dir] = "/usr/bin"
else
  djbdns[:bin_dir] = "/usr/local/bin"
end
