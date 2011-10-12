include_recipe  'yum::vmware'

if node['virtualization']['system'] 
	package 'vmware-tools-nox' do
		action :install
	end
end

