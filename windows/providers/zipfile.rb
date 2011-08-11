#
# Author:: Doug MacEachern (<dougm@vmware.com>)
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: windows
# Provider:: unzip
#
# Copyright:: 2010, VMware, Inc.
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

include Windows::PackageHelper

action :unzip do
  ensure_rubyzip_gem_installed
  Chef::Log.debug("unzip #{@new_resource.source} => #{@new_resource.path} (overwrite=#{@new_resource.overwrite})")

  Zip::ZipFile.open(cached_file(@new_resource.source)) do |zip|
    zip.each do |entry|
      path = ::File.join(@new_resource.path, entry.name)
      FileUtils.mkdir_p(::File.dirname(path))
      if @new_resource.overwrite && ::File.exists?(path) && !::File.directory?(path)
        FileUtils.rm(path)
      end
      zip.extract(entry, path)
    end
  end
  @new_resource.updated_by_last_action(true)
end

private
def ensure_rubyzip_gem_installed
  begin
    require 'zip/zip'
  rescue LoadError
    Chef::Log.info("Missing gem 'rubyzip'...installing now.")
    gem_package "rubyzip" do
      action :nothing
    end.run_action(:install)
    Gem.clear_paths
    require 'zip/zip'
  end
end