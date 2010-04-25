set_unless[:rabbitmq][:nodename]  = "rabbit"
set_unless[:rabbitmq][:address]  = "0.0.0.0"
set_unless[:rabbitmq][:port]  = "5672"
set_unless[:rabbitmq][:erl_args]  = "+K true +A 30 \
-kernel inet_default_listen_options [{nodelay,true},{sndbuf,16384},{recbuf,4096}] \
-kernel inet_default_connect_options [{nodelay,true}]"
set_unless[:rabbitmq][:start_args] = ""
set_unless[:rabbitmq][:logdir] = "/var/log/rabbitmq"
set_unless[:rabbitmq][:mnesiadir] = "/var/lib/rabbitmq/mnesia"
set_unless[:rabbitmq][:cluster] = "no"
set_unless[:rabbitmq][:cluster_config] = "/etc/rabbitmq/rabbitmq_cluster.config"
set_unless[:rabbitmq][:cluster_disk_nodes] = []
