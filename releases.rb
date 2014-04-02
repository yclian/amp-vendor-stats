#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/lib')
require 'amp'

class Vendor < Amp::Vendor

  def handle_plugin(p)

    p['versions']['versions'].each do |v|

      v['compatibilities'].each do |c|

        o = p['name'] + "\t"
        o += Date.parse(v['releaseDate']).strftime('%Y-%m-%d')  + "\t"
        o += v['version'] + "\t"
        o += v['license']['id'] + "\t"
        o += v['releasedBy'] ? v['releasedBy'] + "\t" : "\t"

        o += c['applicationName'] + "\t"
        o += c['min']['version'] + "\t"
        o += c['max']['version'] + "\t"

        if v['summary'] =~ /compat/i
          o += "1\t"
        else
          if v['releaseNotes'] =~ /compat/i
            o += "1\t"
          else
            o += "0\t"
          end
        end

        puts o

      end
    end
  end

  def read_plugin?(p)
    true
  end

end

puts "Name\tDate\tVersion\tLicense\tAuthor\tApplication\tMin\tMax\tCompatibility?"

Vendor.new(
  ENV['AMP_URL'] || 'https://marketplace.atlassian.com',
  (ARGV.first or abort "ERROR: vendor ID required")
).read
