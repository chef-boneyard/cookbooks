include_recipe "Doat"
include_recipe "redis"
include_recipe "Doat::scribe-client"

package "python-crypto"
package "python-nltk"
easy_install_package "PySQLPool"
easy_install_package "Crypto.Ciper"

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
  "/opt/doat/etc/scripts/autocompleted"
end

redis_master = provider_for_service(:redis_melt, :filters => {:replication => "master"})
template "/opt/doat/etc/servers/core/core.conf" do
  source "core.conf.erb"
  variables :redis_master => redis_master, :redis_search_node => node
  notifies :restart, "service[cored]"
end

service "autocompleted" do
  action [:start, :enable]
  supports :restart => false
end

service "cored" do
  action [:start, :enable]
end

