#!/usr/bin/env ruby
#
# Nagios check for Solr server health
# Copyright 37signals, 2008
# Author: Joshua Sierles (joshua@37signals.com)

require 'rubygems'
require 'xmlsimple'
require 'net/http'
require 'uri'
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

  option :host do
    short '-h'
    long '--host=VALUE'
    desc 'Solr host'
  end    

  option :prefix do
    short '-p'
    long '--prefix=VALUE'
    desc 'App prefix'
  end
  
  option :start do
    short '-s'
    long '--start=VALUE'
    desc 'Start index'
  end
  
  option :rows do
    short '-r'
    long  '--rows=VALUE'
    desc 'Number of rows to check for'
    default 10
  end
  
  option :query do
    short '-q'
    long  '--query=VALUE'
    desc 'Query term to search for'
    default "test%0D%0A"
  end

  option :version do
    short '-v'
    long  '--version=VALUE'
    desc 'Specify version'
    default "2.2"
  end
end

c = Choice.choices

message = "Solr reports %d rows"

if c[:crit]

  value = 0
  begin
    url = URI.parse("http://#{c[:host]}:8983/")
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.get("/#{c[:prefix]}/select/?q=#{c[:query]}&version=#{c[:version]}&start=#{c[:start]}&rows=#{c[:rows]}&indent=on")
    end

    solr = XmlSimple.xml_in(res.body, { 'ForceArray' => false, 'KeepRoot' => false })
    solr['lst']['lst']['str'].each do |str|
      next unless str['name'] == 'rows'
      value = str['content'].to_i
    end
  rescue Exception => e
   puts "Error checking Solr: #{e.message}"
   exit(EXIT_UNKNOWN)
  end
  

  if value != c[:crit]
    puts sprintf(message, value)
    exit(EXIT_CRITICAL)
  end

  if c[:warn] && value >= c[:warn]
    puts sprintf(message, value)
    exit(EXIT_WARNING)
  end

else
  puts "Please provide a critical threshold"
  exit
end

# if warning nor critical trigger, say OK and return performance data

puts sprintf("Solr is OK, reports %d rows", value)