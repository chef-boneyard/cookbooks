gems_path `gem env gemdir`.chomp!
ruby_path `which ruby`.chomp!

passenger Mash.new unless attribute?("passenger")

passenger[:version]          = "2.2.1" unless passenger.has_key?(:version)
passenger[:root_path]        = "#{gems_path}/gems/passenger-#{passenger[:version]}"
passenger[:module_path]      = "#{passenger[:root_path]}/ext/apache2/mod_passenger.so"
passenger[:apache_load_path] = "#{apache[:dir]}/mods-available/passenger.load" if attribute?("apache")
passenger[:apache_conf_path] = "#{apache[:dir]}/mods-available/passenger.conf" if attribute?("apache")