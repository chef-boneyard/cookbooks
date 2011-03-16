include_recipe "Doat"
directory node[:scribe][:tmp_dir] do
  mode "0750"
  owner node[:scribe][:user]
  group node[:scribe][:group]
end

scribe = provider_for_service(:scribe)

template "/opt/doat/etc/Scribe/scribe-client.conf" do
  source "scribe-client.conf.erb"
  variables :scribe => scribe
end

link "/etc/init.d/scribe-client" do
  to "/opt/doat/etc/servers/scribe/init/scribed-client"
end

service "scribe-client" do
  action [:enable, :start]
  running true
end
