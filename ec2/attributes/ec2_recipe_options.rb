#
# Cookbook Name:: ec2
# Attribute File:: ec2_recipe_options.rb
#
# Copyright 2008, OpsCode, Inc.
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

ec2 Mash.new unless attribute?("ec2")
ec2[:lvm] = Mash.new unless ec2.has_key?(:lvm)
ec2[:lvm][:use_ephemeral]  = true unless ec2[:lvm].has_key?(:use_ephemeral)
ec2[:lvm][:ephemeral_mountpoint] = "/mnt" unless ec2[:lvm].has_key?(:ephemeral_mountpoint)
ec2[:lvm][:ephemeral_volume_group] = "ephemeral" unless ec2[:lvm].has_key?(:ephemeral_volume_group)
ec2[:lvm][:ephemeral_logical_volume] = "store" unless ec2[:lvm].has_key?(:ephemeral_logical_volume)
ec2[:lvm][:ephemeral_devices] = {
  "m1.small"  => [ "/dev/sda2" ],
  "m1.large"  => [ "/dev/sdb", "/dev/sdc" ],
  "m1.xlarge" => [ "/dev/sdb", "/dev/sdc", "/dev/sdd", "/dev/sde" ],
} unless ec2[:lvm].has_key?(:ephemeral_devices)
