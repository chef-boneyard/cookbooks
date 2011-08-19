#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: windows
# Library:: package_helper
#
# Copyright:: 2011, Opscode, Inc.
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

module Windows
  module PackageHelper

    def cached_file(source, checksum=nil, windows_path=true)
      @installer_file_path ||= begin

        if(source =~ /^(https?:\/\/)(.*\/)(.*)$/)
          cache_file_path = "#{Chef::Config[:file_cache_path]}/#{::File.basename(source)}"
          Chef::Log.debug("Caching a copy of file #{source} at #{cache_file_path}")
          r = Chef::Resource::RemoteFile.new(cache_file_path, run_context)
          r.source(source)
          r.backup(false)
          r.mode("0755")
          r.checksum(checksum) if checksum
          r.run_action(:create)
        else
          cache_file_path = source
        end

        windows_path ? Windows::Helper.win_friendly_path(cache_file_path) : cache_file_path
      end
    end

  end
end