include_recipe "Doat"
include_recipe "nginx"
include_recipe "php::php5-cgi"

template ::File.join(node[:nginx][:conf_dir], "sites-enabled", "doat-webui") do
  source "doat-webui"
end
