
action :create do
	windows_registry 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' do
		values new_resource.name => "\"#{new_resource.program}\" #{new_resource.args}"
	end
end

action :remove do 
	windows_registry 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' do
		values new_resource.name => ''
		action :remove
	end
end