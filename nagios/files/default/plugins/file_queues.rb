#!/usr/bin/env ruby
#
# Nagios check
# Check 'work queue' directories by file count or age of oldest file
#

require 'rubygems'
require 'choice'

EXIT_OK = 0
EXIT_WARNING = 1
EXIT_CRITICAL = 2
EXIT_UNKNOWN = 3

Choice.options do
  header ''
  header 'Specific options:'

  option :warn do
    short '-w'
    long '--warning=VALUE'
    desc 'Warning threshold'
    cast Integer
  end

  option :crit do
    short '-c'
    long '--critical=VALUE'
    desc 'Critical threshold'
    cast Integer
  end

  option :path do
    short '-p'
    long '--path=VALUE'
    desc 'Path to directory'
  end

  option :type do
    short '-t'
    long '--type=VALUE'
    desc 'Either "age" (threshold of oldest file age in seconds) or "count" (number of files in direcrory)'
    valid %w(age count)
  end
  
end

c = Choice.choices

# nagios performance data format: 'label'=value[UOM];[warn];[crit];[min];[max]
# see http://nagiosplug.sourceforge.net/developer-guidelines.html#AEN203


if c[:warn] && c[:crit]

  if c[:type] == 'count'
    perfdata = "file_count=%d;#{c[:warn]};#{c[:crit]}"
    message = "File count %d for #{c[:path]} exceeds %d|#{perfdata}"
    ok_message = "File count for %d for '#{c[:path]}' OK|#{perfdata}"
    value = Dir.open(c[:path]).entries.size
  else
    perfdata = "oldest_file_age=%ds;#{c[:warn]};#{c[:crit]}"
    message = "Oldest file age (%d seconds) in #{c[:path]} exceeds %d|#{perfdata}"
    ok_message = "Oldest file age (%d seconds) for #{c[:path]} OK|#{perfdata}"
    value = Dir.open(c[:path]).entries.collect {|f| Time.now - File.stat(File.join(c[:path], f)).mtime }.sort.last   
  end
  
  if value >= c[:crit]
    puts sprintf(message, value, c[:crit], value)
    exit(EXIT_CRITICAL)
  end
  
  if value >= c[:warn]
    puts sprintf(message, value, c[:warn], value)
    exit(EXIT_WARNING)
  end
  
else
  puts "Please provide a warning and critical threshold"
end

# if warning nor critical trigger, say OK and return performance data

puts sprintf(ok_message, value, value)