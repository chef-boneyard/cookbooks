actions :run

attribute :name, :kind_of => String, :default => '', :name_attribute => true
attribute :devices, :kind_of => Hash, :default => {}
attribute :locations, :kind_of => Array, :default => []
attribute :groups, :kind_of => Array, :default => []
