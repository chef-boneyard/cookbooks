default[:doat][:core][:port] = 9091
default[:doat][:core][:melt][:redis_db] = 15
default[:doat][:core][:workers] = case node[:ec2][:instance_type]
                                      when "m2.xlarge" then 8
                                      when "c2.xlarge" then 16
                                      else; 8
                                      end
default[:doat][:core][:monitor_port] = 9000
default[:doat][:core][:ping_port] = 9001
default[:doat][:core][:monitor_sample_length] = 3600
