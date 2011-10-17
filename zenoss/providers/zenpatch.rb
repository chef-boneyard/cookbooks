action :install do
  patch = new_resource.svnpatch
  #check if the patch is already applied
  unless ::File.exists?("#{node[:zenoss][:server][:zenhome]}/Products/r#{patch}.patch")
    Chef::Log.info "Applying patch #{patch} from ticket #{new_resource.ticket}."
    #apply the patch
    execute "#{node[:zenoss][:server][:zenhome]}/bin/zenpatch #{patch}" do
      user "zenoss"
      environment ({'ZENHOME' => node[:zenoss][:server][:zenhome]})
      action :run
    end
  end
end

