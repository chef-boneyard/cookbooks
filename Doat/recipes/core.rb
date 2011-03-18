include_recipe "Doat"
include_recipe "redis"
include_recipe "Doat::scribe-client"
include_recipe "python"

%w(python-crypto python-nltk python-mysqldb python-enchant).each do |pkg|
  package pkg
end

%w(PySQLPool redis hiredis).each do |pkg|
  easy_install_package pkg
end

redis_instance "melt" do
  data_dir "/var/lib/redis/melt"
  port 6378
end

redis_instance "search" do
  data_dir "/var/lib/redis/search"
  port 6379
end

link "/etc/init.d/cored" do
  to "/opt/doat/etc/servers/core/init.d/cored"
end

link "/etc/init.d/autocompleted" do
  to "/opt/doat/etc/scripts/autocompleted"
end

if node[:redis][:instances][:melt][:replication][:role] == "master"
  redis_melt_master = node
else
  redis_melt_master = provider_for_service(:redis_melt, :filters => {:replication => "master"})
end
app_config = data_bag_item(:doat_config, :core)
sql_host = search(:endpoints, "type:rds AND db:#{app_config["db"]}").first
sql_credentials = search(:credentials, "usage:db_#{app_config["db"]}").first

template "/opt/doat/etc/servers/core/core.conf" do
  source "core.conf.erb"
  variables :redis_melt_master => redis_melt_master, :redis_melt_slave => node, :redis_search_node => node,
    :sql_credentials => sql_credentials, :sql => sql_host, :autocomplete_node => node,
    :app_config => app_config
  notifies :restart, "service[cored]"
end

service "autocompleted" do
  action [:start, :enable]
  supports :restart => false
end

service "cored" do
  action [:start, :enable]
end

