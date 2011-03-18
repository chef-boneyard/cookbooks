define :redis_instance, :port => nil, :data_dir => nil do
  include_recipe "redis"
  instance_name = "redis_#{params[:name]}"
  node[:redis][:instances][params[:name]] = ::Chef::Attribute.new unless node[:redis][:instances][params[:name]].is_a?(::Chef::Attribute)
  node[:redis][:instances][params[:name]][:port] = params[:port] if params[:port]
  node[:redis][:instances][params[:name]][:data_dir] = params[:data_dir] if params[:data_dir]

  if node[:redis][:instances][params[:name]][:data_dir] == node[:redis][:instances][:default][:data_dir]
    node[:redis][:instances][params[:name]][:data_dir] = ::File.join(node[:redis][:instances][:default][:data_dir], params[:name])
  end

  init_dir = value_for_platform([:debian, :ubuntu] => {:default => "/etc/init.d/"},
                              [:centos, :redhat] => {:default => "/etc/rc.d/init.d/"},
                              :default => "/etc/init.d/")

  unless params[:name] == "default"
    conf = ::Chef::Mixin::DeepMerge.merge(node[:redis][:instances][:default], node[:redis][:instances][params[:name]])
  else
    conf = node[:redis][:instances][:default]
  end

  directory node[:redis][:instances][params[:name]][:data_dir] do
    owner node[:redis][:user]
    mode "0750"
  end

  conf_vars = {:conf => conf, :instance_name => params[:name]}
  if node[:redis][:instances][params[:name]][:replication][:role] == "slave"
    master_node = search(:node, "role:#{node[:redis][params[:name]][:replication][:replication][:master_role]}").first
    conf_vars[:master] = master_node
  end

  template ::File.join(node[:redis][:conf_dir], "#{instance_name}.conf") do
    source "redis.conf.erb"
    cookbook "redis"
    variables conf_vars
    notifies :restart, "service[#{instance_name}]"
  end

  cookbook_file ::File.join(init_dir, instance_name) do
    source "redis.init"
    cookbook "redis"
    mode "0755"
  end

  service instance_name do
    supports :reload => false, :restart => true, :start => true, :stop => true
    running true
    action [:start, :enable]
  end
end
