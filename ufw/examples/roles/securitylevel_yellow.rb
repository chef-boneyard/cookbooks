name "securitylevel_yellow"
description "Security level 'yellow'"
override_attributes(
  "firewall" => {
    "securitylevel" => "yellow"
  }
  )
