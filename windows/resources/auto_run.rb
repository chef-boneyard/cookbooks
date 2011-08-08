actions :create, :remove

attribute :program, :kind_of => String
attribute :name, :kind_of => String, :name_attribute => true
attribute :args, :kind_of => String, :default => ''
