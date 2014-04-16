module Amp

  class App

    def initialize(my, app)
      @my_url = my
      @url = "#{my}/download/feeds/archived/#{app}.json"
    end

    def read(url = @url)

      binaries = HTTParty.get url
      binaries = JSON.parse binaries.response.body.sub(%r{downloads\(}, '').sub(%r{\)$}, '') if binaries.response.is_a?(Net::HTTPSuccess) or
        raise Net::HTTPError.new "#{binaries.response.code} #{binaries.response.message}", binaries.response
      
      visitor = ""
      binaries.each do |b|
        if is_tarball(b)
          next if visitor == b['version']
          visitor = b['version']
          handle_binary b
        end
      end

    end

    def handle_binary(b)
      raise NotImplementedError
    end
    
    def is_tarball(b)
      b['description'] =~ /TAR\.GZ/
    end

  end

end
