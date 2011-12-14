#!/bin/bash
#-------------------------------------------------------------------------------------------------------
#	check_services
#					version:	0.01.1
#					modified: 	-
#					created: 	06/08/09
#					creator:	lucol@gronck.net
#-------------------------------------------------------------------------------------------------------
#	Needs
#					. 
#
#-------------------------------------------------------------------------------------------------------
#	History
#					0.01 - 06/08/09
#						. add semaphore control
#-------------------------------------------------------------------------------------------------------


## init
#
	PROGNAME=`basename $0`
	PROGPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
	if [ "$0" == "./$PROGNAME" ]; then
		PROGPATH="$(pwd)/${PROGPATH//./}"
	fi

	. $PROGPATH/utils.sh

	exitstatus=$STATE_UNKNOWN


## check update sem
#
	if [ -f "$PROGPATH/check_plugins_update.sem" ]; then
		echo "$PROGNAME: update running exit!"
		exit $STATE_UNKNOWN
	fi

## subs
#
	vers () {
		insvers=$(cat ${PROGPATH}$PROGNAME 	| grep '^#' | grep version: 	| tr -d '\t' | sed 's|.*version:||')
		echo "$PROGNAME - $insvers"
		}

	usage() {
		echo ""
		vers
		echo ""
		echo "Usage: $PROGNAME -p egrep_patern_to_find_in_procs[,...]"
		echo "Usage: $PROGNAME -h (help)"
		echo "Usage: $PROGNAME -V (version)"
		echo ""
		}


## args check
#
	if [ $# -lt 1 ]; then
		usage
		exit $STATE_UNKNOWN
	fi
	
	# Grab the command line arguments
	
	exitstatus=$STATE_WARNING #default
	while test -n "$1"; do
		case "$1" in
			-h)
				usage
				exit $STATE_OK
				;;
			-V)
				vers
				exit $STATE_OK
				;;
			-p)
				p_datas=($(echo $2 | sed 's|,| |g'))
				shift
				;;
			*)
				echo "Unknown argument: $1"
				usage
				exit $STATE_UNKNOWN
				;;
		esac
		shift
	done

	# echo ${w_datas[*]}
	# echo ${c_datas[*]}

## check
#
	exitstatus=$STATE_OK
	
	res=
	for patern in ${p_datas[*]}
	do
	
		amt=$(ps aax | egrep "$patern" | grep -v egrep | grep -v "$PROGNAME" | wc -l | sed 's| ||g')
		str="$patern: $amt"
		if [ $amt -lt 1 ]; then
			str="*** $patern: Nok ***"
			exitstatus=$STATE_CRITICAL
		fi
		res="$res  $str"
	
	done
	echo "$res"
	
	exit $exitstatus
