include_recipe "Doat::webserver_common"

template ::File.join(node[:nginx][:conf_dir], "sites-enabled", "doat-webui") do
  source "nginx-webui.conf.erb"
end

nginx_site "doat-webui"
