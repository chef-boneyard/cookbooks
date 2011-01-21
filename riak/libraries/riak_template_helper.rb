#
# Author:: Benjamin Black (<b@b3k.us>) and Sean Cribbs (<sean@basho.com>)
# Cookbook Name:: riak
#
# Copyright (c) 2010 Basho Technologies, Inc.
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
require 'delegate'
module RiakTemplateHelper
  class Tuple < DelegateClass(Array)
    include RiakTemplateHelper
    def to_s
      "{" << map {|i| value_to_erlang(i) }.join(", ") << "}"
    end
  end

  def value_to_erlang(v, depth=1)
    case v
    when Hash
      to_erlang_config(v, depth+1)
    when String
      "\"#{v}\""
    when Array
      "[" << v.map {|i| value_to_erlang(i) }.join(", ") << "]"
    else
      v.to_s
    end
  end
  
  # Lifted from Ripple's Riak::TestServer
  def to_erlang_config(hash, depth = 1)
    padding = '    ' * depth
    parent_padding = '    ' * (depth-1)
    values = hash.map do |k,v|
      "{#{k}, #{value_to_erlang(v, depth)}}"
    end.join(",\n#{padding}")
    "[\n#{padding}#{values}\n#{parent_padding}]"
  end

  RIAK_REMOVE_CONFIGS = ['package', 'erlang']
  RIAK_TRANSLATE_CONFIGS = {
    'core' => 'riak_core',
    'kv' => 'riak_kv',
    'err' => 'riak_err'
  }

  def prepare_app_config(riak)
    # Don't muck with the node attributes
    riak = riak.to_hash

    # Remove sections we don't care about
    riak.reject! {|k,_| RIAK_REMOVE_CONFIGS.include? k }

    # Rename sections
    riak.each do |k,v|
      next if k.nil?
      if RIAK_TRANSLATE_CONFIGS.include? k
        riak[RIAK_TRANSLATE_CONFIGS[k]] = riak.delete(k)
      end
    end

    # Only limit Erlang port range if limit_port_range is true
    if riak['kernel'] && riak['kernel']['limit_port_range']
      riak['kernel'].delete 'limit_port_range'
    else
      riak.delete 'kernel'
    end

    # Select the backend configuration
    riak['riak_kv']['storage_backend'] = riak['riak_kv']['storage_backend'].to_sym
    case riak['riak_kv']['storage_backend']
    when :riak_kv_bitcask_backend
      riak.delete('innostore')
      riak['riak_kv'].delete('riak_kv_dets_backend_root')
    when :riak_kv_innostore_backend
      riak.delete('bitcask')
      riak['riak_kv'].delete('riak_kv_dets_backend_root')
    when :riak_kv_dets_backend
      riak.delete('innostore')
      riak.delete('bitcask')
    end

    # Tuple-ize appropriate settings
    riak['sasl']['sasl_error_logger'] = Tuple.new([:file, riak['sasl']['sasl_error_logger']['file']])

    allifs = lambda {|pair| pair[0] == "0.0.0.0" }
    %w{http https}.each do |protocol|
      if pairs = riak['riak_core'][protocol]
        # If there's all-interfaces bindings ("0.0.0.0"), remove any
        # specific interface bindings on the associated ports. Trying
        # to bind twice will prevent riak from starting without much
        # diagnostic information.
        if pairs.any?(&allifs)
          ports = pairs.select(&allifs).map {|pair| pair[1] }
          pairs = pairs.delete_if {|(intf, port)| ports.include?(port) && intf != "0.0.0.0" }
        end
        riak['riak_core'][protocol] = pairs.uniq.map { |pair| Tuple.new(pair) }
      end
    end

    # Return the sanitized config
    riak
  end

  RIAK_VM_ARGS = {
    "node_name" => "-name",
    "cookie" => "-setcookie",
    "heart" => "-heart",
    "kernel_polling" => "+K",
    "async_threads" => "+A",
    "smp" => "-smp",
    "env_vars" => "-env"
  }

  def prepare_vm_args(config)    
    config.map do |k,v|
      key = RIAK_VM_ARGS[k.to_s]
      case v
      when false
        nil
      when Hash
        # Mostly for env_vars
        v.map {|ik,iv| "#{key} #{ik} #{iv}" }
      else
        "#{key} #{v}"
      end
    end.flatten.compact
  end
end

class Chef::Resource::Template
  include RiakTemplateHelper
end

class Erubis::Context
  include RiakTemplateHelper
end
