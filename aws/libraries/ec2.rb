# TODO: once sync_libraries properly handles sub-directories, move this file to aws/libraries/opscode/aws/ec2.rb

begin
  require 'right_aws'
rescue LoadError
  Chef::Log.warn("Missing gem 'right_aws'")
end

require 'open-uri'

module Opscode
  module Aws
    module Ec2
      def find_snapshot_id(volume_id="")
        snapshot_id = nil 
        ec2.describe_snapshots.sort { |a,b| b[:aws_started_at] <=> a[:aws_started_at] }.each do |snapshot|
          if snapshot[:aws_volume_id] == volume_id
            snapshot_id = snapshot[:aws_id]
          end
        end
        raise "Cannot find snapshot id!" unless snapshot_id
        Chef::Log.debug("Snapshot ID is #{snapshot_id}")
        snapshot_id
      end

      def ec2
        region = instance_availability_zone
        region = region[0, region.length-1]
        @@ec2 ||= RightAws::Ec2.new(new_resource.aws_access_key, new_resource.aws_secret_access_key, { :logger => Chef::Log, :region => region })
      end

      def instance_id
        @@instance_id ||= query_instance_id
      end

      def instance_availability_zone
        @@instance_availability_zone ||= query_instance_availability_zone
      end

      private

      def query_instance_id
        instance_id = open('http://169.254.169.254/latest/meta-data/instance-id'){|f| f.gets}
        raise "Cannot find instance id!" unless instance_id
        Chef::Log.debug("Instance ID is #{instance_id}")
        instance_id
      end

      def query_instance_availability_zone
        availability_zone = open('http://169.254.169.254/latest/meta-data/placement/availability-zone/'){|f| f.gets}
        raise "Cannot find availability zone!" unless availability_zone
        Chef::Log.debug("Instance's availability zone is #{availability_zone}")
        availability_zone
      end

    end
  end
end
