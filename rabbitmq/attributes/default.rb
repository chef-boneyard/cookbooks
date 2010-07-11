default[:rabbitmq][:nodename]  = "rabbit"
default[:rabbitmq][:address]  = "0.0.0.0"
default[:rabbitmq][:port]  = "5672"
default[:rabbitmq][:erl_args]  = "+K true +A 30 \
-kernel inet_default_listen_options [{nodelay,true},{sndbuf,16384},{recbuf,4096}] \
-kernel inet_default_connect_options [{nodelay,true}]"
default[:rabbitmq][:start_args] = ""
default[:rabbitmq][:logdir] = "/var/log/rabbitmq"
default[:rabbitmq][:mnesiadir] = "/var/lib/rabbitmq/mnesia"
default[:rabbitmq][:cluster] = "no"
default[:rabbitmq][:cluster_config] = "/etc/rabbitmq/rabbitmq_cluster.config"
default[:rabbitmq][:cluster_disk_nodes] = []
