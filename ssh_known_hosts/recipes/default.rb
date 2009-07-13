#
# Cookbook Name:: snmp
# Recipe:: default
#
# Copyright 2009, Adapp, Inc.

require 'chef/log'

my_fqdn = []
my_host_rsa_public = []
my_host_ip = []

keys = []
search(:node, "*") do |server|
  server['keys_ssh_host_rsa_public'].each do |x|
    Chef::Log.debug("SSH RSA Key #{x}")
    my_host_rsa_public << x
    end
  server['ipaddress'].each do |y|
    Chef::Log.debug("IP Address #{y}")
    my_host_ip << y
    end
  server['fqdn'].each do |z|
    Chef::Log.debug("FQDN #{z}")
    my_fqdn << z
    end
  end

template "/etc/ssh/known_hosts" do
  source "known_hosts.erb"
  mode 0440
  owner "root"
  group "root"
  variables(
    :ip => my_host_ip,
    :fqdn => my_fqdn,
    :host_rsa_public => my_host_rsa_public
  )
end
