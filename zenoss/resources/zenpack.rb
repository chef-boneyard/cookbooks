actions :install, :remove

#package name of the zenpack
attribute :package, :kind_of => String, :name_attribute => true
attribute :version, :kind_of => String
attribute :py_version, :kind_of =>String,  :default => "py2.6" 
attribute :exists, :default => false
