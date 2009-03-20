rails Mash.new unless attribute?("rails")

rails[:version] = false unless rails.has_key?(:version)
rails[:environment] = "production" unless rails.has_key?(:environment)
rails[:max_pool_size] = 4 unless rails.has_key?(:max_pool_size)