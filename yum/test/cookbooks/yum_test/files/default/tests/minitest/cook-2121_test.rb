#
# Cookbook Name:: yum_test
#
# Copyright 2013, Opscode, Inc.
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

require File.expand_path('../support/helpers', __FILE__)

describe "yum_test::default" do
  include Helpers::YumTest

  it 'doesnt update the zenos-add.repo file if it exists' do
    assert File.zero?('/etc/yum.repos.d/zenoss-add.repo')
  end

  it 'updates the zenoss-create file' do
    file('/etc/yum.repos.d/zenoss-create.repo').must_match %r[baseurl=http://dev.zenoss.com/yum/stable/]
  end
end
