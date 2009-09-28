#
# Cookbook Name:: ec2
# Attribute File:: ec2_metadata.rb
#
# Copyright 2008-2009, Opscode, Inc.
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

require 'net/http'

def get_from_ec2(thing="/")
  base_url = "http://169.254.169.254/latest/meta-data" + thing
  url = URI.parse(base_url)
  req = Net::HTTP::Get.new(url.path)
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  res.body
end

if @attribute["domain"] =~ /\.amazonaws.com$/ || @attribute["domain"] == "ec2.internal"
  ec2 true
  get_from_ec2.split("\n").each do |key|
    if key =~ /\/$/
      get_from_ec2("/#{key}").split("\n").each do |extra_key|
        attr_name = "ec2-#{key}-#{extra_key}"
        attr_name.gsub!("/", "")
        @attribute[attr_name] = get_from_ec2("/#{key}/#{extra_key}")
      end
    end
    @attribute["ec2-#{key}"] = get_from_ec2("/#{key}")
  end
end
