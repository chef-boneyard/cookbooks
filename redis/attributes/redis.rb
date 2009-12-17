set_unless[:redis][:address]  = "0.0.0.0"
set_unless[:redis][:port]  = "6379"
set_unless[:redis][:pidfile] = "/var/run/redis.pid"
set_unless[:redis][:logfile] = "/var/log/redis.log"
set_unless[:redis][:dbdir] = "/var/lib/redis"
set_unless[:redis][:dbfile] = "dump.rdb"
set_unless[:redis][:client_timeout] = "300"
set_unless[:redis][:glueoutputbuf] = "yes"

set_unless[:redis][:saves] = [["900", "1"], ["300", "10"], ["60", "10000"]]

set_unless[:redis][:slave] = "no"
if redis[:slave] == "yes"
  set_unless[:master_server] = "redis-master." + domain
  set_unless[:master_port] = "6379"
end

set_unless[:sharedobjects] = "no"
if redis[:sharedobjects] == "yes"
  set_unless[:shareobjectspoolsize] = 1024
end

