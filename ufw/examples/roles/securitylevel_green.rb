name "securitylevel_green"
description "Security level 'green'"
override_attributes(
  "firewall" => {
    "securitylevel" => "green"
  }
  )
