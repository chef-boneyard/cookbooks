#
# Cookbook Name:: nginx
# Recipe:: upload_progress_module
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#
# Copyright 2012, Riot Games
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

upm_src_filename = ::File.basename(node[:nginx][:upload_progress][:url])
upm_src_filepath = "#{Chef::Config[:file_cache_path]}/#{upm_src_filename}"
upm_extract_path = "#{Chef::Config[:file_cache_path]}/nginx_upload_progress/#{node[:nginx][:upload_progress][:checksum]}"

remote_file upm_src_filepath do
  source node[:nginx][:upload_progress][:url]
  checksum node[:nginx][:upload_progress][:checksum]
  owner "root"
  group "root"
  mode 0644
end

bash "extract_upload_progress_module" do
  cwd ::File.dirname(upm_src_filepath)
  code <<-EOH
    mkdir -p #{upm_extract_path}
    tar xzf #{upm_src_filename} -C #{upm_extract_path}
    mv #{upm_extract_path}/*/* #{upm_extract_path}/
  EOH

  not_if { ::File.exists?(upm_extract_path) }
end

node.run_state[:nginx_configure_flags] =
  node.run_state[:nginx_configure_flags] | ["--add-module=#{upm_extract_path}"]
  