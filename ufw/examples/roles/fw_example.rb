name "fw_example"
description "Firewall rules for Examples"
override_attributes(
  "firewall" => {
    "rules" => [
      {"tftp" => {}},
      {"http" => {
          "port" => "80"
        }
      },
      {"block tomcat from 192.168.1.0/24" => {
          "port" => "8080",
          "source" => "192.168.1.0/24",
          "action" => "deny"
        }
      },
      {"Allow access to udp 1.2.3.4 port 5469 from 1.2.3.5 port 5469" => {
          "protocol" => "udp",
          "port" => "5469",
          "source" => "1.2.3.4",
          "destination" => "1.2.3.5",
          "dest_port" => "5469"
        }
      }
    ]
  }
  )
