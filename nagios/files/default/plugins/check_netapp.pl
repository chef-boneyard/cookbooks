#!/usr/bin/perl

# Copyright (c) 2006 Dy 4 Systems Inc.
#
# Parameter checks and SNMP v3 based on code by Christoph Kron
#  and S. Ghosh (check_ifstatus)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#
# Report bugs to ken.mckinlay@curtisswright.com, nagiosplug-help@lists.sf.net
#
# 2006.05.01 Version 1.0
#
#
#############################################################
#
# Updated by Ken Nerhood - http://nerhood.wordpress.net/
# 2006.06.19
#
# Added check for Failed Disks
# Corrected perfdata output for CPULOAD and DISKUSED
#    to make it compliant with Nagios Plugin Guiodlines
#
#############################################################
#
# $Id: check_netapp,v 1.2 2006/05/01 13:44:16 root Exp root $

use strict;
use lib "/usr/local/nagios/libexec";
use utils qw($TIMEOUT %ERRORS &print_revision &support);
use Net::SNMP;
use Getopt::Long;
Getopt::Long::Configure('bundling');

my $PROGNAME = 'check_netapp';
my $PROGREVISION = '1.0';

sub print_help ();
sub usage ();
sub process_arguments ();

my ($status,$timeout,$answer,$perfdata,$hostname,$volume);
my ($seclevel,$authproto,$secname,$authpass,$privpass,$snmp_version);
my ($auth,$priv,$session,$error,$response,$snmpoid,$variable);
my ($warning,$critical,$opt_h,$opt_V);
my %snmpresponse;

my $state = 'UNKNOWN';
my $community='public';
my $maxmsgsize = 1472; # Net::SNMP default is 1472
my $port = 161;

my $snmpFailedFanCount = '.1.3.6.1.4.1.789.1.2.4.2';
my $snmpFailPowerSupplyCount = '.1.3.6.1.4.1.789.1.2.4.4';
my $snmpFailedDiskCount = '.1.3.6.1.4.1.789.1.6.4.7';
my $snmpUptime = '.1.3.6.1.2.1.1.3';
my $snmpcpuBusyTimePerCent = '.1.3.6.1.4.1.789.1.2.1.3';
my $snmpenvOverTemperature = '.1.3.6.1.4.1.789.1.2.4.1';
my $snmpnvramBatteryStatus = '.1.3.6.1.4.1.789.1.2.5.1';
my $snmpfilesysvolTable = '.1.3.6.1.4.1.789.1.5.8';
my $snmpfilesysvolTablevolEntryOptions = '.1.3.6.1.4.1.789.1.5.8.1.7';
my $snmpfilesysvolTablevolEntryvolName = '.1.3.6.1.4.1.789.1.5.8.1.2';
my $snmpfilesysdfTabledfEntry = '.1.3.6.1.4.1.789.1.5.4.1';
my $snmpfilesysdfTabledfEntrydfFileSys = '.1.3.6.1.4.1.789.1.5.4.1.2';
my $snmpfilesysdfTabledfEntrydfKBytesTotal = '.1.3.6.1.4.1.789.1.5.4.1.3';
my $snmpfilesysdfTabledfEntrydfKBytesUsed = '.1.3.6.1.4.1.789.1.5.4.1.4';
my $snmpfilesysdfTabledfEntrydfKBytesAvail = '.1.3.6.1.4.1.789.1.5.4.1.5';
my $snmpfilesysdfTabledfEntrydfPercentKBytesCapacity = '.1.3.6.1.4.1.789.1.5.4.1.6';

my %nvramBatteryStatus = (
        1 => 'ok',
        2 => 'partially discharged',
        3 => 'fully discharged',
        4 => 'not present',
        5 => 'near end of life',
        6 => 'at end of life',
        7 => 'unknown',
        8 => 'over charged',
        9 => 'fully charged',
);

# Just in case of problems, let's not hang Nagios
$SIG{'ALRM'} = sub {
        print "ERROR: No snmp response from $hostname (alarm timeout)\n";
        exit $ERRORS{'UNKNOWN'};
};

$status = process_arguments();
if ( $status != 0 ) {
        print_help();
        exit $ERRORS{'OK'};
}

alarm($timeout);

# do the query
if ( ! defined ( $response = $session->get_table($snmpoid) ) ) {
        $answer=$session->error;
        $session->close;
        $state = 'CRITICAL';
        print "$state:$answer for $snmpoid with snmp version $snmp_version\n";
        exit $ERRORS{$state};
}
$session->close;
alarm(0);

