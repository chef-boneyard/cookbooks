## v1.1.4:

* [COOK-1062] - Databases: Postgres exists should close connection

## v1.1.2:

* [COOK-975] - Change arg='DEFAULT' to arg=nil, :default => 'DEFAULT'
* [COOK-964] - Add parentheses around connection hash in example

## v1.1.0

* [COOK-716] - providers for PostgreSQL

## v1.0.0

* [COOK-683] - added `database` and `database_user` resources
* [COOK-684] - MySQL providers
* [COOK-685] - SQL Server providers
* refactored - `database::master` and `database::snapshot` recipes to leverage new resources

## v0.99.1

* Use Chef 0.10's `node.chef_environment` instead of `node['app_environment']`.
