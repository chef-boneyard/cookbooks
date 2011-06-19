actions :run, :deviceclass, :group, :system, :location, :users

attribute :name, :kind_of => String, :name_attribute => true
attribute :command, :kind_of => String #command to run via zendmd
attribute :description, :kind_of => String
attribute :modeler_plugins, :kind_of => Array, :default => []
attribute :templates, :kind_of => Array, :default => []
attribute :properties, :kind_of => Hash, :default => {}
attribute :location, :kind_of => String
attribute :address, :kind_of => String
attribute :users, :kind_of => Array, :default => []
