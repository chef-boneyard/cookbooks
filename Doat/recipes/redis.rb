# custom version of redis
include_recipe "Doat"

replication_role = node[:redis][:replication][:role]
link "/etc/init.d/redis" do
  to "/opt/doat/etc/servers/core/init.d/redis-#{replication_role}"
end

arch = case node[:kernel][:machine]
       when "x86_x64" then "x86"
       when "i386" then "i386"
       else "noarch"
       end
%w(redis-server redis-cli).each do |bin|
  link "/usr/local/bin/#{bin}" do
    to "/opt/doat/bin/#{arch}/#{bin}"
  end
end

service "redis" do
  action [:start, :enable]
end
