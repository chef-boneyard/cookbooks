require 'rubygems'
require 'choice'

module NagiosHelper
  EXIT_OK = 0
  EXIT_WARNING = 1
  EXIT_CRITICAL = 2
  EXIT_UNKNOWN = 3
  
  def warning(text)
    puts "WARNING: #{text}"
    exit EXIT_WARNING
  end
  
  def critical(text)
    puts "CRITICAL: #{text}"
    exit EXIT_CRITICAL
  end
  
  def unknown(text)
    puts "ERROR #{text}"
    exit EXIT_UNKNOWN
  end
  
end