foreach my $snmpkey (keys %{$response} ) {
        my ($oid,$key) = ( $snmpkey =~ /(.*)\.(\d+)$/ );
        $snmpresponse{$oid}{$key} = $response->{$snmpkey};
}

if ( $variable eq 'FAN' ) {
        $state = 'OK';
        $state = 'WARNING' if ( ( defined $warning ) && ( $snmpresponse{$snmpFailedFanCount}{0} >= $warning ) );
        $state = 'CRITICAL' if ( ( defined $critical ) && ( $snmpresponse{$snmpFailedFanCount}{0} >= $critical ) );
        $answer = sprintf("Fans failed: %d",$snmpresponse{$snmpFailedFanCount}{0});
        $perfdata = sprintf("failedfans=%d",$snmpresponse{$snmpFailedFanCount}{0});
} elsif ( $variable eq 'UPTIME' ) {
        $state = 'OK';
        $answer = sprintf("System Uptime: %s",$snmpresponse{$snmpUptime}{0});
        $perfdata = sprintf("uptime=%s",$snmpresponse{$snmpUptime}{0});
} elsif ( $variable eq 'FAILEDDISK' ) {
        $state = 'OK';
        $state = 'WARNING' if ( ( defined $warning ) && ( $snmpresponse{$snmpFailedDiskCount}{0} >= $warning ) );
        $state = 'CRITICAL' if ( ( defined $critical ) && ( $snmpresponse{$snmpFailedDiskCount}{0} >= $critical ) );
        $answer = sprintf("Disks failed: %d",$snmpresponse{$snmpFailedDiskCount}{0});
        $perfdata = sprintf("faileddisks=%d",$snmpresponse{$snmpFailedDiskCount}{0});
} elsif ( $variable eq 'PS' ) {
        $state = 'OK';
        $state = 'WARNING' if ( ( defined $warning ) && ( $snmpresponse{$snmpFailPowerSupplyCount}{0} >= $warning ) );
        $state = 'CRITICAL' if ( ( defined $critical ) && ( $snmpresponse{$snmpFailPowerSupplyCount}{0} >= $critical ) );
        $answer = sprintf("Power supplies failed: %d",$snmpresponse{$snmpFailPowerSupplyCount}{0});
        $perfdata = sprintf("failedpowersupplies=%d",$snmpresponse{$snmpFailPowerSupplyCount}{0});
} elsif ( $variable eq 'CPULOAD' ) {
        $state = 'OK';
        $state = 'WARNING' if ( ( defined $warning ) && ( $snmpresponse{$snmpcpuBusyTimePerCent}{0} >= $warning ) );
        $state = 'CRITICAL' if ( ( defined $critical ) && ( $snmpresponse{$snmpcpuBusyTimePerCent}{0} >= $critical ) );
        $answer = sprintf("CPU load: %d%%",$snmpresponse{$snmpcpuBusyTimePerCent}{0});
        #$perfdata = sprintf("cpuload=%d",$snmpresponse{$snmpcpuBusyTimePerCent}{0});
        $perfdata = sprintf("netapp-cpuload=%d%%;%d;%d;0;100",$snmpresponse{$snmpcpuBusyTimePerCent}{0},$warning,$critical);
} elsif ( $variable eq 'TEMP' ) {
        $state = 'OK';
        $state = 'CRITICAL' if ( $snmpresponse{$snmpenvOverTemperature}{0} ==  2 );
        $answer = sprintf ("Over temperature: %s",($snmpresponse{$snmpenvOverTemperature}{0} == 1 ? 'no':'yes'));
        $perfdata = sprintf("overtemperature=%d",$snmpresponse{$snmpenvOverTemperature}{0});
} elsif ( $variable eq 'NVRAM' ) {
        $state = 'OK';
        $state = 'CRITICAL' if (( $snmpresponse{$snmpnvramBatteryStatus}{0} > 1 ) && ( $snmpresponse{$snmpnvramBatteryStatus}{0} < 9 ));
        $answer = sprintf ("NVRAM battery status: %s",$nvramBatteryStatus{$snmpresponse{$snmpnvramBatteryStatus}{0}});
        $perfdata = sprintf("nvrambatterystatus=%d",$snmpresponse{$snmpnvramBatteryStatus}{0});
} elsif ( $variable eq 'SNAPSHOT' ) {
        $state = 'OK';
        $answer = 'Snapshot status:';
        foreach my $key ( keys %{$snmpresponse{$snmpfilesysvolTablevolEntryOptions}} ) {
                if ( defined $volume ) {
                        if ( $snmpresponse{$snmpfilesysvolTablevolEntryvolName}{$key} eq $volume ) {
                                if ( $snmpresponse{$snmpfilesysvolTablevolEntryOptions}{$key} !~ /nosnap=off/ ) {
                                        $state = 'CRITICAL';
                                        $answer = sprintf ("%s %s Snapshots disabled;",
                                                        $answer,
                                                        $snmpresponse{$snmpfilesysvolTablevolEntryvolName}{$key});
                                } else {
                                        $answer = sprintf ("%s volume %s enabled",$answer,$snmpresponse{$snmpfilesysvolTablevolEntryvolName}{$key}) if $state ne 'CRITICAL';
                                }
                                last;
                        }
                } else {
                        if ( $snmpresponse{$snmpfilesysvolTablevolEntryOptions}{$key} !~ /nosnap=off/ ) {
                                $state = 'CRITICAL';
                                $answer = sprintf ("%s %s Snapshots disabled;",$answer,$snmpresponse{$snmpfilesysvolTablevolEntryvolName}{$key});
                        }
                }
        }
        $answer = sprintf ("%s all enabled",$answer) if $answer eq 'Snapshot status:';
        $perfdata = sprintf("");
} elsif ( $variable eq 'DISKUSED' ) {
        $state = 'OK';
        foreach my $key ( keys %{$snmpresponse{$snmpfilesysdfTabledfEntrydfFileSys}} ) {
                if ( defined $volume ) {
                        if ( $snmpresponse{$snmpfilesysdfTabledfEntrydfFileSys}{$key} eq $volume ) {
                                my $volume = $snmpresponse{$snmpfilesysdfTabledfEntrydfFileSys}{$key};
                                my $used = $snmpresponse{$snmpfilesysdfTabledfEntrydfKBytesUsed}{$key};
                                my $total = $snmpresponse{$snmpfilesysdfTabledfEntrydfKBytesTotal}{$key};
                                my $avail = $snmpresponse{$snmpfilesysdfTabledfEntrydfKBytesAvail}{$key};
                                my $percent = $snmpresponse{$snmpfilesysdfTabledfEntrydfPercentKBytesCapacity}{$key};
                                $answer = sprintf("%s - total: %d Kb - used %d Kb (%d%%) - free: %d Kb",$volume,$total,$used,$percent,$avail);
                                $perfdata = sprintf("NetApp %s Used Space=%dKB;%d;%d;0;%d",$volume,$used,$total*$warning/100,$total*$critical/100,$total);
                                $state = 'WARNING' if ( ( defined $warning ) && ( $percent >= $warning ) );
                                $state = 'CRITICAL' if ( ( defined $warning ) && ( $percent >= $critical ) );
                                last;
                        }
                } else {
                        my $volume = $snmpresponse{$snmpfilesysdfTabledfEntrydfFileSys}{$key};
                        my $used = $snmpresponse{$snmpfilesysdfTabledfEntrydfKBytesUsed}{$key};
                        my $total = $snmpresponse{$snmpfilesysdfTabledfEntrydfKBytesTotal}{$key};
                        my $avail = $snmpresponse{$snmpfilesysdfTabledfEntrydfKBytesAvail}{$key};
                        my $percent = $snmpresponse{$snmpfilesysdfTabledfEntrydfPercentKBytesCapacity}{$key};
                        $answer .= sprintf("%s - total: %d Kb - used %d Kb (%d%%) - free: %d Kb\n",$volume,$total,$used,$percent,$avail);
                        $perfdata .= sprintf("NetApp %s Used Space=%dKB;%d;%d;0;%d",$volume,$used,$total*$warning/100,$total*$critical/100,$total);
                        $state = 'WARNING' if ( ( defined $warning ) && ( $percent >= $warning ) && ( $state ne 'CRITICAL') );
                        $state = 'CRITICAL' if ( ( defined $warning ) && ( $percent >= $critical ) );
                }
        }
        if ( ( ! defined $answer ) && ( defined $volume ) ) {
                $state = 'UNKNOWN';
                $answer = "unknown volume: $volume";
                $perfdata = '';
        }
}

