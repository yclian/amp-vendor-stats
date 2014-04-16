#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'amp'

class App < Amp::App

    def handle_binary(b)
      o  = b['version'] + "\t"
      o += Date.strptime(b['released'], '%d-%b-%Y').strftime('%Y-%m-%d') + "\t"
      puts o
    end

end

puts "Version\tDate"


App.new(
  ENV['MY_URL'] || 'https://my.atlassian.com',
  (ARGV.first or abort "ERROR: product name required")
).read
