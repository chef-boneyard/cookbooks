#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: php
# Provider:: pear_package
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
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

# the logic in all action methods mirror that of 
# the Chef::Provider::Package which will make
# refactoring into core chef easy

action :install do
  # If we specified a version, and it's not the current version, move to the specified version
  if @new_resource.version != nil && @new_resource.version != @current_resource.version
    install_version = @new_resource.version
  # If it's not installed at all, install it
  elsif @current_resource.version == nil
    install_version = candidate_version
  end

  if install_version
    Chef::Log.info("Installing #{@new_resource} version #{install_version}")
    status = install_package(@new_resource.package_name, install_version)
    if status
      @new_resource.updated_by_last_action(true)
    end
  end
end

action :upgrade do
  if @current_resource.version != candidate_version
    orig_version = @current_resource.version || "uninstalled"
    Chef::Log.info("Upgrading #{@new_resource} version from #{orig_version} to #{candidate_version}")
    status = upgrade_package(@new_resource.package_name, candidate_version)
    if status
      @new_resource.updated_by_last_action(true)
    end
  end
end

action :remove do
  if removing_package?
    Chef::Log.info("Removing #{@new_resource}")
    remove_package(@current_resource.package_name, @new_resource.version)
    @new_resource.updated_by_last_action(true)
  else
  end
end

action :purge do
  if removing_package?
    Chef::Log.info("Purging #{@new_resource}")
    purge_package(@current_resource.package_name, @new_resource.version)
    @new_resource.updated_by_last_action(true)
  end
end

def removing_package?
  if @current_resource.version.nil?
    false # nothing to remove
  elsif @new_resource.version.nil?
    true # remove any version of a package
  elsif @new_resource.version == @current_resource.version
    true # remove the version we have
  else
    false # we don't have the version we want to remove
  end
end

def expand_options(options)
  options ? " #{options}" : ""
end

# these methods are the required overrides of 
# a provider that extends from Chef::Provider::Package 
# so refactoring into core Chef should be easy

def load_current_resource
  @current_resource = Chef::Resource::PhpPear.new(@new_resource.name)
  @current_resource.package_name(@new_resource.package_name)
  @bin = 'pear'
  if pecl?
    Chef::Log.debug("#{@new_resource} smells like a pecl...installing package in Pecl mode.")
    @bin = 'pecl'
  end
  Chef::Log.debug("#{@current_resource}: Installed version: #{current_installed_version} Candidate version: #{candidate_version}")
  
  unless current_installed_version.nil?
    @current_resource.version(current_installed_version)
    Chef::Log.debug("Current version is #{@current_resource.version}") if @current_resource.version
  end
  @current_resource
end

def current_installed_version
  @current_installed_version ||= begin
    v = nil
    version_check_cmd = "#{@bin} -d preferred_state=#{can_haz(@new_resource, "preferred_state")} list#{expand_channel(can_haz(@new_resource, "channel"))}"
    p = shell_out(version_check_cmd)
    response = nil
    if p.stdout =~ /\.?Installed packages/i
      response = grep_for_version(p.stdout, @new_resource.package_name)
    end
    response
  end
end

def candidate_version
  @candidate_version ||= begin
    candidate_version_cmd = "#{@bin} -d preferred_state=#{can_haz(@new_resource, "preferred_state")} search#{expand_channel(can_haz(@new_resource, "channel"))} #{@new_resource.package_name}"
    p = shell_out(candidate_version_cmd)
    response = nil
    if p.stdout =~ /\.?Matched packages/i
      response = grep_for_version(p.stdout, @new_resource.package_name)
    end
    response
  end
end

def install_package(name, version)
  pear_shell_out("echo -e \"\\r\" | #{@bin} -d preferred_state=#{can_haz(@new_resource, "preferred_state")} install -a#{expand_options(@new_resource.options)} #{prefix_channel(can_haz(@new_resource, "channel"))}#{name}-#{version}")
  manage_pecl_ini(name, :create, can_haz(@new_resource, "directives")) if pecl?
end

def upgrade_package(name, version)
  pear_shell_out("echo -e \"\\r\" | #{@bin} -d preferred_state=#{can_haz(@new_resource, "preferred_state")} upgrade -a#{expand_options(@new_resource.options)} #{prefix_channel(can_haz(@new_resource, "channel"))}#{name}-#{version}")
  manage_pecl_ini(name, :create, can_haz(@new_resource, "directives")) if pecl?
end

def remove_package(name, version)
  command = "#{@bin} uninstall #{expand_options(@new_resource.options)} #{prefix_channel(can_haz(@new_resource, "channel"))}#{name}"
  command << "-#{version}" if version and !version.empty?
  pear_shell_out(command)
  manage_pecl_ini(name, :delete) if pecl?
end

def pear_shell_out(command)
  p = shell_out!(command)
  # pear/pecl commands return a 0 on failures...we'll grep for it
  if p.stdout.split("\n").last =~ /^ERROR:.+/i
    p.invalid!
  end
  p
end

def purge_package(name, version)
  remove_package(name, version)
end

def expand_channel(channel)
  channel ? " -c #{channel}" : ""
end

def prefix_channel(channel)
  channel ? "#{channel}/" : ""
end

def manage_pecl_ini(name, action, directives)
  template "#{node['php']['ext_conf_dir']}/#{name}.ini" do
    source "extension.ini.erb"
    cookbook "php"
    owner "root"
    group "root"
    mode "0644"
    variables(:name => name, :directives => directives)
    action action
  end
end

def grep_for_version(stdout, package)
  v = nil

  stdout.split(/\n/).grep(/^#{package}\s/i).each do |m|
    # XML_RPC          1.5.4    stable
    # mongo   1.1.4/(1.1.4 stable) 1.1.4 MongoDB database driver
    # Horde_Url -n/a-/(1.0.0beta1 beta)       Horde Url class
    # Horde_Url 1.0.0beta1 (beta) 1.0.0beta1 Horde Url class
    v = m.split(/\s+/)[1].strip
    if v.split(/\//)[0] =~ /.\./
      # 1.1.4/(1.1.4 stable)
      v = v.split(/\//)[0]
    else
      # -n/a-/(1.0.0beta1 beta)
      v = v.split(/(.*)\/\((.*)/).last.split(/\s/)[0]
    end
  end
  v
end

def pecl?
  @pecl ||= begin
    # search as a pear first since most 3rd party channels will report pears as pecls!
    search_cmd = "pear -d preferred_state=#{can_haz(@new_resource, "preferred_state")} search#{expand_channel(can_haz(@new_resource, "channel"))} #{@new_resource.package_name}"
    if shell_out(search_cmd).stdout =~ /\.?Matched packages/i
      false
    else
      # fall back and search as a pecl
      search_cmd = "pecl -d preferred_state=#{can_haz(@new_resource, "preferred_state")} search#{expand_channel(can_haz(@new_resource, "channel"))} #{@new_resource.package_name}"
      if shell_out(search_cmd).stdout =~ /\.?Matched packages/i
        true
      else
        false
      end
    end
  end
end

# TODO remove when provider is moved into Chef core
# this allows PhpPear to work with Chef::Resource::Package
def can_haz(resource, attribute_name)
  resource.respond_to?(attribute_name) ? resource.send(attribute_name) : nil
end
