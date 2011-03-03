bash "run bundle install in app directory" do
  cwd File.join(node[:bundler][:apps_path], node[:bundler][:app], "current")
  code "bundle install"
end
