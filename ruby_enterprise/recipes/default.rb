%w(zlib1g-dev libssl-dev libreadline5-dev).each do |p|
  package p
end

remote_file "/usr/local/src/ruby-enterprise-#{node[:ruby_enterprise_edition][:version]}.tar.gz" do
  source node[:ruby_enterprise_edition][:url]
  not_if { ::File.exist?("/usr/local/src/ruby-enterprise-#{node[:ruby_enterprise_edition][:version]}.tar.gz") }
end

execute "Expand ruby enterprise edition tarball" do
  cwd "/usr/local/src"
  command "tar xzf ruby-enterprise-#{node[:ruby_enterprise_edition][:version]}.tar.gz"
  not_if { ::File.directory?("/usr/local/src/ruby-enterprise-#{node[:ruby_enterprise_edition][:version]}") }
end

execute "Install ruby enterprise edition" do
  cwd "/usr/local/src/ruby-enterprise-#{node[:ruby_enterprise_edition][:version]}"
  command "./installer --auto=#{node[:ruby_enterprise_edition][:install_path]} && echo '#{node[:ruby_enterprise_edition][:version]}' > /etc/ruby-enterprise-version"
  not_if {
    ::File.read('/etc/ruby-enterprise-version') == node[:ruby_enterprise_edition][:version] && 
    ::File.exist?("#{node[:ruby_enterprise_edition][:install_path]}/bin/ruby") && 
    system(node[:ruby_enterprise_edition][:cow_friendly])
  }
end