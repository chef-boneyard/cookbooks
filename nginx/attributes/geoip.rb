#
# Cookbook Name:: nginx
# Attributes:: geoip
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
# Copyright 2012, Vial Studios
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

default[:nginx][:geoip][:path]                 = "/srv/geoip"
default[:nginx][:geoip][:enable_city]          = true
default[:nginx][:geoip][:country_dat_url]      = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
default[:nginx][:geoip][:country_dat_checksum] = "a8c1ffeea5edae7e89150f83029a71bb"
default[:nginx][:geoip][:city_dat_url]         = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"
default[:nginx][:geoip][:city_dat_checksum]    = "1075c5dcd106d937c29879330713b8e5"
default[:nginx][:geoip][:lib_version]          = "1.4.8"
default[:nginx][:geoip][:lib_url]              = "http://geolite.maxmind.com/download/geoip/api/c/GeoIP-#{node[:nginx][:geoip][:lib_version]}.tar.gz"
default[:nginx][:geoip][:lib_checksum]         = "05b7300435336231b556df5ab36f326d"
