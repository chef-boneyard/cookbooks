maintainer        "Erlang Solutions Ltd."
maintainer_email  "roberto@erlang-solutions.com"
license           "Apache 2.0"
description       "Installs LateX."
version           "0.1.0"

recipe "latex", "Installs LateX"

%w{ ubuntu }.each do |os|
  supports os
end
