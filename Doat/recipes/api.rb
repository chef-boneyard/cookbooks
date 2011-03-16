include_recipe "Doat::webserver_common"

template ::File.join(node[:nginx][:conf_dir], "sites-enabled", "doat-api") do
  source "nginx-api.conf.erb"
  notifies :reload, "service[nginx]"
end

nginx_site "doat-api"
