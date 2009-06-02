case platform
when "debian","ubuntu"
  haproxy_dir      "/etc/varnish"
  haproxy_default "/etc/default/varnish"
end
