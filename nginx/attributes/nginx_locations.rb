case platform
when "debian","ubuntu"
  nginx_dir      "/etc/nginx"
  nginx_log_dir  "/var/log/nginx"
  nginx_user     "www-data"
  nginx_binary   "/usr/sbin/nginx"
else
  nginx_dir      "/etc/nginx"
  nginx_log_dir  "/var/log/nginx"
  nginx_user     "www-data"
  nginx_binary   "/usr/sbin/nginx"
end
