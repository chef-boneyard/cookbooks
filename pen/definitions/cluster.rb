define :pen_cluster, :nodes => nil, :port => nil, :user => 'root',
  :timeout => 5, :check_interval => 60 do
  svc = "pen-#{params[:name]}"

  pen_nodes = params[:nodes].map do |n|
    a = [n[:host], n[:port]]
    a.push(n[:max_clients]) if n.has_key? :max_clients
    a.push(n[:hard_max_clients]) if n.has_key? :hard_max_clients and a.count = 3
    a.push(n[:weight]) if n.has_key? :weight and a.count = 4
    a.push(n[:priority]) if n.has_key? :priority and a.count = 4
    a.join(':')
  end

  template "/etc/init/#{svc}.conf" do
    notifies :restart, "service[#{svc}]"
    variables :pen_nodes => pen_nodes, :port => params[:port], :name => params[:node]
    source "pen.upstart.conf.erb"
    cookbook "pen"
  end

  service svc do
    running true
    start_command "pen " + params[:nodes].join(" ")
    action :start
  end
end

