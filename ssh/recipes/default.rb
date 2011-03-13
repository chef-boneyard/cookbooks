package 'ssh'

template ::File.join(node[:ssh][:dir], "sshd_config") do
  source "sshd_config.erb"
  notifies :restart, "service[ssh]"
end

service "ssh" do
  action [:start, :enable]
end

admin_keys=[]
search("users", "groups:admins AND ssh_public_key").each do |user|
  if user[:groups].include? "admins"
    admin_keys << user[:ssh_public_key]
  end
end
ruby_block "Manage root's authorized_keys" do
  block do
    ::File.open("/root/.ssh/authorized_keys", "a+") do |f|
      keys_to_add = admin_keys - f.readlines
      f.write keys_to_add.join("\n") unless keys_to_add.empty?
    end
  end
end

directory "/root/.ssh" do
  owner "root"
  mode "0700"
end

