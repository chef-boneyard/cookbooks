#
# Cookbook Name:: yumrepo
# Recipe:: dell
#
# Copyright 2010, Tippr Inc.
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

define :yumkey do

  package "gnupg"

  execute "rpm --import /etc/pki/rpm-gpg/#{params[:name]}" do
    action :nothing
    not_if <<-EOH
    function packagenames_for_keyfile() {
      local filename="$1"
      gpg \
        --with-fingerprint \
        --with-colons \
        --fixed-list-mode \
        "$filename" \
      | gawk -F: '/^pub/ { print tolower(sprintf("gpg-pubkey-%s-%x\\n", substr($5, length($5)-8+1), $6)) }'
    }

    for pkgname in $(packagenames_for_keyfile "/etc/pki/rpm-gpg/#{params[:name]}"); do
      if [[ $pkgname ]] && ! rpm -q $pkgname ; then
        exit 1;
      fi;
    done

    exit 0
    EOH
  end

  cookbook_file "/etc/pki/rpm-gpg/#{params[:name]}" do
    mode "0644"
    source params[:name]
    notifies :run, resources(:execute => "rpm --import /etc/pki/rpm-gpg/#{params[:name]}"), :immediately
  end
end

# vim: ai et sts=2 sw=2 ts=2
