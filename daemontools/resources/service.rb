#
# Cookbook Name:: daemontools
# Resource:: service
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

# -u: Up. If the service is not running, start it. If the service stops, restart it.
# -d: Down. If the service is running, send it a TERM signal and then a CONT signal. After it stops, do not restart it.
# -o: Once. If the service is not running, start it. Do not restart it if it stops.
# -p: Pause. Send the service a STOP signal.
# -c: Continue. Send the service a CONT signal.
# -h: Hangup. Send the service a HUP signal.
# -a: Alarm. Send the service an ALRM signal.
# -i: Interrupt. Send the service an INT signal.
# -t: Terminate. Send the service a TERM signal.
# -k: Kill. Send the service a KILL signal. 

actions :start, :stop, :status, :restart, :up, :down, :once, :pause, :cont, :hup, :alrm, :int, :term, :kill, :enable, :disable

attribute :service_name, :name_attribute => true
attribute :directory, :kind_of => String, :required => true
attribute :template, :kind_of => [String, FalseClass], :default => :service_name
attribute :cookbook, :kind_of => String
attribute :enabled, :default => false
attribute :running, :default => false
attribute :variables, :kind_of => Hash, :default => {}
attribute :owner, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
attribute :finish, :kind_of => [TrueClass, FalseClass]
attribute :log, :kind_of => [TrueClass, FalseClass]
attribute :env, :kind_of => Hash, :default => {}
