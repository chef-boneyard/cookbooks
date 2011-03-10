default[:php][:cgi][:max_requests] = 20000
default[:php][:cgi][:bin]          = "/usr/bin/php-cgi"
default[:php][:cgi][:pidfile]      = "/var/run/php-cgi.pid"
default[:php][:cgi][:port]         = "9000"
default[:php][:cgi][:bindaddress]  = "0.0.0.0"
default[:php][:cgi][:php_ini]      = "/etc/php5/cgi/php.ini"
default[:php][:cgi][:user]            = "www-data"
default[:php][:cgi][:children]     = 
if attribute? :ec2
  case node[:ec2][:instance_type]
  when "m1.small" then 30
  when "c1.medium" then 55
  when "m1.large" then 250
  when "c1.xlarge" then 230
  else
    50
  end
else
  65
end
