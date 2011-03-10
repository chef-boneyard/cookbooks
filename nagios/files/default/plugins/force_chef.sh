#! /bin/sh

pkill chef-client
sleep 0.5
pkill -9 chef-client
if [ -x /usr/bin/chef-client ]; then
	CHEF_CLIENT=/usr/bin/chef-client
else
	CHEF_CLIENT=/var/lib/gems/1.8/bin/chef-client
fi
if [ -x /etc/init.d/chef-client ]; then
	/etc/init.d/chef-client start
else
	start-stop-daemon --start -x $CHEF_CLIENT -b
	RET=$?
fi
pgrep chef-client >/dev/null || exit 2
exit 0
