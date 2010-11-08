#
# Author::  Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: php
# Recipe:: pear_module
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

define :pear_module, :module => nil, :enable => true do

  include_recipe "php::pear"

  # still allowing for use of :module
  if params[:enable]
    execute "/usr/bin/pear install -a #{params[:module]}" do
      only_if "/bin/sh -c '! /usr/bin/pear info #{params[:module]} ' 2>&1 1>/dev/null"
    end
  end

  # but better to use :name
  # then we can just use "pear_module PACKAGE_NAME"
  if params[:enable] and params[:name]
    execute "/usr/bin/pear install -a #{params[:name]}" do
      only_if "/bin/sh -c '! /usr/bin/pear info #{params[:name]} ' 2>&1 1>/dev/null"
    end
  end

end
