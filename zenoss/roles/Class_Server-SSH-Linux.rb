name "ServerSSHLinux"
description "Linux monitoring via SSH"
#use the default modeler_plugins and templates for the device class
default_attributes(
                   "zenoss" => {
                     "device" => {                   
                       "properties" => {
                         "zCommandUsername" => "zenoss",
                         "zKeyPath" => "/home/zenoss/.ssh/id_dsa"
                       }
                     }
                   }
                   )

override_attributes(
                   "zenoss" => {
                     "device" => {                   
                       "device_class" => "/Server/SSH/Linux",
                     }
                   }
                   )
run_list(
         "recipe[zenoss::client]"
         )
