# DESCRIPTION:

Installs activemq. On Debian and Ubuntu, it sets up a runit service.

# REQUIREMENTS:

Platform: Debian or Ubuntu to have a runit service set up automatically. Other platforms may work but have not been tested.

Opscode cookbooks:

* java
* runit

# ATTRIBUTES:

* `activemq[:mirror]` - download URL up to the activemq/apache-activemq directory.
* `activemq[:version]` - version to install.
* `activemq[:deploy]` - directory to deploy to (/opt by default)

# USAGE:

Include the default recipe on systems where you want to run activemq.

This cookbook doesn't use any custom configuration for activemq.

# LICENSE AND AUTHOR:

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2009-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
