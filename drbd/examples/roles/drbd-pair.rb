name "drbd-pair"
description "DRBD pair role."

override_attributes(
  "drbd" => {
    "disk" => "/dev/sdb",
    "fs_type" => "xfs",
    "mount" => "/drbd"
  }
  )

run_list(
  "recipe[xfs]",
  "recipe[drbd::pair]"
  )
