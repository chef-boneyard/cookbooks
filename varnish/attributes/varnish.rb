varnish Mash.new unless attribute?("varnish")

case platform
when "debian","ubuntu"
  varnish[:dir]     = "/etc/varnish"
  varnish[:default] = "/etc/default/varnish"
end
