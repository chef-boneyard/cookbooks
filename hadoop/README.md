Description
===========

Installs Apache hadoop and sets up a basic distributed cluster per the
quick start documentation.

Changes
=======

## v0.8.1:

* Current released version

Requirements
============

## Platform:

* Debian/Ubuntu

Tested on Ubuntu 8.10, though should work on most Linux distributions,
see `hadoop[:java_home]`.

## Cookbooks:

* java

Attributes
==========

* `hadoop[:mirror_url]` - Get a mirror from http://www.apache.org/dyn/closer.cgi/hadoop/core/.
* `hadoop[:version]` - Specify the version of hadoop to install.
* `hadoop[:uid]` - Default userid of the hadoop user.
* `hadoop[:gid]` - Default group for the hadoop user.
* `hadoop[:java_home]` - You will probably want to change this to match where Java is installed on your platform.

You may wish to add more attributes for tuning the configuration file templates.

Usage
=====

This cookbook performs the tasks described in the Hadoop Quick
Start[1] to get the software installed. You should copy this to a
site-cookbook and modify the templates to meet your requirements.

Once the recipe is run, the distributed filesystem can be formated
using the script /usr/bin/hadoop.

    sudo -u hadoop /usr/bin/hadoop namenode -format
  
You may need to set up SSH keys for hadoop management commands. 

Note that this is not the 'default' config per se, so using the
start-all.sh script won't start the processes because the config files
live elsewhere. For running various hadoop processes as services, we
suggest runit. A sample 'run' script is provided. The HADOOP_LOG_DIR
in the run script must exist for each process. These could be wrapped
in a define.

* datanode
* jobtracker
* namenode
* tasktracker

[1] http://hadoop.apache.org/core/docs/current/quickstart.html

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2009, Opscode, Inc


you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
