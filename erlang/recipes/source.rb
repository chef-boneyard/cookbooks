# Cookbook Name:: erlang
# Recipe:: source
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

# Install required packages
%w{libncurses5-dev libssl-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

# Get Erlang and install it
script "install_erlang" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  wget http://www.erlang.org/download/otp_src_#{node[:erlang][:version]}.tar.gz
  tar -zxf otp_src_#{node[:erlang][:version]}.tar.gz
  cd otp_src_#{node[:erlang][:version]}
  ./configure
  make
  make install
  EOH
end
