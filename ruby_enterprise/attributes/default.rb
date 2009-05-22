ruby_enterprise_edition Mash.new unless attribute?("ruby_enterprise_edition")
ruby_enterprise_edition[:version] = '20090520' unless ruby_enterprise_edition.has_key?(:version)
ruby_enterprise_edition[:install_path] = '/opt/ruby-enterprise' unless ruby_enterprise_edition.has_key?(:install_path)
ruby_enterprise_edition[:url] = "http://github.com/FooBarWidget/rubyenterpriseedition/tarball/release-#{ruby_enterprise_edition[:version]}"
ruby_enterprise_edition[:cow_friendly] = %Q[#{ruby_enterprise_edition[:install_path]}/bin/ruby -e "exit 1 unless GC.respond_to?(:copy_on_write_friendly=)"]