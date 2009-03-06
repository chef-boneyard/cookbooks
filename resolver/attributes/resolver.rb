resolver Mash.new unless attribute?("resolver")

resolver[:search] = domain      unless resolver.has_key?(:search)
resolver[:nameservers] = [ "" ] unless resolver.has_key?(:nameservers)
