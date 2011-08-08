action :add do
	path = ENV['PATH'].split(';')
	if !path.include?(new_resource.path)
		path.insert(-1,new_resource.path)
	end
	
	windows_registry Windows::KeyHelper::ENV_KEY do
		values 'Path' => path.join(';')
	end
	timeoutVars
end

action :remove do
	path = ENV['PATH'].split(';')
	path.delete(new_resource.path)
	windows_registry Windows::KeyHelper::ENV_KEY do
		values 'Path' => path.join(';')
	end
	timeoutVars
end

private 
# Notify all processes that the environmental variables have been updated.
def timeoutVars
	# Dosent seem to work... You may need to re-login
	Chef::Log.debug("Telling other processes that the env vars have been updated")
	require 'Win32API'
	sendMessageTimeout = Win32API.new('user32', 'SendMessageTimeout', 'LLLPLLP', 'L') 
	hwnd_broadcast = 0xffff
	wm_settingchange = 0x001A
	smto_abortifhung = 2
	result = 0
	sendMessageTimeout.call(hwnd_broadcast, wm_settingchange, 0, 'Environment', smto_abortifhung, 5000, result)
end