include recipe['yum::vmware']

if node['virtualization']['system'] 
	package 'vmware-tools' do
		action :install
	end
end