print "$variable $state - $answer|$perfdata\n";
exit $ERRORS{$state};

sub usage () {
        print "\nMissing arguments!\n\n";
        print "check_netapp -H <ip_address> -v variable [-w warn_range] [-c crit_range]\n";
        print "             [-C community] [-t timeout] [-p port-number]\n";
        print "             [-P snmp version] [-L seclevel] [-U secname] [-a authproto]\n";
        print "             [-A authpasswd] [-X privpasswd] [-o volume]\n\n";
        support();
        exit $ERRORS{'UNKNOWN'};
}

sub print_help () {
        print "check_netapp plugin for Nagios monitors the status\n";
        print "of a NetApp system\n\n";
        print "Usage:\n";
        print "  -H, --hostname\n\thostname to query (required)\n";
        print "  -C, --community\n\tSNMP read community (defaults to public)\n";
        print "  -t, --timeout\n\tseconds before the plugin tims out (default=$TIMEOUT)\n";
        print "  -p, --port\n\tSNMP port (default 161\n";
        print "  -P, --snmp_version\n\t1 for SNMP v1 (default), 2 for SNMP v2c\n\t\t3 for SNMP v3 (requires -U)\n";
        print "  -L, --seclevel\n\tchoice of \"noAuthNoPriv\", \"authNoPriv\", \"authpriv\"\n";
        print "  -U, --secname\n\tuser name for SNMPv3 context\n";
        print "  -a, --authproto\n\tauthentication protocol (MD5 or SHA1)\n";
        print "  -A, --authpass\n\tauthentication password\n";
        print "  -X, --privpass\n\tprivacy password in hex with 0x prefix generated by snmpkey\n";
        print "  -V, --version\n\tplugin version\n";
        print "  -w, --warning\n\twarning level\n";
        print "  -c, --critical\n\tcritical level\n";
        print "  -v, --variable\n\tvariable to query, can be:\n";
        print "\t\tCPULOAD - CPU load\n";
        print "\t\tDISKUSED - disk space used\n";
        print "\t\tFAILEDDISK - failed disks\n";
        print "\t\tFAN - fail fan state\n";
        print "\t\tNVRAM - nvram battery status\n";
        print "\t\tPS - power supply\n";
        print "\t\tSNAPSHOT - volume snapshot status\n";
        print "\t\tTEMP - over temperature check\n";
        print "\t\tUPTIME - up time\n";
        print "  -o, --volume\n\tvolume to query (defaults to all)\n";
        print "  -h, --help\n\tusage help\n\n";
        print_revision($PROGNAME,"\$Revision: 1.2 $PROGREVISION\$");
}

