maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Installs and configures EPEL, ELFF, Dell, and VMware yum repositories."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.10.1"
recipe "yumrepo::default", "Installs EPEL, ELFF, Dell, and VMware Tools repositories."
recipe "yumrepo::epel", "Installs Fedora Extra Packages for Enterprise Linux (EPEL) repository"
recipe "yumrepo::elff", "Installs Enterprise Linux Fast Forward (ELFF) repository"
recipe "yumrepo::dell", "Installs Dell (OpenManage) repository"
recipe "yumrepo::vmware-tools", "Installs VMware (vmware-tools) repository"
recipe "yumrepo::annvix", "Annvix repository for packages usable with Red Hat Enterprise Linux and CentOS."
recipe "yumrepo::postgresql9", "PostgreSQL 9.0 RPMs from pgrpms.org"
recipe "yumrepo::zenoss", "YUM repo for ZenOss stable"

%w{ redhat centos }.each do |os|
  supports os, ">= 5"
end

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

attribute "repo/dell/install_optional",
  :display_name => "repo/dell/install_optional",
  :description => "Enable Dell optional components by setting to true",
  :required => "recommended"

attribute "repo/vmware/release",
  :display_name => "repo/vmware/release",
  :description => "Used in determining the VMware repo URL",
  :default => "4.1",
  :required => "recommended"

attribute "repo/vmware/url",
  :display_name => "repo/vmware/url",
  :description => "The URL for the VMWare Tools yum recipe.",
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
