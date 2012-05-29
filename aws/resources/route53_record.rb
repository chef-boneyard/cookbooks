actions :create, :delete

attribute :name, :kind_of => String, :name_attribute => true
attribute :domain, :kind_of => String
attribute :aws_access_key, :kind_of => String, :required => true
attribute :aws_secret_access_key, :kind_of => String, :required => true
attribute :hosted_zone_aws_id, :kind_of => String, :required => true
attribute :record_type, :kind_of => String, :required => true
attribute :ttl, :kind_of => Integer, :default => 600
attribute :resource_records, :kind_of => Array, :required => true
