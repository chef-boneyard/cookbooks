set_unless[:passenger][:version] = "2.2.8"
set[:passenger][:root_path]   = "#{languages[:ruby][:gems_dir]}/gems/passenger-#{passenger[:version]}"
set[:passenger][:module_path] = "#{passenger[:root_path]}/ext/apache2/mod_passenger.so"
