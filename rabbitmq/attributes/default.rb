# being nil, the rabbitmq defaults will be used
default[:rabbitmq][:nodename]  = nil
default[:rabbitmq][:address]  = nil
default[:rabbitmq][:port]  = nil
default[:rabbitmq][:config] = nil
default[:rabbitmq][:logdir] = nil
default[:rabbitmq][:mnesiadir] = nil

# config file location
# http://www.rabbitmq.com/configure.html#define-environment-variables
# "The .config extension is automatically appended by the Erlang runtime."
default[:rabbitmq][:config] = "/etc/rabbitmq/rabbitmq"

# rabbitmq.config defaults
default[:rabbitmq][:default_user] = 'guest'
default[:rabbitmq][:default_pass] = 'guest'

#clustering
default[:rabbitmq][:cluster] = false
default[:rabbitmq][:cluster_disk_nodes] = []
default[:rabbitmq][:erlang_cookie] = 'AnyAlphaNumericStringWillDo'

#ssl
default[:rabbitmq][:ssl] = false
default[:rabbitmq][:ssl_port] = '5671'
default[:rabbitmq][:ssl_cacert] = '/path/to/cacert.pem'
default[:rabbitmq][:ssl_cert] = '/path/to/cert.pem'
default[:rabbitmq][:ssl_key] = '/path/to/key.pem'
