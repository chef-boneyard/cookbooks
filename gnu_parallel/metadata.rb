maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures gnu_parallel"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.99.1"

depends "build-essential"
depends "homebrew" # comes from the community site
