maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Installs and configures EPEL, ELFF, Dell, and VMware yum repositories."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.8"
recipe "yumrepo::default", "Installs EPEL, ELFF, Dell, and VMware Tools repositories."
recipe "yumrepo::epel", "Installs Fedora Extra Packages for Enterprise Linux (EPEL) repository"
recipe "yumrepo::elff", "Installs Enterprise Linux Fast Forward (ELFF) repository"
recipe "yumrepo::dell", "Installs Dell (OpenManage) repository"
recipe "yumrepo::vmware-tools", "Installs VMware (vmware-tools) repository"

%w{ redhat centos }.each do |os|
  supports os, ">= 5"
end

attribute "repo",
  :display_name => "repo",
  :description => "Hash of repo attributes",
  :type => "hash"

attribute "repo/epel",
  :display_name => "repo/epel",
  :description => "EPEL repo attributes",
  :type => "hash"

attribute "repo/epel/url",
  :display_name => "repo/epel/url",
  :description => "URL for the EPEL repository",
  :required => "optional"

attribute "repo/epel/key",
  :display_name => "repo/epel/key",
  :description => "EPEL GPG signing key",
  :required => "optional"

attribute "repo/epel/enabled",
  :display_name => "repo/epel/enabled",
  :description => "Boolean flag for the EPEL recipe",
  :default => "true",
  :required => "recommended"

attribute "repo/elff",
  :display_name => "repo/elff",
  :description => "ELFF repo attributes",
  :type => "hash"

attribute "repo/elff/url",
  :display_name => "repo/elff/url",
  :description => "URL for the ELFF repository",
  :required => "optional"

attribute "repo/elff/key",
  :display_name => "repo/elff/key",
  :description => "ELFF GPG signing key",
  :required => "optional"

attribute "repo/elff/enabled",
  :display_name => "repo/elff/enabled",
  :description => "Boolean flag for the ELFF repository",
  :default => "true",
  :required => "recommended"

attribute "repo/dell",
  :display_name => "repo/dell",
  :description => "Dell repo attributes",
  :type => "hash"

attribute "repo/dell/community_url",
  :display_name => "repo/dell/community_url",
  :description => "URL for the Dell Community repository",
  :required => "optional"

attribute "repo/dell/firmware_url",
  :display_name => "repo/dell/firmware_url",
  :description => "URL for the Dell Firmware repository",
  :required => "optional"

attribute "repo/dell/omsa_independent_url",
  :display_name => "repo/dell/omsa_independent_url",
  :description => "URL for the Dell OMSA hardware independent repository",
  :required => "optional"

attribute "repo/dell/omsa_specific_url",
  :display_name => "repo/dell/omsa_specific_url",
  :description => "URL for the Dell OMSA hardware specific repository",
  :required => "optional"

attribute "repo/dell/enabled",
  :display_name => "repo/dell/enabled",
  :description => "Boolean for the Dell recipe. This is dynamically determined by hardware platform.",
  :calculated => true

attribute "repo/dell/key",
  :display_name => "repo/dell/key",
  :description => "Dell Community/OMSA GPG Signing Key",
  :required => "optional"

attribute "repo/dell/libsmbios_key",
  :display_name => "repo/dell/libsmbios_key",
  :description => "Dell libsmbios Signing Key",
  :required => "optional"

attribute "repo/dell/install_optional",
  :display_name => "repo/dell/install_optional",
  :description => "Enable Dell optional components by setting to true",
  :required => "recommended"

attribute "repo/vmware",
  :display_name => "repo/vmware",
  :description => "VMware repo attributes",
  :type => "hash"

attribute "repo/vmware/release",
  :display_name => "repo/vmware/release",
  :description => "Used in determining the VMware repo URL",
  :default => "4.1",
  :required => "recommended"

attribute "repo/vmware/url",
  :display_name => "repo/vmware/url",
  :description => "The URL for the VMWare Tools yum recipe.",
  :required => "optional"

attribute "repo/vmware/key",
  :display_name => "repo/vmware/key",
  :description => "VMware GPG Signing Key",
  :required => "optional"

attribute "repo/vmware/enabled",
  :display_name => "repo/vwmare/enabled",
  :description => "The VMware recipe boolean. This is dynamically determined by hardware platform.",
  :calculated => true

attribute "repo/vmware/install_optional",
  :display_name => "repo/vmware/install_optional",
  :description => "Whether or not optional VMware components should be installed.",
  :default => "false",
  :required => "recommended"
