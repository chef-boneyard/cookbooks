action :create do
  success = true
  if record_exists?
    Chef::Log.warn('Record already exists')
    success = false
  else
    resource_record_sets = [{:name => "#{new_resource.name}.#{domain}",
                             :type => new_resource.record_type,
                             :ttl => new_resource.ttl,
                             :resource_records => new_resource.resource_records}]
    begin
      route53.create_resource_record_sets(new_resource.hosted_zone_aws_id, resource_record_sets)
    rescue Exception => e
      Chef::Log.error("Error creating Route53 record: #{e.message}")
      success = false
    end
  end
  new_resource.updated_by_last_action(success)
end

action :delete do
  success = true
  if record_exists?
    resource_record_sets = [{:name => "#{new_resource.name}.#{domain}",
                             :type => new_resource.record_type,
                             :ttl => new_resource.ttl,
                             :resource_records => new_resource.resource_records}]
    begin
      route53.delete_resource_record_sets(new_resource.hosted_zone_aws_id, resource_record_sets)
    rescue Exception => e
      Chef::Log.error("Error deleting Route53 record: #{e.message}")
      success = false
    end
  else
    Chef::Log.warn('Record does not exists')
    success = false
  end
  new_resource.updated_by_last_action(success)
end

private

def record_exists?
  records = route53.list_resource_record_sets(new_resource.hosted_zone_aws_id)
  records.each do |record|
    parts = record[:name].split('.')
    if parts[0] == new_resource.name
      return true
    end
  end
  false
end

def route53
  @route53 ||= RightAws::Route53Interface.new(new_resource.aws_access_key, new_resource.aws_secret_access_key)
end

def domain
  new_resource.domain || node[:aws][:route53][:domain]
end
