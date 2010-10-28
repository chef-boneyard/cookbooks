maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Installs and configures EPEL, ELFF, Dell, and VMware yum repositories."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.6"
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
  :display_name => "EPEL repo",
  :description => "EPEL repo attributes",
  :type => "hash"

attribute "repo/epel/url",
  :display_name => "EPEL URL",
  :description => "URL for the EPEL repository",
  :required => "optional"

attribute "repo/epel/key",
  :display_name => "EPEL key",
  :description => "EPEL GPG signing key",
  :required => "optional"

attribute "repo/epel/enabled",
  :display_name => "EPEL enable",
  :description => "Boolean flag for the EPEL recipe",
  :default => "true",
  :required => "recommended"

attribute "repo/elff",
  :display_name => "ELFF repo",
  :description => "ELFF repo attributes",
  :type => "hash"

attribute "repo/elff/url",
  :display_name => "ELFF URL",
  :description => "URL for the ELFF repository",
  :required => "optional"

attribute "repo/elff/key",
  :display_name => "ELFF key",
  :description => "ELFF GPG signing key",
  :required => "optional"

attribute "repo/elff/enabled",
  :display_name => "ELFF enable",
  :description => "Boolean flag for the ELFF repository",
  :default => "true",
  :required => "recommended"

attribute "repo/dell",
  :display_name => "Dell repo",
  :description => "Dell repo attributes",
  :type => "hash"

attribute "repo/dell/community_url",
  :display_name => "Dell Community repo URL",
  :description => "URL for the Dell Community repository",
  :required => "optional"

attribute "repo/dell/firmware_url",
  :display_name => "Dell Firmware repo URL",
  :description => "URL for the Dell Firmware repository",
  :required => "optional"

attribute "repo/dell/omsa_independent_url",
  :display_name => "Dell OMSA indep repo URL",
  :description => "URL for the Dell OMSA hardware independent repository",
  :required => "optional"

attribute "repo/dell/omsa_specific_url",
  :display_name => "Dell OMSA specific repo URL",
  :description => "URL for the Dell OMSA hardware specific repository",
  :required => "optional"

attribute "repo/dell/enabled",
  :display_name => "Dell repo boolean",
  :description => "Boolean for the Dell recipe. This is dynamically determined by hardware platform.",
  :calculated => true

attribute "repo/dell/key",
  :display_name => "Dell Key",
  :description => "Dell Community/OMSA GPG Signing Key",
  :required => "optional"

attribute "repo/dell/libsmbios_key",
  :display_name => "libsmbios Key",
  :description => "Dell libsmbios Signing Key",
  :required => "optional"

attribute "repo/dell/install_optional",
  :display_name => "Boolean for optional components.",
  :description => "Enable Dell optional components by setting to true",
  :required => "recommended"

attribute "repo/vmware",
  :display_name => "VMware repo",
  :description => "VMware repo attributes",
  :type => "hash"

attribute "repo/vmware/release",
  :display_name => "VMware ESX release version",
  :description => "Used in determining the VMware repo URL",
  :default => "4.1",
  :required => "recommended"

attribute "repo/vmware/url",
  :display_name => "VMware Tools Repository URL",
  :description => "The URL for the VMWare Tools yum recipe.",
  :required => "optional"

attribute "repo/vmware/key",
  :display_name => "VMware Key",
  :description => "VMware GPG Signing Key",
  :required => "optional"

attribute "repo/vmware/enabled",
  :display_name => "VMware repo boolean",
  :description => "The VMware recipe boolean. This is dynamically determined by hardware platform.",
  :calculated => true

attribute "repo/vmware/install_optional",
  :display_name => "VMware optional components",
  :description => "Whether or not optional VMware components should be installed.",
  :default => "false",
  :required => "recommended"
