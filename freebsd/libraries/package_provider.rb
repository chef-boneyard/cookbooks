#
# Cookbook Name:: freebsd
# Libraries:: package_provider
#
# Copyright 2012, ZephirWorks
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

require 'chef/provider/package/freebsd'

class Chef
  class Provider
    class Package
      class Freebsd

        alias :original_initialize :initialize
        def initialize(*args)
          original_initialize(*args)

          if node.platform?("freebsd") && node.platform_version.to_f < 8.2 &&
              @new_resource.source != "ports"
            Chef::Log.info "Packages for FreeBSD < 8.2 are gone, forcing #{@new_resource.name} to install from ports (was: #{@new_resource.source.inspect})"
            @new_resource.source("ports")
          end
        end
      end
    end
  end
end
