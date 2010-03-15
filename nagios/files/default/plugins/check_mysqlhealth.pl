#!/usr/bin/perl
# --
# Check the health of a mysql server.
#
# @author Peter Romianowski / optivo GmbH
# @version 1.0 2005-08-31
# --
use Getopt::Long;
use DBI;

# --
# Print out the usage message
# --
sub usage {
    print "usage: check_mysqlhealth.pl -H <host> -u <user> -p <password> \n";
    print "       Optional parameters:\n";
    print "       --port <port> \n";
    print "       --Cc <critical number of connections> \n";
    print "       --Wc <warning number of connections> \n";
    print "       --Ca <critical number of ACTIVE connections> \n";
    print "       --Wa <warning number of ACTIVE connections> \n";
    print "       --sql <an sql statement that will be executed and that must return at least one row>\n";
}

$|=1;

# --
# Parse arguments and read Configuration
# --
my ($host, $user, $password, $port, $criticalConnections, $warningConnections, $criticalActive, $warningActive, $sql);
GetOptions (
    'host=s' => \$host,
    'H=s' => \$host,
    'user=s' => \$user,
    'u=s' => \$user,
    'password=s' => \$password,
    'p:s' => \$password,
    'port=i' => \$port,
    'Cc=i' => \$criticalConnections,
    'Wc=i' => \$warningConnections,
    'Ca=i' => \$criticalActive,
    'Wa=i' => \$warningActive,
    'sql=s'=> \$sql
);

if (!$host || !$user) {
    usage();
    exit(1);
}

if (!$port) {
    $port = 3306;
}

my $totalTime = time();

# --
# Establish connection
# --
my $state = "OK";
my $dbh;
eval {
    $dbh = DBI->connect("DBI:mysql:host=$host;port=$port", $user, $password, {'RaiseError' => 1});
};

if ($@) {
    my $status = $@;
    print 'CRITICAL: Connect failed with reason ' . $status . "\n";
    exit 2;
}

# --
# Count active statements
# --
my $connections = 0;
my $active = 0;

eval {
    my $sth = $dbh->prepare("SHOW PROCESSLIST");
    $sth->execute();
    my $row;
    do {
        $row = $sth->fetchrow_hashref();
        if ($row) {
            if (!($row->{'Command'} =~ /Sleep/)) {
                $active++;
            }
            $connections++;
        }
        
    } while ($row);
};

if ($@) {
    my $status = $@;
    print 'CRITICAL: Error executing SHOW PROCESSLIST, reason ' . $status . "\n";
    exit 2;
}

# --
# Execute optional sql statement if given
# --
$sqlResult;
if ($sql) {
    eval {
        my $sth = $dbh->prepare($sql);
        $sth->execute();
        my @row = $sth->fetchrow();
        if (@row) {
            $sqlResult = join('|', @row);
        }
    };
    
    if ($@) {
        my $status = $@;
        print 'CRITICAL: Error executing statement "' . $sql . '", reason ' . $status . "\n";
        exit 2;
    }
    
}

# --
# Cleanup resources
# --
$dbh->disconnect();    

# --
# Check
# --
my $statusString = "$connections connections, $active active connections";
if ($criticalConnections && $criticalConnections < $connections) {
    print "CRITICAL: Number of connections higher than $criticalConnections ($statusString)\n";
    exit 2;
}
if ($criticalActive && $criticalActive < $active) {
    print "CRITICAL: Number of ACTIVE connections higher than $criticalActive ($statusString)\n";
    exit 2;
}
if ($warningConnections && $warningConnections < $connections) {
    print "WARNING: Number of connections higher than $warningConnections ($statusString)\n";
    exit 1;
}
if ($warningActive && $warningActive < $active) {
    print "WARNING: Number of ACTIVE connections higher than $warningActive ($statusString)\n";
    exit 1;
}
if ($sql) {
    if ($sqlResult) {
        $statusString = "Statement '$sql' returned: '$sqlResult', $statusString";
    } else {
        print "CRITICAL: Execution of statement '$sql' did not produce any result ($statusString)\n";
        exit 2;
    }
}

print "OK: $statusString\n";
exit 0;

    
