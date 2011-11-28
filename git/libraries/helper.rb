module Git
  module Helper
    def register_rpmforge_repo
      cookbook_file "/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag" do
        source 'RPM-GPG-KEY-rpmforge-dag'
        mode '0644'
      end

      execute "create-yum-cache" do
        command "yum -q makecache"
        action :nothing
      end

      ruby_block "reload-internal-yum-cache" do
        block do
          Chef::Provider::Package::Yum::YumCache.instance.reload
        end
        action :nothing
      end
      
      %w{ mirrors-rpmforge mirrors-rpmforge-extras mirrors-rpmforge-testing rpmforge.repo }.each do |repo_file|
        cookbook_file "/etc/yum.repos.d/#{repo_file}" do
          source repo_file
          mode "0644"
          notifies :run, resources(:execute => "create-yum-cache"), :immediately
          notifies :create, resources(:ruby_block => "reload-internal-yum-cache"), :immediately
        end
      end

      # Deleting a repo is similar but we have yum scrub it's cache to avoid any issues
      execute "clean-yum-cache" do
        command "yum clean all"
        action :nothing
      end
    end
  end
end

Chef::Recipe.send(:include, Git::Helper)
  