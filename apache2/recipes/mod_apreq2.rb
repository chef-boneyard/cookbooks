#
# Cookbook Name:: apache2
# Recipe:: apreq2
#
# modified from the python recipe by Jeremy Bingham
#
# Copyright 2008-2009, Opscode, Inc.
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

case node[:platform]
  when "debian", "ubuntu"
    package "libapache2-mod-apreq2" do
      action :install
    end
  when "centos", "redhat", "fedora"
    package "libapreq2" do
      action :install
      notifies :run, resources(:execute => "generate-module-list"), :immediately
    end
    # seems that the apreq lib is weirdly broken or something - it needs to be
    # loaded as "apreq", but on RHEL & derivitatives the file needs a symbolic
    # link to mod_apreq.so.
    link "/usr/lib64/httpd/modules/mod_apreq.so" do
      to "/usr/lib64/httpd/modules/mod_apreq2.so"
      only_if "test -f /usr/lib64/httpd/modules/mod_apreq2.so"
    end
    link "/usr/lib/httpd/modules/mod_apreq.so" do
      to "/usr/lib/httpd/modules/mod_apreq2.so"
      only_if "test -f /usr/lib/httpd/modules/mod_apreq2.so"
    end
end

apache_module "apreq"
