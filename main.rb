#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/lib')
require 'amp'

class Vendor < Amp::Vendor

  def handle_plugin(p)

    o = p['name'] + "\t" +
        p['version']['license']['id'] + "\t" +
        Date.parse(p['version']['releaseDate']).strftime('%Y-%m-%d')  + "\t"

    if p.has_key?('reviews') && p['reviews'].has_key?('reviews') && !p['reviews']['reviews'].empty?
      o += Date.parse(p['reviews']['reviews'].first['date']).strftime('%Y-%m-%d') + "\t"
    else
      o += "\t"
    end

    if p.has_key?('versions')
      o += p['versions']['versions'].size.to_s + "\t"
    else
      o += "\t"
    end

    if p.has_key?('reviews')
      o += p['reviews']['reviews'].size.to_s + "\t"
    else
      o += "\t"
    end

    o += ("\u2605" * p['reviewSummary']['averageStars']) + "\t" +
         p['downloadCount'].to_s

    puts o

  end

  def read_plugin?(p)
    true
  end

end

puts "Name\tLicense\tLast Release\tLast Review\tReleases\tReviews\tRating\tPopularity"

Vendor.new(
  ENV['AMP_URL'] || 'https://marketplace.atlassian.com',
  (ARGV.first or abort "ERROR: vendor ID required")
).read

