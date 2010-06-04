#
# Cookbook Name:: cloudkick
# Library:: cloudkick_data 
#
# Copyright 2010, Opscode, Inc.
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

class Chef
  class CloudkickData
    def self.get(node)
      ckb = Cloudkick::Base.new(node.cloudkick.oauth_key, node.cloudkick.oauth_secret)
      node = ckb.get("nodes", "node:#{node.hostname}").nodes.first
      data = {
        :agent_state => node.agent_state,
        :color => node.color,
        :id => node.id,
        :ipaddress => node.ipaddress,
        :name => node.name,
        :provider_id => node.provider_id,
        :provider_name => node.provider_name,
        :status => node.status,
        :tags => node.tags
      }
    end
  end
end
