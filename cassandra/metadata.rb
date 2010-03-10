maintainer        "Benjamin Black"
maintainer_email  "b@b3k.us"
license           "Apache 2.0"
description       "Installs and configures the Cassandra distributed storage system"
version           "0.1"
recipe            "cassandra::autoconf", "Automatically configure nodes from chef-server information."

%w{ubuntu debian}.each do |os|
  supports os
end

attribute "cassandra",
  :display_name => "Cassandra",
  :description => "Hash of Cassandra attributes",
  :type => "hash"

attribute "cassandra/cluster_name",
  :display_name => "Cassandra cluster name",
  :description => "The name for the Cassandra cluster in which this node should participate.  The default is 'Test Cluster'.",
  :default => "Test Cluster"

# Lots more goes here...