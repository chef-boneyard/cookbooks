name "fw_https"
description "Firewall rules for https"
override_attributes(
  "firewall" => {
    "rules" => [
      {"https" => {
          "port" => "443"
        }
      }
    ]
  }
  )
