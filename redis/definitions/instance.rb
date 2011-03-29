define :redis_instance, :port => nil, :data_dir => nil, :master => nil do
  include_recipe "redis"
  instance_name = "redis_#{params[:name]}"
  # if no explicit replication role was defined, it's a master
  node.default[:redis][params[:name]][:replication][:role] = "master"
  node[:redis][:instances][params[:name]] = {} unless node[:redis][:instances].has_key? params[:name]
  node[:redis][:instances][params[:name]][:port] = params[:port] if params[:port]
  node[:redis][:instances][params[:name]][:data_dir] = params[:data_dir] if params[:data_dir]

  if node[:redis][:instances][params[:name]][:data_dir] == node[:redis][:instances][:default][:data_dir]
    node[:redis][:instances][params[:name]][:data_dir] = ::File.join(node[:redis][:instances][:default][:data_dir], params[:name])
  end
  swap_file = begin; node[:redis][:instances][params[:name]][:vm][:swap_file]; rescue; nil; end
  if swap_file.nil? or swap_file == node[:redis][:instances][:default][:vm][:swap_file]
    node.default[:redis][:instances][params[:name]][:vm][:swap_file] = ::File.join(
      ::File.dirname(node[:redis][:instances][:default][:vm][:swap_file]), "swap_#{params[:name]}")
  end

  init_dir = value_for_platform([:debian, :ubuntu] => {:default => "/etc/init.d/"},
                              [:centos, :redhat] => {:default => "/etc/rc.d/init.d/"},
                              :default => "/etc/init.d/")

  unless params[:name] == "default"
    conf = ::Chef::Node::Attribute.new(
      ::Chef::Mixin::DeepMerge.merge(node.normal[:redis][:instances][:default].to_hash, node.normal[:redis][:instances][params[:name]].to_hash),
      ::Chef::Mixin::DeepMerge.merge(node.default[:redis][:instances][:default].to_hash, node.default[:redis][:instances][params[:name]].to_hash),
      ::Chef::Mixin::DeepMerge.merge(node.override[:redis][:instances][:default].to_hash, node.override[:redis][:instances][params[:name]].to_hash),
      {})
  else
    conf = node[:redis][:instances][:default]
  end

  directory node[:redis][:instances][params[:name]][:data_dir] do
    owner node[:redis][:user]
    mode "0750"
  end

  conf_vars = {:conf => conf, :instance_name => params[:name]}
  if node[:redis][:instances][params[:name]][:replication][:role] == "slave"
    conf_vars[:master] = params[:master]
  end

  template ::File.join(node[:redis][:conf_dir], "#{instance_name}.conf") do
    source "redis.conf.erb"
    cookbook "redis"
    variables conf_vars
    mode "0644"
    notifies :restart, "service[#{instance_name}]"
  end

  if node.platform == "ubuntu"
    template "/etc/init/#{instance_name}.conf" do
      cookbook "redis"
      source "redis.upstart.conf.erb"
      variables :instance_name => instance_name
    end
  else
    cookbook_file ::File.join(init_dir, instance_name) do
      source "redis.init"
      cookbook "redis"
      mode "0755"
    end
  end

  service instance_name do
    if node.platform == "ubuntu"
      supports :reload => false, :restart => true, :start => true, :stop => true
      provider ::Chef::Provider::Service::Upstart
    else
      supports :reload => false, :restart => false, :start => true, :stop => true
    end
    action [:start, :enable]
  end
  provide_service instance_name, :replication => node[:redis][:instances][params[:name]][:replication][:role]
end
