maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures Microsoft Internet Information Services 7.5"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.2"
supports         "windows"
depends          "windows", ">= 1.2.6"
depends          "webpi", ">= 1.0.0"
