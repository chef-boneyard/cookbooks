#!/usr/bin/env perl

# 
# mysql-slave-check.pl
# 
# Nagios script for checking the replication 
# status of a slave MySQL server. 
# 
# Michal Ludvig <michal@logix.cz> (c) 2006
#               http://www.logix.cz/michal
# 
# Run with --help to get some hints about usage or
# look at subroutine usage() near the end of this file.
# 

use strict;
use DBI;
use Getopt::Long;

my $db_host = "localhost";
my $db_port = "3306";
my $db_sock = "";
my $db_user = "";
my $db_pass = "";
my $db_name = "";
my $warn = 300;
my $crit = 900;

# Nagios codes
my %ERRORS=('OK'=>0, 'WARNING'=>1, 'CRITICAL'=>2, 'UNKNOWN'=>3, 'DEPENDENT'=>4);

GetOptions(
	'host=s' => \$db_host,
	'port=i' => \$db_port,
	'user=s' => \$db_user,
	'password=s' => \$db_pass,
	'socket=s' => \$db_sock,
  'warn=i' => \$warn,
  'crit=i' => \$crit,
	'name|dbname|database=s' => \$db_name,
	'help' => sub { &usage(); },
);

&nagios_return("UNKNOWN", "Either set --host/--port or --sock, not both!") if (($db_port || $db_host ne "localhost") && $db_sock);

my $db_conn_string = "DBI:mysql:";
$db_conn_string .= "database=$db_name;";
$db_conn_string .= "host=$db_host;";
$db_conn_string .= "port=$db_port;";
$db_conn_string .= "mysql_socket=$db_sock;";

## Connect to the database.
my $dbh = DBI->connect($db_conn_string, $db_user, $db_pass,
                       {'RaiseError' => 0, 'PrintError' => 0});

&nagios_return("UNKNOWN", "Connect failed: $DBI::errstr") if (!$dbh);

## Now retrieve data from the table.
my $sth = $dbh->prepare("SHOW SLAVE STATUS");
&nagios_return("UNKNOWN", "[1] $DBI::errstr") if (!$sth);

$sth->execute();

&nagios_return("UNKNOWN", "[2] $DBI::errstr") if ($sth->err);
&nagios_return("CRITICAL", "Query returned ".scalar($sth->rows)." rows") if (scalar($sth->rows) < 1);

## Query should return one row only
my $result = $sth->fetchrow_hashref();

&nagios_return("UNKNOWN", "[3] $DBI::errstr") if (!$result);

## Print all results? No thanks.
# while (my ($key, $val) = each %$result) {
# 	print "$key = $val\n";
# }

## Check the returned values
&nagios_return("CRITICAL", "Slave_IO_Running=".$result->{'Slave_IO_Running'}."!") if ($result->{'Slave_IO_Running'} ne "Yes");
&nagios_return("CRITICAL", "Slave_SQL_Running=".$result->{'Slave_SQL_Running'}."!") if ($result->{'Slave_SQL_Running'} ne "Yes");
&nagios_return("CRITICAL", "Seconds_Behind_Master=".$result->{'Seconds_Behind_Master'}) if ($result->{'Seconds_Behind_Master'} > $crit);
&nagios_return("WARNING",  "Seconds_Behind_Master=".$result->{'Seconds_Behind_Master'}) if ($result->{'Seconds_Behind_Master'} > $warn);
$sth->finish();

# Disconnect from the database.
$dbh->disconnect();

&nagios_return("OK", "$result->{'Slave_IO_State'}, replicating host $result->{'Master_Host'}:$result->{'Master_Port'}");
exit 0;

### 

sub nagios_return($$) {
	my ($ret, $message) = @_;
	my ($retval, $retstr);
	if (defined($ERRORS{$ret})) {
		$retval = $ERRORS{$ret};
		$retstr = $ret;
	} else {
		$retstr = 'UNKNOWN';
		$retval = $ERRORS{$retstr};
		$message = "WTF is return code '$ret'??? ($message)";
	}
	$message = "$retstr - $message\n";
	print $message;
	exit $retval;
}

sub usage() {
	print("
Nagios script for checking the replication status of a
slave MySQL server. 

Michal Ludvig <michal\@logix.cz> (c) 2006
              http://www.logix.cz/michal

  --host=<host>	  Hostname or IP address to connect to.
  --port=<port>   TCP port where the server listens
  --socket=</path/to/mysqld.sock>
                  Path and filename of the Unix socket

  --user=<user>
  --password=<password>
                  Username and password of a user with
		  REPLICATION CLIENT privileges. See
		  below for details.

  --dbname=<dbname>
                  Name od database to open on connect.
		  Should normaly not be needed.
	
	--warn=<seconds> Warning threshold in seconds for Seconds_behind_master variable

	--crit=<seconds> Critical threshold in seconds for Seconds_behind_master variable

  --help          Guess what ;-)

The script needs to connect as a MySQL user (say 'monitor') 
with privilege REPLICATION CLIENT. Use this GRANT
command to create such a user:

mysql> GRANT REPLICATION CLIENT ON *.* \\
	TO monitor\@localhost IDENTIFIED BY 'SecretPassword';

To access the script over SNMP put the following line
into your /etc/snmpd.conf:

extend mysql-slave /path/to/mysql-slave-check.pl \\
	--user monitor --pass 'SecretPassword';

To check retrieve the status over SNMP use check_snmp_extend.sh
from http://www.logix.cz/michal/devel/nagios



");
	exit 0;

}
