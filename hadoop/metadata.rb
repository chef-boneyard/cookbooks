maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs hadoop and sets up basic cluster per Cloudera's quick start docs"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.8.1"
depends           "java"

recipe "hadoop", "Installs hadoop from Cloudera's repo"
recipe "hadoop::conf_pseudo", "Installs hadoop-conf-pseudo and enables hadoop services"
recipe "hadoop::doc", "Installs hadoop documentation"
recipe "hadoop::hive", "Installs hadoop's hive package"
recipe "hadoop::pig", "Installs hadoop's pig package"

%w{ debian ubuntu }.each do |os|
  supports os
end
