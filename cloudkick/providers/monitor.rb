#
# Cookbook Name:: cloudkick
# Provider:: monitor
# Author:: Greg Albrecht <gba@splunk.com>
# Copyright:: Copyright (c) 2011 Splunk, Inc.
#
# License::
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
# LWRP 'Provider' for manipulating Cloudkick Monitors.
#
# = See also:
#   * Cloudkick API Documentation: https://support.cloudkick.com/API/2.0
#

include Cloudkick


action :create do
  # There doesn't appear to be a way to set a default
  # LWRP Resource Attribute to a Node Attribute, so we'll set it here.
  # If 'query' isn't set, we'll set it to node:node.name.
  query = new_resource.query
  query ||= "node:#{node.name}"

  apiclient = Cloudkick::APIClient.new(new_resource.oauth_key,
                                       new_resource.oauth_secret)
  monitor_attributes = apiclient.get_monitor(name=new_resource.name,
                                             query=query,
                                             notes=new_resource.notes)
  Chef::Log.debug("monitor_attributes=#{monitor_attributes}")
end


# TODO(gba@20111017) Write method to enable Monitors.
action :enable do
  # code to enable monitor
end


# TODO(gba@20111017) Write method to disable Monitors.
action :disable do
  # code to disable monitor
end


def initialize(*args)
  super
  @action = :create
end
