This is the current, previous and future development milestones and contains the features backlog.

0.1
===
mostly documentation
zenoss::client depends on openssh

0.2
===
zenoss::server installs itself via apt

0.3
===
$ZENHOME is an attribute
zenoss_zenpack LWRP with :install :remove
install linux monitor ZenPack
zenoss_zendmd LWRP with :run
sets the admin password via attribute

0.4
===
checks for already installed zenpacks, apt repos
hash of installed_zenpacks as key->package, value->version: server attribute
single attributes/default.rb file since there's no differentiation
zenoss::server generate SSH keys for the zenoss user and writes it to an attribute
zenoss::client get the SSH keys via the attribute writes it to /home/zenoss/.ssh/authorized_keys

0.5
===
LWRP for 3.0.3 zenpatches (http://dev.zenoss.com/trac/report/6 is the basis)
Roles will be used for Device Classes, Groups and Locations
Recipes will be used for Systems
server will insert devices
devices get added to zenoss::server that implement the zenoss::client recipe
zenoss::clients will have attributes for any particular properties they need set

0.6
===
check search in client.rb to negate use of [0]
in metadata.rb, you should add recipes http://wiki.opscode.com/display/chef/Metadata#Metadata-recipe
move restart to server.rb for zenpack installation
skips new install wizard
create a random admin password (in mysql cookbook)
user manage_home true
document use of external IP addresses
include the search zenpack
zendmd use debug for commands
load_current_resource for zenpack installation
zenoss::client server move self to /Server/SSH/Linux instead of /Server/Linux
monitoring server should have a default role ('monitoring' is used in Nagios)
document enabling ping through the security group in EC2
add additional users via zendmd (extend zendmd LWRP for user-management)
use the "sysadmins" data bag to populate the users
provide example data_bag files for loading users

0.6.2
===
add support for Zenoss 3.1.0

0.7 *CURRENT*
===
yum cookbook dependency
CentOS 5.6 and Scientific Linux 5.5 support via yum_repository LWRP


0.8
mysql::server dependency for rpm installs
notify zendmd at end of run to load everything (before zenbatchload)
optimize creation of device classes, systems and groups by using hashes instead of individual calls or by comparing against previous values
diff previous zenbatchload run
clients request specific ZenPacks (or Device Class roles?)
AWS ZenPack and Role for Device Class


BACKLOG:
Chef Client ZenPack
configure mail settings
sysadmin_email - default notification email.
sysadmin_sms_email - default notification sms.
encrypted data bags for storing passwords
nodes not in "production" environment could map to other production states ("preproduction", "decommissioned", etc.")
make zenoss server receive syslog
install nagios plugins
templates for the configuration? (http://community.zenoss.org/docs/DOC-8511)
other configuration/tuning options exposed as attributes?
configure zope.conf
distributed collectors
disable some of the daemons that are unused
other types of things to monitor could be added by search (ie. apache::server or mysql::server)
anything useful for the zLink?
LDAP logins
snmpd cookbook
ERB template for monitoring via Zenoss that exposes the basics in a secure fashion
change default community string to "cookbook"

CHEF SERVER ZENPACK
list of managed nodes
link back to Chef server/platform in zLink
zlinked and any stats available
any reports
AMQP message queue event listener
anything worth pushing to the Chef Server with Knife?
is there any additional monitoring data available from Chef Server worth exposing

