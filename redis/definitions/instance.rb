define :instance, :port => nil, :data_dir => nil do
  include_recipe "redis"
  node[:redis][:instances][params[:name]] = ::Chef::Attribute.new unless node[:redis][:instances][params[:name]].is_a?(::Chef::Attribute)
  node[:redis][:instances][params[:name]][:port] = params[:port] if params[:port]
  node[:redis][:instances][params[:name]][:data_dir] = params[:data_dir] if params[:data_dir]
  unless params[:name] == "default"
    conf = ::Chef::Mixin::DeepMerge.merge(node[:redis][:instances][:default], node[:redis][:instances][params[:name]])
  else
    conf = node[:redis][:instances][:default]
  end

  directory node[:redis][:instances][params[:name]][:data_dir] do
    owner node[:redis][:user]
    mode "0750"
  end

  template ::File.join(node[:redis][:conf_dir], "redis_#{params[:name]}.conf") do
    source "redis.conf.erb"
    variables :conf => conf
    notifies :restart, "service[redis_#{params[:name]}]"
  end

  service "redis_#{params[:name]}" do
    supports :reload => false, :restart => true, :start => true, :stop => true
    running true
    action [:start, :enable]
  end
end
