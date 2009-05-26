chef Mash.new unless attribute?("chef")
chef[:indexer_log] = "/var/log/chef/indexer.log" unless chef.has_key?(:indexer_log)
