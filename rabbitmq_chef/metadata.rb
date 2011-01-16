maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs the RabbitMQ AMQP Broker for use on a Chef Server."
version           "0.10.4"

recipe "rabbitmq_chef", "Install and configure rabbitmq specifically for a Chef Server"

depends "erlang"

%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
