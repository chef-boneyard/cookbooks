nginx_gzip "on" unless attribute?("nginx_gzip")
nginx_gzip_http_version "1.0" unless attribute?("nginx_gzip_http_version")
nginx_gzip_comp_level "2" unless attribute?("nginx_gzip_comp_level")
nginx_gzip_proxied "any" unless attribute?("nginx_gzip_proxied")
nginx_gzip_types [ "text/plain", "text/html", "text/css", "application/x-javascript", "text/xml", "application/xml", "application/xml+rss", "text/javascript" ] unless attribute?("nginx_gzip_types")

nginx_keepalive "on" unless attribute?("nginx_keepalive")
nginx_keepalive_timeout 65 unless attribute?("nginx_keepalive_timeout")

nginx_worker_processes 1 unless attribute?("nginx_worker_processes")
nginx_worker_connections 1024 unless attribute?("nginx_worker_connections")
nginx_server_names_hash_bucket_size 64 unless attribute?("nginx_server_names_hash_bucket_size")
