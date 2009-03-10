gem_server = Mash.new unless attribute?("gem_server")

gem_server[:virtual_hostname] = "gems.#{domain}" unless gem_server.has_key?("virtual_host")
gem_server[:virtual_alias]    = "gems"           unless gem_server.has_key?("virtual_alias")
gem_server[:directory]        = "/srv/gems"      unless gem_server.has_key?("directory")
