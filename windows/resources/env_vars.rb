def initianize(name,run_context=nil)
	super
	@action = :create
end

actions :create, :remove

attribute :value, :kind_of => String
attribute :name, :kind_of => String, :name_attribute => true
