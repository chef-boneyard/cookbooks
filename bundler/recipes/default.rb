include_recipe "ruby"
include_recipe "rubygems"

%w{ bundler }.each do |bundler_gem|
  gem_package bundler_gem do
    if node[:bundler][:version]
      version node[:bundler][:version]
      action :install
    else
      action :install
    end
  end
end
