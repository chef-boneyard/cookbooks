action :create do
	windows_registry Windows::KeyHelper::ENV_KEY do
		values new_resource.name => new_resource.value
		action :create
	end
end

action :remove do 
	windows_registry Windows::KeyHelper::ENV_KEY do
		values new_resource.name => ''
		action :remove
	end
end