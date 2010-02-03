actions :associate, :disassociate

attribute :aws_access_key,        :kind_of => String
attribute :aws_secret_access_key, :kind_of => String
attribute :ip,                    :kind_of => String
attribute :timeout,               :default => 3*60 # 3 mins, nil or 0 for no timeout
