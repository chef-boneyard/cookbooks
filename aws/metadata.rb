maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "LWRPs for managing AWS resources"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.99.0"
recipe            "aws", "Installs the right_aws gem during compile time"
