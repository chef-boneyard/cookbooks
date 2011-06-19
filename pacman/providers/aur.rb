#
# Cookbook Name:: pacman
# Provider:: aur
#
# Copyright:: 2010, Opscode, Inc <legal@opscode.com>
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

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :build do
  get_pkg_version
  aurfile = "#{new_resource.builddir}/#{new_resource.name}/#{new_resource.name}-#{new_resource.version}.pkg.tar.xz"

  Chef::Log.debug("Checking for #{aurfile}")
  unless ::File.exists?("#{aurfile}")
    Chef::Log.debug("Creating build directory")
    d = directory "#{new_resource.builddir}" do
      owner "root"
      group "root"
      mode 0755
      action :nothing
    end
    d.run_action(:create)

    Chef::Log.debug("Retrieving source for #{new_resource.name}")
    r = remote_file "#{new_resource.builddir}/#{new_resource.name}.tar.gz" do
      source "http://aur.archlinux.org/packages/#{new_resource.name}/#{new_resource.name}.tar.gz"
      owner "root"
      group "root"
      mode 0644
      action :nothing
    end
    r.run_action(:create_if_missing)

    Chef::Log.debug("Untarring source package for #{new_resource.name}")
    e = execute "tar -xf #{new_resource.name}.tar.gz" do
      cwd new_resource.builddir
      action :nothing
    end
    e.run_action(:run)

    if new_resource.pkgbuild_src
      Chef::Log.debug("Replacing PKGBUILD with custom version")
      pkgb = cookbook_file "#{new_resource.builddir}/#{new_resource.name}/PKGBUILD" do
        source "PKGBUILD"
        owner "root"
        group "root"
        mode 0644
        action :nothing
      end
      pkgb.run_action(:create)
    end

    if new_resource.patches.length > 0
      Chef::Log.debug("Adding new patches")
      new_resource.patches.each do |patch|
        pfile = cookbook_file "#{new_resource.builddir}/#{new_resource.name}/#{patch}" do
          source "#{patch}"
          mode 0644
          action :nothing
        end
        pfile.run_action(:create)
      end
    end

    if new_resource.options
      Chef::Log.debug("Appending #{new_resource.options} to configure command")
      opt = Chef::Util::FileEdit.new("#{new_resource.builddir}/#{new_resource.name}/PKGBUILD")
      opt.search_file_replace(/(.\/configure.+$)/, "\\1 #{new_resource.options}")
      opt.write_file
    end

    Chef::Log.debug("Building package #{new_resource.name}")
    em = execute "makepkg -s --asroot" do
      cwd "#{new_resource.builddir}/#{new_resource.name}"
      creates "#{aurfile}"
      action :nothing
    end
    em.run_action(:run)
    @updated = true
  end
end

action :install do
  unless @aurpkg.exists
    get_pkg_version
    execute "install AUR package #{new_resource.name}" do
      command "pacman -U --noconfirm  --noprogressbar #{new_resource.builddir}/#{new_resource.name}/#{new_resource.name}-#{new_resource.version}.pkg.tar.xz"
    end
    @updated = true
  end
end

def get_pkg_version
  v = ''
  r = ''
  if ::File.exists?("#{new_resource.builddir}/#{new_resource.name}/PKGBUILD")
    ::File.open("#{new_resource.builddir}/#{new_resource.name}/PKGBUILD").each do |line|
      v = line.split("=")[1].chomp if line =~ /^pkgver/
      r = line.split("=")[1].chomp if line =~ /^pkgrel/
    end
    Chef::Log.debug("Setting version of #{new_resource.name} to #{v}-#{r}")
    new_resource.version("#{v}-#{r}-#{node.kernel.machine}")
  end
end

def load_current_resource
  @aurpkg = Chef::Resource::PacmanAur.new(new_resource.name)
  @aurpkg.package_name(new_resource.package_name)

  Chef::Log.debug("Checking pacman for #{new_resource.package_name}")
  p = shell_out("pacman -Qi #{new_resource.package_name}")
  exists = p.stdout.include?(new_resource.package_name)
  @aurpkg.exists(exists)
end
