maintainer        "Opscode, Inc. - Erlang Solutions Ltd."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs Erlang from package (optionally with GUI tools) or from source code."
version           "0.8.3"

depends "build-essential"
depends "openssl"

recipe "erlang", "Installs erlang (default from package)"
recipe "erlang::package", "Installs erlang from package"
recipe "erlang::source", "Installs erlang from source"

%w{ ubuntu debian }.each do |os|
  supports os
end
