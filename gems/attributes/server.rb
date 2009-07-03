gem_server Mash.new unless attribute?("gem_server")

gem_server[:virtual_host_name]  = "gems.#{domain}" unless gem_server.has_key?(:virtual_host_name)
gem_server[:virtual_host_alias] = "gems"           unless gem_server.has_key?(:virtual_host_alias)
gem_server[:directory]          = "/srv/gems"      unless gem_server.has_key?(:directory)
