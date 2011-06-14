maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures PowerShell 2.0 on the Windows platform"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.1"

recipe "powershell::default", "Installs and configures PowerShell 2.0"
