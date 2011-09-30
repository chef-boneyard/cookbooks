name "drbd-pair-master"
description "DRBD pair role."

override_attributes(
  "drbd" => {
    "remote_host" => "ubuntu2-1004.vm",
    "disk" => "/dev/sdb1",
    "fs_type" => "xfs",
    "mount" => "/shared",
    "master" => true
  }
  )

run_list(
  "recipe[xfs]",
  "recipe[drbd::pair]"
  )
