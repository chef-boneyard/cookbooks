#
# Author:: Philip (flip) Kromer for Infochimps.org
# Cookbook Name:: cassandra
# Recipe:: autoconf
#
# Copyright 2010, Infochimps, Inc
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

# Much inspiration for this code taken from corresponding functionality in
# Benjamin Black (<b@b3k.us>)'s cassandra cookbooks
#

#
# ClusterServiceDiscovery --
#
# Allow nodes to discover the location for a given service at runtime, adapting
# when new services register.
#
# Operations:
#
# * provide a service. A timestamp records the last registry.
# * discover all providers for the given service.
# * discover the most recent provider for that service.
# * get the 'public_ip' for a provider -- the address that nodes in the larger
#   world should use
# * get the 'public_ip' for a provider -- the address that nodes on the local
#   subnet / private cloud should use
#
# Implementation
#
# Nodes register a service by setting the +[:cluster][:services][service_name]+
# attribute. This attribute is a hash containing at 'timestamp' (the time of
# registry), but the service can pass in an arbitrary hash of values to merge
# in.
#
module ClusterServiceDiscovery

  # Find all nodes that have indicated they provide the given service,
  # in descending order of when they registered.
  #
  # If :within_last is passed as an option, only return servers
  # registering for the service within the last given seconds.
  #
  # If :since is passed as an option, only return servers registering
  # for the service since the given time.
  #
  # If :at_least is passed as an option, try to return at least the
  # given number of servers, even if they violate the constraints
  # given above.  If fewer servers are available than requested, even
  # after violating the above constraints, then we give up and return
  # the most we can.
  def all_providers_for_service service_name, options={}
    Chef::Log.debug("Looking up providers for #{service_name} given #{options.inspect}")
    # set the horizon
    horizon = case
              when options[:within_last]
                Time.now - options[:within_last].to_i
              when options[:since]
                Time.at(options[:since]) # works for either epoch seconds or Time object
              else
                Time.at(0)
              end

    # find servers before and after horizon
    search_query = "cluster_services:#{service_name}"
    Chef::Log.debug("Search query: \"#{search_query}\"")
    servers = search(:node, search_query )
    Chef::Log.debug("#{servers.count} servers returned from search")
    all_servers = servers.find_all do |server|
      server[:cluster][:services][service_name] && server[:cluster][:services][service_name]['timestamp']
    end
    if node[:cluster].attribute?(:environment) 
      all_servers = all_servers.find_all do |server|
        begin; server[:cluster][:environment] == node[:cluster][:environment]; rescue; true; end
      end
    end
    if options.has_key? :service_filters
      all_servers = all_servers.find_all do |server|
        options[:service_filters].all? do |filter, value|
          server[:cluster][:services][service_name].attribute?(filter) ? (server[:cluster][:services][service_name][filter] == value) : false
        end
      end
    end

    servers_before_horizon, servers_after_horizon = [], []
    all_servers.each do |server|
      if Time.parse(server[:cluster][:services][service_name]['timestamp']) >= horizon
        servers_after_horizon << server
      else
        servers_before_horizon << server
      end
    end

    # pad what we've found if necessary
    if options[:at_least]
      extra_servers = servers_before_horizon.sort_by { |server| server[:cluster][:services][service_name]['timestamp'] }
      while (servers_after_horizon.length < options[:at_least].to_i) && (! extra_servers.empty?)
        servers_after_horizon << extra_servers.pop
      end
    end

    # return sorted servers
    Chef::Log.debug("About to return #{servers_after_horizon.count} service providers")
    servers_after_horizon.sort_by { |server| server[:cluster][:services][service_name]['timestamp'] }
  end

  # Find the most recent node that registered to provide the given service
  def provider_for_service service_name, options={}
    all_providers_for_service(service_name, options).last
  end

  # Register to provide the given service.
  # If you pass in a hash of information, it will be added to
  # the registry, and available to clients
  def provide_service service_name, service_info={}
    Chef::Log.info("Registering to provide #{service_name}: #{service_info.inspect}")
    node.set[:cluster][:services][service_name] = {
      :timestamp  => ClusterServiceDiscovery.timestamp,
    }.merge(service_info)
    node.save
  end

  # given service, get most recent address

  # The local-only ip address for the most recent provider for service_name
  def provider_private_ip service_name, options={}
    server = provider_for_service(service_name, options) or return
    private_ip_of(server)
  end

  # The globally-accessable ip address for the most recent provider for service_name
  def provider_public_ip service_name, options={}
    server = provider_for_service(service_name, options) or return
    public_ip_of(server)
  end

  # given service, get many addresses

  # The local-only ip address for all providers for service_name
  def all_provider_private_ips service_name, options={}
    servers = all_providers_for_service(service_name, options)
    servers.map{ |server| private_ip_of(server) }
  end

  # The globally-accessable ip address for all providers for service_name
  def all_provider_public_ips service_name, options={}
    servers = all_providers_for_service(service_name, options)
    servers.map{ |server| public_ip_of(server) }
  end

  # given server, get address

  # The local-only ip address for the given server
  def private_ip_of server
    server[:cloud][:private_ips].first rescue server[:ipaddress]
  end

  # The globally-accessable ip address for the given server
  def public_ip_of server
    server[:cloud][:public_ips].first  rescue server[:ipaddress]
  end

  # A compact timestamp, to record when services are registered
  def self.timestamp
    Time.now.utc.strftime("%Y%m%d%H%M%SZ")
  end

end
class Chef::Recipe              ; include ClusterServiceDiscovery ; end
class Chef::Resource::Directory ; include ClusterServiceDiscovery ; end
class Chef::Resource            ; include ClusterServiceDiscovery ; end
