#
# Cookbook Name:: apt
# Recipe:: upgrade
#

e = execute "apt-get upgrade -y" do
  action :nothing
end

e.run_action(:run)
