module Amp

  class App

    def initialize(my, app)
      @my_url = my
      @app = app
      @url = "#{my}/download/feeds"
    end

    def read(url = @url)
    
      # /archived/#{app}.json"
      # /current/#{app}.json"

      binaries = Array.new
      binaries.concat read_distros(@url + "/current/#{@app}.json")
      binaries.concat read_distros(@url + "/archived/#{@app}.json")
      
      binaries.each do |b|
        handle_binary b
      end
      
    end
    
    # Read distros of a given URL. They are either the current 
    def read_distros(url)
  
      filtered = Array.new

      binaries = HTTParty.get url
      binaries = JSON.parse binaries.response.body.sub(%r{downloads\(}, '').sub(%r{\)$}, '') if binaries.response.is_a?(Net::HTTPSuccess) or
        raise Net::HTTPError.new "#{binaries.response.code} #{binaries.response.message}", binaries.response
      
      visitor = ""
      
      binaries.each do |b|
        if is_tarball(b)
          next if visitor == b['version']
          visitor = b['version']
          filtered << b
        end
      end
      
      return filtered
      
    end

    def handle_binary(b)
      raise NotImplementedError
    end
    
    def is_tarball(b)
      b['description'] =~ /TAR\.GZ/
    end

  end

end
