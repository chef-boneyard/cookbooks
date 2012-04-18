#
# Cookbook Name:: cloudkick
# Provider:: check
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
# LWRP 'Provider' for manipulating Cloudkick Checks.
#
# = See also:
#   * Cloudkick API Documentation: https://support.cloudkick.com/API/2.0
#

include Cloudkick


# TODO(gba@20111014) Implement other params (timeout, period, etc)
action :create do
  apiclient = Cloudkick::APIClient.new(oauth_key=new_resource.oauth_key,
                                       oauth_secret=new_resource.oauth_secret)
  check_params ||= Hash.new
  check_params[:monitor_id] = new_resource.monitor_id

  # For testing:
  #monitor_id = apiclient.find_monitor(name='recipe test monitor')[:id]
  #check_params[:monitor_id] = monitor_id

  check_attributes = apiclient.get_check(check_details=new_resource.details,
                                         check_code=new_resource.code,
                                         check_params=check_params)
end


# TODO(gba@20111017) Write method to enable checks.
action :enable do
  # code to enable check
end


# TODO(gba@20111017) Write method to disable checks.
action :disable do
  # code to disable check
end


def initialize(*args)
  super
  @action = :create
end
