#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: php
# Provider:: pear_channel
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
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

# http://pear.php.net/manual/en/guide.users.commandline.channels.php

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :discover do
  unless exists?
    Chef::Log.info("Discovering pear channel #{@new_resource}")
    execute "pear channel-discover #{@new_resource.channel_name}" do
      action :run
    end
    new_resource.updated_by_last_action(true)
  end
end

action :add do
  unless exists?
    Chef::Log.info("Adding pear channel #{@new_resource} from #{@new_resource.channel_xml}")
    execute "pear channel-add #{@new_resource.channel_xml}" do
      action :run
    end
    new_resource.updated_by_last_action(true)
  end
end

action :update do
  if exists?
    update_needed = false
    begin
      updated_needed = true if shell_out("pear search -c #{@new_resource.channel_name} NNNNNN").stdout =~ /channel-update/
    rescue Chef::Exceptions::CommandTimeout
      # CentOS can hang on 'pear search' if a channel needs updating
      Chef::Log.info("Timed out checking if channel-update needed...forcing update of pear channel #{@new_resource}")
      update_needed = true
    end
    if update_needed
      Chef::Log.info("Updating pear channel #{@new_resource}")
      shell_out!("pear channel-update #{@new_resource.channel_name}")
      new_resource.updated_by_last_action(true)
    end
  end
end

action :remove do
  if exists?
    Chef::Log.info("Deleting pear channel #{@new_resource}")
    execute "pear channel-delete #{@new_resource.channel_name}" do
      action :run
    end
    new_resource.updated_by_last_action(true)
  end
end

def load_current_resource
  @current_resource = Chef::Resource::PhpPearChannel.new(@new_resource.name)
  @current_resource.channel_name(@new_resource.channel_name)
  @current_resource
end

private
def exists?
  begin
    shell_out!("pear channel-info #{@current_resource.channel_name}")
    true
  rescue Chef::Exceptions::ShellCommandFailed
    false
  end
end
