#
# Cookbook Name:: git
# Attributes:: default
#

case platform
when "windows"
  set[:git][:version] = "1.7.9-preview20120201"
  set[:git][:url] = "http://msysgit.googlecode.com/files/Git-#{node[:git][:version]}.exe"
end
