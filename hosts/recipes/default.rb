
#http://powdahound.com/2010/07/dynamic-hosts-file-using-chef

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :hostname => node[:hosts][:hostname],
    :ip_addr => node[:hosts][:ip_addr]
  
  )
end

template "/etc/hostname" do
  source "hostname.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :hostname => node[:hosts][:hostname]
  )
end

execute "set hostname" do
   user "root"
   group "root"
  command "hostname #{node[:hosts][:hostname]}"
end
