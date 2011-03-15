include_recipe "Doat"
include_recipe "Doat::redis"
include_recipe "Doat::scribe-client"

link "/etc/init.d/cored" do
  to "/opt/doat/etc/servers/core/init.d/cored"
end

link "/etc/init.d/autocompleted" do
  "/opt/doat/etc/scripts/autocompleted"
end

%w(cored autocompleted).each do |srv|
  service srv do
    action [:start, :enable]
  end
end