sub process_arguments () {
        $status = GetOptions (
                'V' => \$opt_V, 'version' => \$opt_V,
                'h' => \$opt_h, 'help' => \$opt_h,
                'P=i' => \$snmp_version, 'snmp_version=i' => \$snmp_version,
                'C=s' => \$community, 'community=s' => \$community,
                'L=s' => \$seclevel, 'seclevel=s' => \$seclevel,
                'a=s' => \$authproto, 'authproto=s' => \$authproto,
                'U=s' => \$secname, 'secname=s' => \$secname,
                'A=s' => \$authpass, 'authpass=s' => \$authpass,
                'X=s' => \$privpass, 'privpass=s' => \$privpass,
                'H=s' => \$hostname, 'hostname=s' => \$hostname,
                't=i' => \$timeout, 'timeout=i' => \$timeout,
                'v=s' => \$variable, 'variable=s' => \$variable,
                'w=i' => \$warning, 'warning=i' => \$warning,
                'c=i' => \$critical, 'critical=i' => \$critical,
                'o=s' => \$volume, 'volume=s' => \$volume,
        );

        if ( $status == 0 ) {
                print_help();
                exit $ERRORS{'OK'};
        }

        if ( $opt_V ) {
                print_revision($PROGNAME,"\$Revision: 1.2 $PROGREVISION\$");
                exit $ERRORS{'OK'};
        }

        if ( ! utils::is_hostname($hostname) ) {
                usage();
                exit $ERRORS{'UNKNOWN'};
        }

        unless ( defined $timeout ) {
                $timeout = $TIMEOUT;
        }

        if ( ! $snmp_version ) {
                $snmp_version = 1;
        }

        if ( $snmp_version =~ /3/ ) {
                if ( defined $seclevel && defined $secname ) {
                        unless ( $seclevel eq ('noAuthNoPriv' || 'authNopriv' || 'authPriv' ) ) {
                                usage();
                                exit $ERRORS{'UNKNOWN'};
                        }

                        if ( $seclevel eq ('authNoPriv' || 'authPriv' ) ) {
                                unless ( $authproto eq ('MD5' || 'SHA1') ) {
                                        usage();
                                        exit $ERRORS{'UNKNOWN'};
                                }
                                if ( ! defined $authpass ) {
                                        usage();
                                        exit $ERRORS{'UNKNOWN'};
                                } else {
                                        if ( $authpass =~ /^0x/ ) {
                                                $auth = "-authkey => $authpass";
                                        } else {
                                                $auth = "-authpassword => $authpass";
                                        }
                                }
                        }

                        if ( $seclevel eq 'authPriv' ) {
                                if ( ! defined $privpass ) {
                                        usage();
                                        exit $ERRORS{'UNKNOWN'};
                                } else {
                                        if ( $privpass -~ /^0x/ ) {
                                                $priv = "-privkey => $privpass";
                                        } else {
                                                $priv = "-privpassword => $privpass";
                                        }
                                }
                        }
                } else {
                        usage();
                        exit $ERRORS{'UNKNOWN'};
                }
        }

        # create the SNMP session
        if ( $snmp_version =~ /[12]/ ) {
                ($session,$error) = Net::SNMP->session(
                                        -hostname => $hostname,
                                        -community => $community,
                                        -port => $port,
                                        -version => $snmp_version,
                );
                if ( ! defined $session ) {
                        $state = 'UNKNOWN';
                        $answer = $error;
                        print "$state:$answer";
                        exit $ERRORS{$state};
                }
        } elsif ( $snmp_version  =~ /3/ ) {
                if ( $seclevel eq 'noAuthNoPriv' ) {
                        ($session,$error) = Net::SNMP->session(
                                                -hostname => $hostname,
                                                -community => $community,
                                                -port => $port,
                                                -version => $snmp_version,
                                                -username => $secname,
                        );
                } elsif ( $seclevel eq 'authNoPriv' ) {
                        ($session,$error) = Net::SNMP->session(
                                                -hostname => $hostname,
                                                -community => $community,
                                                -port => $port,
                                                -version => $snmp_version,
                                                -username => $secname,
                                                -authprotocol => $authproto,
                                                $auth
                        );
                } elsif ( $seclevel eq 'authPriv' ) {
                        ($session,$error) = Net::SNMP->session(
                                                -hostname => $hostname,
                                                -community => $community,
                                                -port => $port,
                                                -version => $snmp_version,
                                                -username => $secname,
                                                -authprotocol => $authproto,
                                                $auth,
                                                $priv
                        );
                }
                if ( ! defined $session ) {
                        $state = 'UNKNOWN';
                        $answer = $error;
                        print "$state:$answer";
                        exit $ERRORS{$state};
                }
        } else {
                $state = 'UNKNOWN';
                print "$state: No support for SNMP v$snmp_version\n";
                exit $ERRORS{$state};
        }

        # check the supported variables
        if ( ! defined $variable ) {
                print_help();
                exit $ERRORS{'UNKNOWN'};
        } else {
                if ( $variable eq 'UPTIME' ) {
                        $snmpoid = $snmpUptime;
                } elsif ( $variable eq 'FAN' ) {
                        $snmpoid = $snmpFailedFanCount;
                } elsif ( $variable eq 'FAILEDDISK' ) {
                        $snmpoid = $snmpFailedDiskCount;
                } elsif ( $variable eq 'PS' ) {
                        $snmpoid = $snmpFailPowerSupplyCount;
                } elsif ( $variable eq 'CPULOAD' ) {
                        $snmpoid = $snmpcpuBusyTimePerCent;
                } elsif ( $variable eq 'TEMP' ) {
                        $snmpoid = $snmpenvOverTemperature;
                } elsif ( $variable eq 'NVRAM' ) {
                        $snmpoid = $snmpnvramBatteryStatus;
                } elsif ( $variable eq 'SNAPSHOT' ) {
                        $snmpoid = $snmpfilesysvolTable;
                } elsif ( $variable eq 'DISKUSED' ) {
                        $snmpoid = $snmpfilesysdfTabledfEntry;
                } else {
                        print_help();
                        exit $ERRORS{'UNKNOWN'};
                }
        }

        return $ERRORS{'OK'};
}
