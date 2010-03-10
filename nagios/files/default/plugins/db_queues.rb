#!/usr/bin/env ruby
#
# Check the size of a database queue
#

require 'rubygems'
require 'choice'
require 'mysql'

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

  option :host do
    short '-H'
    long '--host=VALUE'
    desc 'MySQL DB host'
  end    

  option :username do
    short '-u'
    long '--username=VALUE'
    desc 'MySQL DB username'
  end    
  
  option :password do
    short '-p'
    long '--password=VALUE'
    desc 'MySQL DB password'
  end    
  
  option :database do
    short '-d'
    long '--database=VALUE'
    desc 'MySQL database'
  end
  
  option :query do
    short '-q'
    long '--query=VALUE'
    desc 'MySQL DB count query'
  end  

end

c = Choice.choices

# nagios performance data format: 'label'=value[UOM];[warn];[crit];[min];[max]
# see http://nagiosplug.sourceforge.net/developer-guidelines.html#AEN203

perfdata = "query_count=%d;#{c[:warn]};#{c[:crit]}"
message = "Query '#{c[:query]}' result %d exceeds %d|#{perfdata}"

if c[:warn] && c[:crit]
  
  conn = Mysql::connect(c[:host], c[:username], c[:password], c[:database])
  res = conn.query(c[:query])
  value = res.fetch_row
  value = value.first.to_i

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

puts sprintf("Query '#{c[:query]}' result %d OK|#{perfdata}", value, value)