#!/bin/sh
##
# PROVIDE: named
# REQUIRE: SERVERS cleanvar
# KEYWORD: shutdown
#

. /etc/rc.subr

name="<%= @service_name %>"
rcvar=`set_rcvar`

# Set some defaults
<%= @service_name %>_enable=${<%= @service_name %>_enable:-"NO"}

pidfile="/var/run/<%= @service_name %>.pid"
command="/usr/local/bin/bluepill"

start_precmd="${command} load <%= node['bluepill']['conf_dir'] %>/<%= @service_name %>.pill"
start_cmd="${command} ${name} start"

status_cmd="${command} ${name} status"

stop_cmd="${command} ${name} stop"
stop_postcmd="${command} ${name} quit"

load_rc_config ${name}

PATH="${PATH}:/usr/local/bin"

run_rc_command "$1"
