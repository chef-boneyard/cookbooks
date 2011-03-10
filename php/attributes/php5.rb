default[:php][:session][:save_handler]      = "memcache"
default[:php][:session][:use_cookies]       = 0
default[:php][:session][:use_only_cookies]  = 0
default[:php][:session][:auto_start]        = 0
default[:php][:precision]                   = 14
default[:php][:output_buffering]            = 4096 # "Off" may be better sometimes
default[:php][:zlib_output_compression]     = "Off"
default[:php][:expose_php]                  = "Off" # should php expose itself in server tokens
default[:php][:max_execution_time]          = 15
default[:php][:max_input_time]              = 60
default[:php][:memory_limit]                = "128M"
default[:php][:display_errors]              = "Off"
default[:php][:error_reporting]             = "E_ERROR"
default[:php][:display_startup_errors]      = "Off"
default[:php][:ignore_repeated_errors]      = "On"
default[:php][:error_log]                   = "syslog"
default[:php][:upload_tmp_dir]              = "/tmp"
default[:php][:upload_max_filesize]         = "2M"
default[:php][:date_timzone]                = "Europe/London"
default[:php][:define_syslog_variables]     = "Off"

default[:php][:mysql][:allow_persistent]    = "On"
default[:php][:mysql][:max_persistent]      = -1
default[:php][:mysql][:max_links]           = -1
default[:php][:mysql][:connect_timeout]     = 15
default[:php][:mysql][:cache_size]          = 2000

default[:php][:mysqli][:max_persistent]     = -1
default[:php][:mysqli][:allow_persistent]   = "On"
default[:php][:mysqli][:max_links]          = -1
default[:php][:mysqli][:cache_size]         = 2000

# default[:php][:sendmail_path]               = "sendmail -t -i"
