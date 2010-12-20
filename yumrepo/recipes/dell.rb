#
# Cookbook Name:: yumrepo
# Recipe:: dell
#
# Copyright 2010, Eric G. Wolfe
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

if not node[:repo][:dell][:enabled]
  log "Dell repository not enabled; skipping"
  return
end

yumkey "RPM-GPG-KEY-dell"
yumkey "RPM-GPG-KEY-libsmbios"

yumrepo "dell-community" do
  templatesource "dell-community-repository.repo.erb"
end

yumrepo "dell-omsa-repository" do
  templatesource "dell-omsa-repository.repo.erb"
end

yumrepo "dell-firmware-repository" do
  templatesource "dell-firmware-repository.repo.erb"
end

package "srvadmin-all" do
  action :install
end

if node[:repo][:dell][:install_optional]
  package "firmware-tools" do
    action :install
  end
  # yum install $(bootstrap_firmware) at your own risk
end

# vim: ai et sts=2 sw=2 ts=2
