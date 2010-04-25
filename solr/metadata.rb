maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Sets up environment for solr instances"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.8"
suggests          "ruby"

%w{ java capistrano runit }.each do |cb|
  depends cb
end

%w{ debian ubuntu }.each do |os|
  supports os
end

attribute "solr/user",
  :display_name => "Solr User",
  :description => "Username for solr instance",
  :default => "solr"

attribute "solr/uid",
  :display_name => "Solr UID",
  :description => "UID for solr instance",
  :default => "551"

attribute "solr/group",
  :display_name => "Solr Group",
  :description => "Group for solr instance",
  :default => "solr"

attribute "solr/gid",
  :display_name => "Solr GID",
  :description => "GID for solr instance",
  :default => "551"

