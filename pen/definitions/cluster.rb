define :pen_cluster, :nodes => nil, :port => nil, :user => 'root',
  :timeout => 5, :check_interval => 60 do
  include_recipe "pen"
  svc = "pen-#{params[:name]}"

  pen_nodes = params[:nodes].map do |n|
    a = [n[:host], n[:port]]
    a.push(n[:max_clients]) if n.has_key? :max_clients
    a.push(n[:hard_max_clients]) if n.has_key? :hard_max_clients and a.count = 3
    a.push(n[:weight]) if n.has_key? :weight and a.count = 4
    a.push(n[:priority]) if n.has_key? :priority and a.count = 4
    a.join(':')
  end

  if node[:pen][:init_style] == "upstart"
    init_file = "/etc/init/#{svc}.conf"
    init_template = "pen.upstart.conf.erb"
  else
    init_file = "/etc/init.d/#{svc}.conf"
    init_template = "pen.init.erb"
  end

  template init_file do
    notifies :restart, "service[#{svc}]"
    variables :pen_nodes => pen_nodes.sort, :port => params[:port], :name => params[:name], :pen_options => params[:arguments]
    source init_template
    cookbook "pen"
  end

  service svc do
    action :start
    if node[:pen][:init_style] == "upstart"
      provider ::Chef::Provider::Service::Upstart
      restart_command "stop #{svc}; start #{svc}"
    end
  end
end

