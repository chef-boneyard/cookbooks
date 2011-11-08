

package "libwww-perl"
package "libcrypt-ssleay-perl"

template "#{node['nagios']['config_dir']}/pagerduty_nagios.cfg" do
  owner "nagios"
  group "nagios"
  mode 0644
  source "pagerduty_nagios.cfg.erb"
end

cookbook_file "#{node['nagios']['plugin_dir']}/pagerduty_nagios.pl" do
  owner "root"
  group "root"
  mode 0755
  source "plugins/pagerduty_nagios.pl"
end

cron "Flush Pagerduty" do
  user "nagios"
  mailto "root@localhost"
  command "#{node['nagios']['plugin_dir']}/pagerduty_nagios.pl flush"
end