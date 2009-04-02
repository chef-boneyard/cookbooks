memcached Mash.new unless attribute?("memcached")
memcached[:memory] = 64     unless memcached.has_key?(:memory)
memcached[:port] = 11211    unless memcached.has_key?(:port)
memcached[:user] = "nobody" unless memcached.has_key?(:user)
