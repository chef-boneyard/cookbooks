#
# Copyright 2012, Opscode, Inc.
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

describe "postfix::server" do
  include Helpers::Postfix
  it 'doesnt configure postfix because solo is unsupported' do
    skip "Postfix may be set up by default on the system, but not configured by Chef because this test assumes it is run under Chef Solo"
  end
end
