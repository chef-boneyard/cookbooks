# Cookbook Name:: erlang
# Recipe:: default
# Author:: Roberto Aloi <roberto@erlang-solutions.com>
#
# Copyright 2011, Erlang Solutions Ltd.
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
include_recipe "erlang::#{node[:erlang][:install_method]}"

if #{node[:erlang][:eqc][:install]} == true
    package "unzip" do
      action :install
    end
    script "install_eqc" do
    interpreter "bash"
    user "root"
    cwd "/tmp"
    code <<-EOH
      wget #{node[:erlang][:eqc][:url]}
      unzip -o eqc.zip
      cd QuickCheck
      cp -r eqc-* eqc_mcerlang-* pulse-* /usr/local/lib/erlang/lib/
      erl -noinput -sname eqc -eval 'rpc:call(nonode@nohost, eqc, registration, ["#{node[:erlang][:eqc][:licence]}"]).' -s init stop
      EOH
  end
end
