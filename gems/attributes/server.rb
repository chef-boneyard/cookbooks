set_unless[:gem_server][:virtual_host_name]  = "gems.#{domain}"
set_unless[:gem_server][:virtual_host_alias] = "gems"
set_unless[:gem_server][:directory]          = "/srv/gems"
