#
# Cookbook Name:: ssh_known_hosts
# Recipe:: default
#
# Copyright 2009, Adapp, Inc.

sleep 2
nodes = []
search(:node, "*:*") do |z|
  nodes << z
end

template "/etc/ssh/ssh_known_hosts" do
  source "known_hosts.erb"
  mode 0440
  owner "root"
  group "root"
  backup false
  variables(
    :nodes => nodes
  )
end
