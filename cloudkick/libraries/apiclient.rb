#!/usr/bin/env ruby
#
# Cookbook Name:: cloudkick
# Library:: apiclient
# Author:: Greg Albrecht <gba@splunk.com>
# Copyright:: Copyright (c) 2011 Splunk, Inc.
#
# License::
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
# Library for manipulating Cloudkick Monitors and Checks.
#  - Unit tests included!
#
# = To run Unit Tests:
#   $ ruby apiclient.rb
#
# = See also:
#   * Cloudkick API Documentation: https://support.cloudkick.com/API/2.0
#

require 'rubygems'

# Assume Chef Cookbook will install the required gem(s).
begin
  require 'oauth'
rescue LoadError
  # FIXME(ampledata@20111017) Assumes Chef's logger:
  Chef::Log.warn("Missing gem 'oauth'")
end

require 'json'
require 'test/unit'


module Cloudkick

  class APIClientError < StandardError
    attr_reader :request

    def initialize(request)
      @request = request
    end

    def to_s
      [request.inspect, request.body] * " "
    end
  end

  class APIClient

    def initialize(oauth_key, oauth_secret)
      consumer = OAuth::Consumer.new(oauth_key, oauth_secret,
                                     :site => "https://api.cloudkick.com",
                                     :http_method => :get)
      @access_token = OAuth::AccessToken.new(consumer)
    end
    
    # Private method to create a monitor, expects the monitor to
    # not already exist.
    # Raises an exception if the monitor is not created.
    def create_monitor(name, query, notes)
      resource_uri = '/2.0/monitors'

      monitor_parameters = {:name => name, :query => query, :notes => notes}

      request = @access_token.post(resource_uri, monitor_parameters)

      case request.response.code
      when "201"
        request.response.body
      else
        raise APIClientError, request
      end
    end
    
    # Gets a monitors attributes. If the monitor doesn't exist, it's created.
    def get_monitor(name, query, notes)
      monitor_attributes = find_monitor(name)
      if monitor_attributes.nil?
        create_monitor(name, query, notes)
        find_monitor(name)
      else
        monitor_attributes
      end
    end
    
    def list_monitors
      resource_uri = '/2.0/monitors'
    
      request = @access_token.get(resource_uri)
    
      case request.response.code
      when "200"
        JSON.parse(request.response.body, :symbolize_names => true)
      else
        raise APIClientError, request
      end
    end
    
    def find_monitor(name)
      all_monitors = list_monitors[:items]
      all_monitors.select{ |m| m[:name] == name }.first
    end
  
    def change_monitor_state(name, state)
      monitor_attributes = find_monitor(name)
      # Trust No One.
      escaped_id = OAuth::Helper.escape(monitor_attributes[:id])
      escaped_state = OAuth::Helper.escape(state)
      resource_uri = "/2.0/monitor/#{escaped_id}/#{escaped_state}"
    
      request = @access_token.post(resource_uri)
    
      case request.response.code
      when "204"
        request.response.body
      else
        raise APIClientError, request
      end
    end
    private :change_monitor_state
  
    def enable_monitor(name)
      change_monitor_state(name=name, state='enable')
    end
  
    def disable_monitor(name)
      change_monitor_state(name=name, state='disable')
    end
    
    # Private method to create a Check, expects the Check to
    # not already exist.
    # Raises an exception if the Check is not created.
    def create_check(check_details, check_code, check_params)
      resource_uri = '/2.0/checks'

      # We can POST the 'code' integer as the Check 'type' here, despite
      # the fact that a later GET for this Check will return 'type' as a dict.
      check_params[:type] = check_code
      check_params[:details] = JSON.generate(check_details)

      request = @access_token.post(resource_uri, check_params)

      case request.response.code
      when "201"
        request.response.body
      else
        raise APIClientError, request
      end
    end
    private :create_check

    def get_check(check_details, check_code, check_params)
      check_attributes = find_check(check_details=check_details,
                                    check_code=check_code,
                                    check_params=check_params)
      if check_attributes.nil?
        create_check(check_details=check_details,
                     check_code=check_code,
                     check_params=check_params)
        find_check(check_details=check_details,
                   check_code=check_code,
                   check_params=check_params)
      else
        check_attributes
      end
    end

    def list_checks(monitor_id=nil)
      resource_uri = '/2.0/checks'
    
      check_parameters = monitor_id ? {'monitor_id' => monitor_id} : nil
    
      request = @access_token.get(resource_uri, check_parameters)
    
      case request.response.code
      when "200"
        JSON.parse(request.response.body, :symbolize_names => true)
      else
        raise APIClientError, request
      end
    end

    def find_check(check_details, check_code, check_params=nil)
      check_params ||= Hash.new
      check_params[:type] = {:code => check_code}
      check_params[:details] = check_details

      all_checks = list_checks(check_params[:monitor_id])[:items]
      all_checks.each{ |c| c[:type].delete(:description) }

      check_params.each do |k,v|
        all_checks.delete_if do |check|
          check[k] != v
        end
      end

      all_checks.first
    end

    # FIXME(ampledata@20111017) This method is untested
    def find_check_by_id(check_id)
      all_checks = list_checks(check_params[:monitor_id])[:items]
      all_checks.select{ |c| c[:id] == check_id }.first
    end

    def check_types
      resource_uri = '/2.0/check_types'
    
      request = @access_token.get(resource_uri)
    
      case request.response.code
      when "200"
        request.response.body
      else
        raise APIClientError, request
      end
    end
  end
