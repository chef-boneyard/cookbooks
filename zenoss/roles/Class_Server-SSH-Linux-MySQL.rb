name "ServerSSHLinuxMySQL"
description "Linux & MySQL monitoring via SSH"
default_attributes(
                   "zenoss" => {
                     "device" => {                   
                       "properties" => {
                         "zCommandUsername" => "zenoss",
                         "zKeyPath" => "/home/zenoss/.ssh/id_dsa",
                         "zMySqlPassword" => "zenoss",
                         "zMySqlUsername" => "zenoss"
                       }
                       # "modeler_plugins" => [
                       #                       "zenoss.cmd.uname", 
                       #                       "zenoss.cmd.uname_a", 
                       #                       "zenoss.cmd.df",
                       #                       "zenoss.cmd.linux.cpuinfo",
                       #                       "zenoss.cmd.linux.memory",
                       #                       "zenoss.cmd.linux.ifconfig",
                       #                       "zenoss.cmd.linux.netstat_an",
                       #                       "zenoss.cmd.linux.netstat_rn",
                       #                      ],
                       # "templates" => ['Device']
                     }
                   }
                   )

override_attributes(
                   "zenoss" => {
                     "device" => {                   
                       "device_class" => "/Server/SSH/Linux/MySQL"
                     }
                   }
                   )

#this could change to zenoss::client_mysqlssh or something eventually
run_list(
         "recipe[zenoss::client]"
         )
