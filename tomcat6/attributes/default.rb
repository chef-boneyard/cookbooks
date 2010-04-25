# Where the various parts of tomcat6 are
case platform
when "centos"
  set[:tomcat6][:start]           = "/etc/init.d/tomcat6 start"
  set[:tomcat6][:stop]            = "/etc/init.d/tomcat6 stop"
  set[:tomcat6][:restart]         = "/etc/init.d/tomcat6 restart"
  set[:tomcat6][:home]            = "/usr/share/tomcat6" #don't use trailing slash. it breaks init script
  set[:tomcat6][:dir]             = "/etc/tomcat6/"
  set[:tomcat6][:conf]            = "/etc/tomcat6"
  set[:tomcat6][:temp]            = "/var/tmp/tomcat6"
  set[:tomcat6][:logs]            = "/var/log/tomcat6"
  set[:tomcat6][:webapp_base_dir] = "/srv/tomcat6/"
  set[:tomcat6][:webapps]         = File.join(tomcat6[:webapp_base_dir],"webapps")
  set[:tomcat6][:user]            = "tomcat"
  set[:tomcat6][:manager_dir]     = File.join(tomcat6[:home],"webapps/manager")
  set[:tomcat6][:port]            = 8080
  set[:tomcat6][:ssl_port]        = 8433
else
  set[:tomcat6][:start]           = "/etc/init.d/tomcat6 start"
  set[:tomcat6][:stop]            = "/etc/init.d/tomcat6 stop"
  set[:tomcat6][:restart]         = "/etc/init.d/tomcat6 restart"
  set[:tomcat6][:home]            = "/usr/share/tomcat6" #don't use trailing slash. it breaks init script
  set[:tomcat6][:dir]             = "/etc/tomcat"
  set[:tomcat6][:conf]            = "/etc/tomcat6"
  set[:tomcat6][:temp]            = "/var/tmp/tomcat6"
  set[:tomcat6][:logs]            = "/var/log/tomcat6"
  set[:tomcat6][:webapp_base_dir] = "/srv/tomcat6/"
  set[:tomcat6][:webapps]         = File.join(tomcat6[:webapp_base_dir],"webapps")
  set[:tomcat6][:user]            = "tomcat"
  set[:tomcat6][:manager_dir]     = "/usr/share/tomcat6/webapps/manager"
  set[:tomcat6][:port]            = 8080
  set[:tomcat6][:ssl_port]        = 8433
end

set_unless[:tomcat6][:version]          = "6.0.18"
set_unless[:tomcat6][:with_native]      = false
set_unless[:tomcat6][:java_home]        = "/usr/lib/jvm/java"
set_unless[:tomcat6][:java_opts]        = ""
set_unless[:tomcat6][:manager_user]     = "manager"
set_unless[:tomcat6][:manager_password] = "manager"
set_unless[:tomcat6][:permgen_min_free_in_mb] = 24
