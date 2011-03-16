#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Attribute:: default
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['php']['install_method'] = 'package'

case node["platform"]
when "centos", "redhat", "fedora"
  default['php']['conf_dir'] = '/etc'
  default['php']['ext_conf_dir'] = '/etc/php.d'
  default['php']['fpm_user'] = 'nobody'
  default['php']['fpm_group'] = 'nobody'
else
  default['php']['conf_dir'] = '/etc/php5/cli'
  default['php']['ext_conf_dir'] = '/etc/php5/conf.d'
  default['php']['fpm_user'] = 'www-data'
  default['php']['fpm_group'] = 'www-data'
end

default['php']['url'] = 'http://us.php.net/distributions'
default['php']['version'] = '5.3.5'
default['php']['checksum'] = 'a25ddae6a59d7345bcbb69ef2517784f56c2069af663ae4611e580cbdec77e22'
default['php']['prefix_dir'] = '/usr/local'

default['php']['configure_options'] = %W{--prefix=#{php['prefix_dir']}
                                          --with-libdir=#{kernel['machine'] =~ /x86_64/ ? 'lib64' : 'lib'}
                                          --with-config-file-path=#{php['conf_dir']}
                                          --with-config-file-scan-dir=#{php['ext_conf_dir']}
                                          --with-pear
                                          --enable-fpm
                                          --with-fpm-user=#{php['fpm_user']}
                                          --with-fpm-group=#{php['fpm_group']}
                                          --with-zlib
                                          --with-openssl
                                          --with-kerberos
                                          --with-bz2
                                          --with-curl
                                          --enable-ftp
                                          --enable-zip
                                          --enable-exif
                                          --with-gd
                                          --enable-gd-native-ttf
                                          --with-gettext
                                          --with-gmp
                                          --with-mhash
                                          --with-iconv
                                          --with-imap
                                          --with-imap-ssl
                                          --enable-sockets
                                          --enable-soap
                                          --with-xmlrpc
                                          --with-libevent-dir
                                          --with-mcrypt
                                          --enable-mbstring
                                          --with-t1lib
                                          --with-mysql
                                          --with-mysqli=/usr/bin/mysql_config
                                          --with-mysql-sock
                                          --with-sqlite3
                                          --with-pdo-mysql
                                          --with-pdo-sqlite}
