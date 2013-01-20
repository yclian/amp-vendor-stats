module Amp

  class Plugin

    def initialize(amp, plugin)
      @amp_url = amp
      @plugin_url = "#{amp}/rest/1.0/plugins/#{plugin}"
    end

    def read(url = @plugin_url)
      plugin = HTTParty.get url
      plugin = JSON.parse plugin.response.body if plugin.response.is_a?(Net::HTTPSuccess) or
        raise Net::HTTPError.new "#{plugin.response.code} #{plugin.response.message}", plugin.response
    end

  end

end

