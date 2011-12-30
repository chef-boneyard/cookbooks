name "ZenossServer"
description "Role to use as basis for configuring Zenoss Server"
#a number of server attributes are available for customization
#you may want to set the [:zenoss][:server][:admin_password]
default_attributes(
                   "zenoss" => {
                     "device" => {
                       "properties" => {
                         "zCommandUsername" => "zenoss",
                         "zKeyPath" => "/home/zenoss/.ssh/id_dsa",
                         "zMySqlPassword" => "zenoss",
                         "zMySqlUsername" => "zenoss"
                       }
                     }
                   }
                   )

override_attributes(
                    "zenoss" => {
                      "device" => {
                        "device_class" => "/Server/SSH/Linux"
                      }
                    }
                    )

run_list(
         "recipe[zenoss::server]"
         )
