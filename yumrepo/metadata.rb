maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Recipes install and configure several popular RHEL and CentOS 5.x repositories"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.2"

%w{ redhat centos }.each do |os|
  supports os, ">= 5"
end

attribute "repo",
  :display_name => "repo",
  :description => "Hash of repo attributes",
  :type => "hash"

# EPEL (default)
attribute "repo/epel/url",
  :display_name => "EPEL URL",
  :description => "URL for the EPEL repository",
  :default => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch"

attribute "repo/epel/enabled",
  :display_name => "EPEL enable",
  :description => "Boolean flag for the EPEL repository",
  :default => "true"

attribute "repo/epel/key",
  :display_name => "EPEL key",
  :description => "EPEL GPG signing key",
  :default => "RPM-GPG-KEY-EPEL" 

# ELFF
attribute "repo/elff/url",
  :display_name => "ELFF URL",
  :description => "URL for the ELFF repository",
  :default => "http://download.elff.bravenet.com/5/$basearch"

attribute "repo/elff/enabled",
  :display_name => "ELFF enable",
  :description => "Boolean flag for the ELFF repository",
  :default => "true"

attribute "repo/elff/key",
  :display_name => "ELFF key",
  :description => "ELFF GPG signing key",
  :default => "RPM-GPG-KEY-ELFF"

# Dell
attribute "repo/dellcommunity/url",
  :display_name => "Dell Community repo URL",
  :description => "URL for the Dell Community repository",
  :default => "http://linux.dell.com/repo/community//mirrors.cgi?osname=el$releasever\&basearch=$basearch"

attribute "repo/dellcommunity/enabled",
  :display_name => "Dell Community repo boolean",
  :description => "The Dell Community repository boolean. This is dynamically determined by hardware platform.",
  :calculated => true

attribute "repo/dellfirmware/url",
  :display_name => "Dell Firmware repo URL",
  :description => "URL for the Dell Firmware repository",
  :default => "http://linux.dell.com/repo/firmware/mirrors.pl?dellsysidpluginver=$dellsysidpluginver" 

attribute "repo/dellfirmware/enabled",
  :display_name => "Dell Firmware repo boolean",
  :description => "The Dell Firmware repository boolean. This is dynamically determined by hardware platform.",
  :calculated => true

attribute "repo/dellomsa/indep/url",
  :display_name => "Dell OMSA indep repo URL",
  :description => "URL for the Dell OMSA hardware independent repository",
  :default => "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver"

attribute "repo/dellomsa/specific/url",
  :display_name => "Dell OMSA specific repo URL",
  :description => "URL for the Dell OMSA hardware specific repository",
  :default => "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver"

attribute "repo/dellomsa/enabled",
  :display_name => "Dell OMSA repo boolean",
  :description => "Boolean for the Dell OMSA repositories. This is dynamically determined by hardware platform.",
  :calculated => true

# VMware
attribute "repo/vmware/release",
  :display_name => "VMware ESX release version",
  :description => "Used in determining the VMware repo URL",
  :default => "4.1"

attribute "repo/vmware/url",
  :display_name => "VMware Tools Repository URL",
  :description => "The URL for the VMWare Tools yum repository.  You can override the whole url or just override[:repo][:vmware][:release]",
  :default => "http://packages.vmware.com/tools/esx/\#{repo[:vmware][:release]}/rhel5/$basearch"

attribute "repo/vmware/key",
  :display_name => "VMware Key",
  :description => "VMware GPG Signing Key",
  :default => "VMWARE-PACKAGING-GPG-KEY"

attribute "repo/vmware/enabled",
  :display_name => "VMware repo boolean",
  :description => "The VMware repository boolean. This is dynamically determined by hardware platform.",
  :calculated => true
