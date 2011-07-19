case platform
when "debian","ubuntu"
  set[:varnish][:dir]     = "/etc/varnish"
  set[:varnish][:default] = "/etc/default/varnish"
when "centos","redhat"
  set[:varnish][:dir]     = "/etc/varnish"
  set[:varnish][:default] = "/etc/sysconfig/varnish"
end
