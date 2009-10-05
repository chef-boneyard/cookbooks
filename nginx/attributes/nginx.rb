case platform
when "debian","ubuntu"
  set[:nginx][:dir]     = "/etc/nginx"
  set[:nginx][:log_dir] = "/var/log/nginx"
  set[:nginx][:user]    = "www-data"
  set[:nginx][:binary]  = "/usr/sbin/nginx"
else   
  set[:nginx][:dir]     = "/etc/nginx"
  set[:nginx][:log_dir] = "/var/log/nginx"
  set[:nginx][:user]    = "www-data"
  set[:nginx][:binary]  = "/usr/sbin/nginx"
end

set_unless[:nginx][:gzip] = "on"
set_unless[:nginx][:gzip_http_version] = "1.0"
set_unless[:nginx][:gzip_comp_level] = "2"
set_unless[:nginx][:gzip_proxied] = "any"
set_unless[:nginx][:gzip_types] = [
  "text/plain",
  "text/html",
  "text/css",
  "application/x-javascript",
  "text/xml",
  "application/xml",
  "application/xml+rss",
  "text/javascript"
]

set_unless[:nginx][:keepalive]          = "on"
set_unless[:nginx][:keepalive_timeout]  = 65
set_unless[:nginx][:worker_processes]   = 1
set_unless[:nginx][:worker_connections] = 1024
set_unless[:nginx][:server_names_hash_bucket_size] = 64
