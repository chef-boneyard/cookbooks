include_recipe "Doat::webserver_common"

app_config = data_bag_item(:doat_config, :flyapps)
sql = search(:endpoints, "type:rds AND id:#{app_config[:rds]}").first
sql_credentials = search(:credentials, "id:#{app_config[:db_credentials_id]}").first

template "/opt/doat/apps/common/Setting.local.php" do
  source "prod-apps-settings.php.erb"
  notifies :restart, "service[php-cgi]" if node[:php][:apc][:stat] == 0
  variables :sql => sql, :sql_credentials => sql_credentials, :app_config => app_config
end

template ::File.join(node[:nginx][:conf_dir], "sites-enabled", "doat-flyapps") do
  source "nginx-flyapps.conf.erb"
  notifies :reload, "service[nginx]"
end

nginx_site "doat-flyapps"
