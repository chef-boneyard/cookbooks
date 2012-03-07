## v1.1.2:

* [COOK-996] - apache2::mod_php5 can cause PHP and module API mismatches
* [COOK-1083] - return string for v_f_p and use correct value for
  default

## v1.1.0:

* [COOK-861] - Add `mod_perl` and apreq2
* [COOK-941] - fix `mod_auth_openid` on FreeBSD
* [COOK-1021] - add a commented-out LoadModule directive to keep apxs happy
* [COOK-1022] - consistency for icondir attribute
* [COOK-1023] - fix platform test for attributes
* [COOK-1024] - fix a2enmod script so it runs cleanly on !bash
* [COOK-1026] - fix `error_log` location on FreeBSD

## v1.0.8:

* COOK-548 - directory resource doesn't have backup parameter

## v1.0.6:

* COOK-915 - update to `mod_auth_openid` version 0.6, see __Recipes/mod_auth_openid__ below.
* COOK-548 - Add support for FreeBSD.

## v1.0.4:

* COOK-859 - don't hardcode module paths

## v1.0.2

* Tickets resolved in this release: COOK-788, COOK-782, COOK-780

## v1.0.0

* Red Hat family support is greatly improved, all recipes except `god_monitor` converge.
* Recipe `mod_auth_openid` now works on RHEL family distros
* Recipe `mod_php5` will now remove config from package on RHEL family so it doesn't conflict with the cookbook's.
* Added `php5.conf.erb` template for `mod_php5` recipe.
* Create the run state directory for `mod_fcgid` to prevent a startup error on RHEL version 6.
* New attribute `node['apache']['lib_dir']` to handle lib vs lib64 on RHEL family distributions.
* New attribute `node['apache']['group']`.
* Scientific Linux support added.
* Use a file resource instead of the generate-module-list executed perl script on RHEL family.
* "default" site can now be disabled.
* web_app now has an "enable" parameter.
* Support for dav_fs apache module.
* Tickets resolved in this release: COOK-754, COOK-753, COOK-665, COOK-624, COOK-579, COOK-519, COOK-518
* Fix node references in template for a2dissite
* Use proper user and group attributes on files and templates.
* Replace the anemic README.rdoc with this new and improved superpowered README.md :).
