kickstart Mash.new unless attribute?("kickstart")
kickstart[:rootpw] = nil unless kickstart.has_key?(:rootpw)
kickstart[:virtual_host_name] = "build.#{domain}" unless kickstart.has_key?(:virtual_host_name)