case platform
when "Debian","Ubuntu"
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
