def initianize(name,run_context=nil)
  super
  @action = :add
end

actions :add, :remove

attribute :path, :kind_of => String, :name_attribute => true
