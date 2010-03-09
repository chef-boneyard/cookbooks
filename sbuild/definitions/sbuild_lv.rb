#
# Cookbook Name:: sbuild
# Definition:: sbuild_lv
#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright 2010, Opscode, Inc. <legal@opscode.com>
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

define :sbuild_lv, :distro => nil, :vg => "buildvg", :release => "unstable" do

  include_recipe "sbuild"
  include_recipe "lvm"
  include_recipe "xfs"

  params[:distro] ||= node[:platform]
  vg = params[:vg]
  chroot_lv = "#{params[:name]}_chroot"
  chroot_path = "/dev/#{vg}/#{chroot_lv}"
  chroot_name = "#{params[:name]}"
  lv_size = node[:sbuild][:lv_size]
  snapshot_size = node[:sbuild][:snapshot_size]

  case params[:distro]
  when "ubuntu"
    mirror = params[:mirror] ? params[:mirror] : "http://archive.ubuntu.com/ubuntu"
    components = "main restricted universe multiverse"
  when "debian"
    mirror = params[:mirror] ? params[:mirror] : "http://ftp.debian.org/debian"
    components = "main non-free contrib"
  else
    log "This node's platform is not supported for sbuild!" do
      level :error
    end
  end

  execute "/sbin/lvcreate -n '#{chroot_lv}' -L '#{lv_size}' '#{vg}'" do
    not_if "/sbin/lvdisplay -c #{chroot_path}"
  end

  execute "mkfs.xfs #{chroot_path}" do
    only_if "xfs_admin -l #{chroot_path} 2>&1 | grep -qx 'xfs_admin: #{chroot_path} is not a valid XFS filesystem (unexpected SB magic number 0x00000000)'"
  end

  template "/etc/schroot/chroot.d/#{chroot_name}" do
    source "schroot.erb"
    owner "root"
    group "sbuild"
    mode 0640
    backup false
    variables(
      :vg => vg,
      :chroot_name => chroot_name,
      :chroot_lv => chroot_lv,
      :snapshot_size => snapshot_size
    )
  end

  template "/usr/local/bin/mk_chroot_#{chroot_name}.sh" do
    source "mk_chroot.sh.erb"
    owner "root"
    group "sbuild"
    mode 0750
    backup false
    variables(
      :vg => vg,
      :distro => params[:distro],
      :release => params[:name],
      :chroot_path => chroot_path,
      :chroot_name => chroot_name,
      :chroot_lv => chroot_lv,
      :snapshot_size => snapshot_size,
      :mirror => mirror,
      :components => components
    )
  end
end
