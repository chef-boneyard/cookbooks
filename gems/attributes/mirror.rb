gem_server Mash.new unless attribute?("gem_server")

gem_server[:rf_virtual_host_name]  = "rubyforge.#{domain}" unless gem_server.has_key?(:rf_virtual_host_name)
gem_server[:rf_virtual_host_alias] = "rubyforge"           unless gem_server.has_key?(:rf_virtual_host_alias)
gem_server[:rf_directory]          = "/srv/rubyforge"      unless gem_server.has_key?(:rf_directory)
