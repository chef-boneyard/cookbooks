#
# Author:: John E. Vincent <lusis.org+github.com@gmail.com>
# Cookbook Name:: voldemort
# Attributes:: default
#
# Copyright 2010, John E. Vincent
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

# chef-specific attributes
default[:voldemort][:version] = "0.81"
default[:voldemort][:do_symlink] = true
default[:voldemort][:mirror] = "http://cloud.github.com/downloads/voldemort/voldemort"
default[:voldemort][:install_dir] = "/usr/local/voldemort"
default[:voldemort][:run_dir] = "#{node[:voldemort][:install_dir]}/current"
default[:voldemort][:config_dir] = "/etc/voldemort"
default[:voldemort][:log4j_dir] = "/etc/voldemort"
default[:voldemort][:home_dir] = "/var/lib/voldemort"
default[:voldemort][:log_dir] = "/var/log/voldemort"
default[:voldemort][:data_dir] = "#{node[:voldemort][:home_dir]}/data"
default[:voldemort][:init_style] = "runit"

# Java/startup specfic tunables
default[:voldemort][:java_opts] = "-Xms1g -Xmx1g"
default[:voldemort][:jmx_opts] = ""
#default[:voldemort][:jmx_opts] = "-Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote.port=1111 -Djava.rmi.server.hostname=#{node[:hostname]}"
default[:voldemort][:log4j_opts] = "-Dlog4j.configuration=file://#{node[:voldemort][:log4j_dir]}/log4j.properties"
default[:voldemort][:vold_opts] = "-server #{node[:voldemort][:java_opts]} #{node[:voldemort][:jmx_opts]} #{node[:voldemort][:log4j_opts]}"

case platform
when "centos", "redhat", "fedora"
  default[:voldemort][:init_style] = "init"
end
#when "ubuntu", "debian"
#  default[:voldemort][:init_style] = "runit"
#
#end

# cluster.xml attributes
default[:voldemort][:config] = "single_node_cluster"
default[:voldemort][:cluster_name] = "chef_test_cluster"
default[:voldemort][:http_port] = "8081"
default[:voldemort][:socket_port] = "6666"
default[:voldemort][:partitions] = ['0', '1']

# server.properties attributes
default[:voldemort][:node_id] = "0"
default[:voldemort][:max_threads] = "100"
default[:voldemort][:storage] = "bdb"
default[:voldemort][:enable_nio] = true

# Connector options
default[:voldemort][:jmx] = false
default[:voldemort][:http] = true
default[:voldemort][:socket] = true

# db options - BDB
default[:voldemort][:db][:bdb][:cache_size] = "512M"
default[:voldemort][:db][:bdb][:write] = false
default[:voldemort][:db][:bdb][:flush] = false
default[:voldemort][:db][:bdb][:driver] = "voldemort.store.bdb.BdbStorageConfiguration"

# db options - MySQL
default[:voldemort][:db][:mysql][:host] = "localhost"
default[:voldemort][:db][:mysql][:port] = "3306"
default[:voldemort][:db][:mysql][:user] = "root"
default[:voldemort][:db][:mysql][:password] = "password"
default[:voldemort][:db][:mysql][:database] = "test"
default[:voldemort][:db][:mysql][:driver] = "voldemort.store.mysql.MysqlStorageConfiguration"

# stores.xml
default[:voldemort][:stores] = ['test1']
default[:voldemort][:views] = ['test-view1']
