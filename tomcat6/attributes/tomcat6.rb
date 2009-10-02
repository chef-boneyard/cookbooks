tomcat6 Mash.new unless attribute?("tomcat6")

# Where the various parts of tomcat6 are
case platform
when "centos"
  tomcat6[:start]     = "/etc/init.d/tomcat6 start"
  tomcat6[:stop]     = "/etc/init.d/tomcat6 stop"
  tomcat6[:restart]     = "/etc/init.d/tomcat6 restart"
  tomcat6[:home]     = "/usr/share/tomcat6" #don't use a trailing slash. it brakes init script
  tomcat6[:dir]     = "/etc/tomcat6/"
  tomcat6[:conf]     = "/etc/tomcat6"
  tomcat6[:temp]     = "/var/tmp/tomcat6"
  tomcat6[:logs] = "/var/log/tomcat6"
  tomcat6[:webapp_base_dir] = "/srv/tomcat6/"
  tomcat6[:webapps] = File.join(tomcat6[:webapp_base_dir],"webapps")
  tomcat6[:user]    = "tomcat"
  tomcat6[:manager_dir] = File.join(tomcat6[:home],"webapps/manager")
  tomcat6[:port] = 8080
  tomcat6[:ssl_port] = 8433
  
else
  tomcat6[:start]     = "/etc/init.d/tomcat6 start"
  tomcat6[:stop]     = "/etc/init.d/tomcat6 stop"
  tomcat6[:restart]     = "/etc/init.d/tomcat6 restart"
  tomcat6[:home]     = "/usr/share/tomcat6/" #don't use a trailing slash. it brakes init script
  tomcat6[:dir]     = "/etc/tomcat"
  tomcat6[:conf]     = "/etc/tomcat6"
  tomcat6[:temp]     = "/var/tmp/tomcat6"
  tomcat6[:logs] = "/var/log/tomcat6"
  tomcat6[:webapp_base_dir] = "/srv/tomcat6/"
  tomcat6[:webapps] = File.join(tomcat6[:webapp_base_dir],"webapps")
  tomcat6[:user]    = "tomcat"
  tomcat6[:manager_dir] = "/usr/share/tomcat6/webapps/manager"
  tomcat6[:port] = 8080
  tomcat6[:ssl_port] = 8433
end

tomcat6[:version]= "6.0.18" unless tomcat6.has_key?(:version)

tomcat6[:with_native] = false unless tomcat6.has_key?(:with_native)
tomcat6[:java_home] = "/usr/lib/jvm/java" unless tomcat6.has_key?(:java_home)
tomcat6[:java_opts] = "" unless tomcat6.has_key?(:java_opts)
tomcat6[:manager_user] = "manager" unless tomcat6.has_key?(:manager_user)
tomcat6[:manager_password] = "manager" unless tomcat6.has_key?(:manager_password)
tomcat6[:permgen_min_free_in_mb] = 24 unless tomcat6.has_key?(:permgen_min_free_in_mb)


