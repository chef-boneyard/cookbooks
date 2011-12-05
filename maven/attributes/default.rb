# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Apache 2.0 license
# Cookbook Name:: maven
# Attributes:: default

default['maven']['version'] = 2
default['maven']['m2_home'] = '/usr/local/maven/default'
default['maven']['2']['url'] = "http://www.apache.org/dist/maven/binaries/apache-maven-2.2.1-bin.tar.gz"
default['maven']['2']['checksum'] = "b9a36559486a862abfc7fb2064fd1429f20333caae95ac51215d06d72c02d376"
default['maven']['3']['url'] = 'http://www.apache.org/dist/maven/binaries/apache-maven-3.0.3-bin.tar.gz'
default['maven']['3']['checksum'] =  "4fb4a392d879ebcd19dc5a05f9d779aed7f1e3356c8c9e6200b15f8b6e1f85e0"
