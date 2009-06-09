maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs hadoop and sets up basic cluster per Hadoop's quick start docs"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"
depends           "java"

%w{ redhat centos fedora debian ubuntu }.each do |os|
  supports os
end

attribute  "hadoop",
  :display_name => "Hadoop",
  :description => "Hash of Hadoop attributes",
  :type => "hash"
  
attribute "hadoop/mirror_url",
  :display_name => "Hadoop Mirror URL",
  :description => "The mirror where we download Hadoop",
  :default => "http://apache.osuosl.org/hadoop/core"

attribute "hadoop/version",
  :display_name => "Hadoop Version",
  :description => "Version of Hadoop to download and install",
  :default => "0.19.1"

attribute "hadoop/uid",
  :display_name => "Hadoop UID",
  :description => "Default UID of the hadoop user",
  :default => "991"

attribute "hadoop/gid",
  :display_name => "Hadoop GID",
  :description => "Default group of the hadoop user",
  :default => "65534" # ie, nobody
  
attribute "hadoop/java_home",
  :display_name => "Hadoop Java Home",
  :description => "JAVA_HOME environment variable for Hadoop",
  :default => "/usr/lib/jvm/java-6-sun-JAVA_VERSION"