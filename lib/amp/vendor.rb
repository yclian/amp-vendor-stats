module Amp

  class Vendor

    def initialize(amp, vendor)
      @amp_url = amp
      @vendor_url = "#{amp}/rest/1.0/plugins/vendor/#{vendor}"
    end

    def read(url = @vendor_url, continue = true)

      vendor = HTTParty.get url
      vendor = JSON.parse vendor.response.body if vendor.response.is_a?(Net::HTTPSuccess) or
        raise Net::HTTPError.new "#{vendor.response.code} #{vendor.response.message}", vendor.response

      vendor['plugins'].each do |p|
        if read_plugin? p
          p = read_plugin p
        end
        handle_plugin p
      end

      next_url = vendor['links'].find { |l| l['rel'] == 'next' && l['type'].include?('json') }
      if next_url
        next_url = "#{@amp_url}#{next_url['href']}"
        read next_url if continue
      end
      
    end

    def handle_plugin(p)
      raise NotImplementedError
    end

    def read_plugin(p)
      Amp::Plugin.new(@amp_url, p['pluginKey']).read
    end

    def read_plugin?(p)
      raise NotImplementedError
    end

  end

end
