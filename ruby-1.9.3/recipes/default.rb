arch = (node['kernel']['machine'] == "x86_64") ? "amd64" : "i386"

package "libyaml-0-2" do
  action :install
end

package "libssl0.9.8" do
  action :install
end

["libffi5_3.0.9-1_#{arch}",
  "libruby1.9.1_1.9.3.0-1_#{arch}",
  "ruby1.9.1_1.9.3.0-1_#{arch}",
  "libruby1.9.1-dbg_1.9.3.0-1_#{arch}",
  "ruby1.9.1-dev_1.9.3.0-1_#{arch}",
  "ri1.9.1_1.9.3.0-1_all",
  "ruby1.9.1-examples_1.9.3.0-1_all",
  "ruby1.9.1-full_1.9.3.0-1_all",
  "ruby1.9.3_1.9.3.0-1_all"
].each do |package|
  file_path = "/tmp/#{package}.deb"
  remote_file package do
    path file_path
    source "https://github.com/tapajos/ruby-1.9.3-ubuntu-lucid/raw/master/#{arch}/#{package}.deb"
  end if !File.exists?(file_path)
  package package do
    action :install
    source file_path
    provider Chef::Provider::Package::Dpkg
  end
end

execute "update-alternatives" do
  command "ln -sf /usr/bin/gem1.9.3 /etc/alternatives/gem && ln -sf /usr/bin/rdoc1.9.3 /etc/alternatives/rdoc && ln -sf /usr/bin/rake1.9.3 /etc/alternatives/rake && ln -sf /usr/bin/erb1.9.3 /etc/alternatives/erb && ln -sf /usr/bin/ri1.9.3 /etc/alternatives/ri && ln -sf /usr/bin/ruby1.9.3 /etc/alternatives/ruby && ln -sf /usr/bin/irb1.9.3 /etc/alternatives/irb"
  action :run
end