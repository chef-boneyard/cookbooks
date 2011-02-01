Description
===========
This cookbook provides a framework for making single-use, one-shot recipes. By including the `one-shot` recipe in the node's run_list, on the next chef-client run the contents of the `one-shot::one-shot` recipe will be called. This is parameterized as an attribute, so you can change these out by setting the `["one_shot"]["recipe"]` to include different recipes. The file `roles/one-shot.rb` is included so you can simply change the role instead of changing the source directly.

Requirements
============
Written with Chef 0.9.12.

Testing
-------
Tested on Ubuntu 10.04 and 10.10 and tested with Chef 0.9.12.

Attributes
==========
The attribute is set in `attributes/default.rb` and can be set via the `roles/one-shot.rb` Role as well (or you could edit the `default.rb` recipe directly).

* `["one_shot"]["recipe"]` - Default is `one-shot::one-shot`, but may be set to alternate recipes so you may have multiple recipes to use, depending on this attribute.

Roles
=====
one-shot
--------
This role is provided by the `roles/one-shot.rb` for setting the `["one_shot"]["recipe"]` attribute. 

    knife role from file cookbooks/one-shot/roles/one-shot.rb 
    knife node run_list add YOURNODE 'role[one-shot]'


Recipes
=======
Default
-------
The default recipe includes the recipe referred to by the `["one_shot"]["recipe"]` attribute, executing it and then removing the `oneshot` recipe from the node's run_list.

One-Shot
--------
This is an example implementation of a one-shot recipe, it may be copied or modified as necessary. Access to additional recipes are made through the `["one_shot"]["recipe"]` attribute. This recipe is accessed by the `attributes/default.rb`.

Two-Shot
--------
This is an example implementation of a one-shot recipe, it may be copied or modified as necessary. Access to additional recipes are made through the `["one_shot"]["recipe"]` attribute. This recipe is accessed by the `roles/one-shot.rb` Role.

Usage
=====
Add the `one-shot` recipe to a node's run_list. Next chef-client run, that node will execute the recipe designated by the `["one_shot"]["recipe"]` attribute, then remove itself from the node's run_list. The attribute may be set with a Role or directly in the source of the cookbook. You can update the `one-shot` Role with any changes for future runs, then add the `one-shot` recipe back to the run_list again. It could definitely be used within another Role and applied to a series of nodes if needed.

    knife node run_list add YOURNODE 'recipe[one-shot]'

optional

    knife role from file cookbooks/one-shot/roles/one-shot.rb 
    knife node run_list add YOURNODE 'role[one-shot]'


License and Author
==================
Author:: Matt Ray <matt@opscode.com>

Copyright:: 2011 Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
