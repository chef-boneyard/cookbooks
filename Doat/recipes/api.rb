include_recipe "Doat::webserver_common"

template "/opt/doat/www/gondor/services/doat/0.4/include/Setting.local.php" do
  source "api-Settings.local.php.erb"
  notifies :restart, "service[php-cgi]" if node[:php][:apc][:stat] == 0
end

template ::File.join(node[:nginx][:conf_dir], "sites-enabled", "doat-api") do
  source "nginx-api.conf.erb"
  notifies :reload, "service[nginx]"
end

nginx_site "doat-api"