end


# README: Replace these with your Cloudkick API Keys if
# you want to run unit tests.
OAUTH_KEY = 'xxx'
OAUTH_SECRET = 'yyy'

# FIXME(ampledata@20111014): This test needs to run in a squence, where
# Monitor tests are run FIRST, then Checks.
class TestCloudkickAPIClientMonitors < Test::Unit::TestCase

  def setup
    @apiclient = Cloudkick::APIClient.new(OAUTH_KEY, OAUTH_SECRET)
    @monitor_name = 'TEST APIClient Monitor 2'
  end

  def test_auth_bad
    bad_ck = Cloudkick::APIClient.new('bad_key', 'bad_secret')

    assert_kind_of(Cloudkick::APIClient, bad_ck)
    assert_raise(Cloudkick::APIClientError){bad_ck.list_monitors}
  end

  def test_auth_good
    assert_kind_of(Cloudkick::APIClient, @apiclient)
    assert_nothing_raised(Cloudkick::APIClientError){@apiclient.list_monitors}
  end

  def test_list_monitors
    all_monitors = @apiclient.list_monitors

    assert(test=!all_monitors[:items].empty?,
           msg='No Monitors were found on Cloudkick.')
  end

  def test_find_monitor
    look_for = 'agent'
    our_monitor = @apiclient.find_monitor(name=look_for)

    assert(our_monitor[:name] == look_for)
  end

  def test_get_monitor
    monitor_attributes = @apiclient.get_monitor(@monitor_name,
                                                @monitor_name,
                                                @monitor_name)
    assert(monitor_attributes[:name] == @monitor_name)
  end

  def test_disable_monitor
    @apiclient.disable_monitor(@monitor_name)
    monitor_attributes = @apiclient.find_monitor(name=@monitor_name)

    assert(monitor_attributes[:is_active] == false)
  end

  def test_enable_monitor
    @apiclient.enable_monitor(@monitor_name)
    monitor_attributes = @apiclient.find_monitor(name=@monitor_name)

    assert(monitor_attributes[:is_active] == true)
  end
end

# FIXME(ampledata@20111014): This test needs to run in a squence, where
# Monitor tests are run FIRST, then Checks.
class TestCloudkickAPIClientChecks < Test::Unit::TestCase

  def setup
    @apiclient = Cloudkick::APIClient.new(OAUTH_KEY, OAUTH_SECRET)
    monitor_name = 'TEST APIClient Monitor 2'
    @monitor_id = @apiclient.find_monitor(name=monitor_name)[:id]
    @check_name = 'TEST APIClient Check 2'
  end

  def test_auth_bad
    bad_ck = Cloudkick::APIClient.new('bad_key', 'bad_secret')

    assert_kind_of(Cloudkick::APIClient, bad_ck)
    assert_raise(Cloudkick::APIClientError){bad_ck.list_checks}
  end

  def test_auth_good
    assert_kind_of(Cloudkick::APIClient, @apiclient)
    assert_nothing_raised(Cloudkick::APIClientError){@apiclient.list_checks}
  end

  def test_list_checks
    all_checks = @apiclient.list_checks

    assert(!all_checks[:items].empty?,
           msg='No Checks were found on Cloudkick.')
  end

  # TODO(ampledata@0111017) Write this test.
  def test_check_types
    @apiclient.check_types
  end

  def test_get_check
    check_details = {:path => '/test_get_check',
                     :fs_critical => 95, :fs_warn => 90}
    check_code = 51
    check_params = {:monitor_id => @monitor_id}
    check_attributes = @apiclient.get_check(check_details=check_details,
                                            check_code=check_code,
                                            check_params=check_params)
    assert(check_attributes[:monitor_id] == @monitor_id)
    assert(check_attributes[:details] == check_details)
    # FIXME(ampledata@20111018) This is returning false now, wtf?
    #assert(check_attributes[:is_enabled] == true)
  end

  # TODO(ampledata@20111017) Write this test.
  def test_find_check
    # TODO(gba) Search by check id, not name
    #our_check = @apiclient.find_check(check_params)
  end
end
