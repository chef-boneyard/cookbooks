#
# Cookbook Name:: yumrepo
# Recipe:: dell
#
# Copyright 2010, Tippr Inc.
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

# note that deletion does not remove GPG keys, either from the repo or
# /etc/pki/rpm-gpg; this is a design decision.

define :yumrepo,
    :templatesource => "generic.repo.erb",
    :definition => nil,
    :url => nil,
    :key => nil,
    :url_is_mirrorlist => false,
    :action => :enable do

  if node[:repo].has_key? params[:name] and node[:repo][params[:name]][:url] then
    url = node[:repo][params[:name]][:url]
  else
    url = params[:url]
  end

  if params[:action] == :enable then
    if node[:repo][params[:name]] and node[:repo][params[:name]].has_key? :enabled and not node[:repo][params[:name]][:enabled] then
      log "Skipping #{node[:repo][params[:name]]} due to disabled status"
      return
    end
    if params[:key] then
      yumkey "#{params[:key]}"
    end
    template "/etc/yum.repos.d/#{params[:name]}.repo" do
      source params[:templatesource]
      variables({
        :shortname => params[:name],
        :description => params[:definition],
        :url => url,
        :key_filename => params[:key],
        :use_mirrorlist => params[:url_is_mirrorlist]
      })
      notifies :run, "execute[yum -q makecache]", :immediately
    end
    execute "yum -q makecache" do
      action :nothing
    end
  else
    file "/etc/yum.repos.d/#{params[:name]}.repo" do
      action :delete
    end
  end
end

# vim: ai et sts=2 sw=2 ts=2
