#
# Cookbook Name:: python
# Recipe:: default
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
package "python" do
  action :install
end

%w{ 
  dev imaging matplotlib matplotlib-data matplotlib-doc mysqldb 
  numpy numpy-ext paramiko scipy setuptools sqlite
}.each do |pkg|
  package "python-#{pkg}" do
    action :install
  end
end

bash "install-nltk" do
  not_if do File.exists?("/usr/lib/python2.5/site-packages/nltk-0.9.8.egg-info") end
  cwd "/tmp"
  code <<-EOH
  wget http://nltk.googlecode.com/files/nltk-0.9.8.zip
  unzip nltk-0.9.8.zip
  cd nltk-0.9.8
  python setup.py install
  EOH
end
