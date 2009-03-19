maradns Mash.new unless attribute?("maradns")

maradns[:recursive_acl] = "" unless maradns.has_key?(:recursive_acl)
