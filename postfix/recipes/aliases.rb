require_recipe "postfix"

execute "update-postfix-aliases" do
  command "newaliases"
  action :nothing
end

template "/etc/aliases" do
  source "aliases.erb"
  notifies :run, resources("execute[update-postfix-aliases]")
  #notifies :reload, resources(:service => "postfix")
end

