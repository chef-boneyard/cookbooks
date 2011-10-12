arch = node['kernel']['machine']
major = node['platform_version'].to_i
esx_version = node['esx_version']

yum_repository "vmware" do
	name "vmware_repo"
	url "http://packages.vmware.com/tools/esx/#{esx_version}/rhel#{major}/#{arch}" 
	key "VMWARE-PACKAGING-GPG-KEY"
	action :add
end

yum_key 'VMWARE-PACKAGING-GPG-KEY' do
	url 'http://packages.vmware.com/tools/VMWARE-PACKAGING-GPG-KEY.pub'
	action :add
end
