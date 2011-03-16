include_recipe "Doat::webserver_common"

template ::File.join(node[:nginx][:conf_dir], "sites-enabled", "doat-webui") do
  source "nginx-webui.conf.erb"
  notifies :reload, "service[nginx]"
end

nginx_site "doat-webui"
