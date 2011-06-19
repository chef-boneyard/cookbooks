#!/bin/bash
for d in `schroot -l | grep -- '-source$'`
do 
  echo '============================================================'
  echo "Updating: $d"
  schroot -q -c $d -u root -- sh -c \
    'apt-get -qq update && apt-get -qy dist-upgrade && apt-get clean'
done
