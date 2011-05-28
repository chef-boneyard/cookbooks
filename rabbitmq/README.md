Description
===========
This is a cookbook for managing RabbitMQ with Chef.  It has sane defaults, but can also be configured via attributes.  

Recipes
=======
default
-------
Installs `rabbitmq-server` from RabbitMQ.com's APT repository. The distribution-provided version was quite old and newer features were needed.

cluster
-------
Configures nodes to be members of a RabbitMQ cluster, but does not actually join them.

Limitations
===========
It is quite useful as is, but has several areas for improvement:

1) While it can create cluster configuration files, it does not currently do the dance to join the cluster members to each other.

2) There should be LWRPs for manipulating vhosts, users and the `rabbitmq-server` service. Essentially everything you'd do with rabbitmqctl.

The rabbitmq::chef recipe was only used for the chef-server cookbook and has been moved to chef-server::rabitmq.

License and Author
==================
Author:: Benjamin Black <b@b3k.us>
Author:: Daniel DeLeo <dan@kallistec.com>
Author:: Matt Ray <matt@opscode.com>

Copyright:: 2009-2011 Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
