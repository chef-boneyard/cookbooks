passenger Mash.new unless attribute?("passenger")

passenger[:version]          = "2.2.4" unless passenger.has_key?(:version)
passenger[:root_path]        = "#{languages[:ruby][:gems_dir]}/gems/passenger-#{passenger[:version]}"
passenger[:module_path]      = "#{passenger[:root_path]}/ext/apache2/mod_passenger.so"
