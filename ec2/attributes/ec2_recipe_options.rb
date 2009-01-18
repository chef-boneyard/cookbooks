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

# Whether to use LVM for Ephemeral storage
ec2_use_lvm_ephemeral true unless attribute?("ec2_lvm_ephemeral")

# Where to mount the LVM Ephemeral Storage 
ec2_lvm_ephemeral_mountpoint "/mnt" unless attribute?("ec2_lvm_ephemeral_mountpoint")

# What to name the LVM volume group
ec2_lvm_ephemeral_volume_group "ephemeral" unless attribute?("ec2_lvm_ephemeral_volume_group")

# What to name the LVM logical volume
ec2_lvm_ephemeral_logical_volume "store" unless attribute?("ec2_lvm_ephemeral_logical_volume")

# Which devices to use for LVM Ephemeral Storage
ec2_ephemeral_devices({
  "m1.small"  => [ "/dev/sda2" ],
  "m1.large"  => [ "/dev/sdb", "/dev/sdc" ],
  "m1.xlarge" => [ "/dev/sdb", "/dev/sdc", "/dev/sdd", "/dev/sde" ],
}) unless attribute?("ec2_ephemeral_devices")

