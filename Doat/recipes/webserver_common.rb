include_recipe "Doat"
include_recipe "nginx"
include_recipe "php::php5-cgi"
include_recipe "Doat::scribe-client"

remote_directory ::File.join(node[:nginx][:dir], "ssl") do
  mode "0700"
  files_node "0600"
  files_owner node[:nginx][:user]
  files_group node[:nginx][:group]
  owner node[:nginx][:user]
  group node[:nginx][:group]
  source "ssl"
end
