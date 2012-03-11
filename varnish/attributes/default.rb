case platform
when "debian","ubuntu"
  set[:varnish][:dir]     = "/etc/varnish"
  set[:varnish][:default] = "/etc/default/varnish"
end

default[:varnish][:listen_port] = 6081
default[:varnish][:admin_port] = 6082
default[:varnish][:backend_host] = "localhost"
default[:varnish][:backend_port] = 8080
