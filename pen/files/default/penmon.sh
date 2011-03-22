#!/bin/sh
#set -x
#
# Skript zum Ueberwachen eines Pen Loadbalancers
#
# Parameter ist das Configfile fuer den pen Daemon
#

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
DAEMON=`which pen`
CFFILE="$1"

test ! -x "$DAEMON" && echo "Error: Binary missing" && exit 0
test ! -f "$CFFILE" && echo "Error: Config missing" && exit 0

RUN=yes
while [ $RUN = "yes" ]
do
    PARAM=`cat $CFFILE`
    $DAEMON -f $PARAM &
    PID="$!"
    wait $PID
done
