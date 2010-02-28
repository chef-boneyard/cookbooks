maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs the RabbitMQ AMQP Broker"
version           "0.10"

%w{ centos redhat fedora ubuntu debian }.each do |os|
  supports os
end
