module MBWS
  class Track < Resource

    attr_accessor :title,:sequence,:duration,:language,:script
    
    def initialize(hash, options = {})
      @release = nil
      @artist = nil
      @puids = nil
      
      super

      @title = hash["title"]
      @duration = hash["duration"]
    end
    
    # This assumes that there is only one release attached to the
    # track.  The standard allows for multiple releases but I'm not
    # sure if any track actually have multiple release.
    def release
      return @release if @release
      xml = Request.get("track/#{@mid}",:inc => "releases")
      parse_releases(xml["track"][0])
    end
    
    def artist
      return @artist if @artist
      track_xml = Request.get("track/#{self.mid}",:inc => "artist")
      parse_artist(track_xml["track"][0])
    end
    
    def puids
      return @puids if @puids
      track_xml = Request.get("track/#{self.mid}",:inc => "puids")
      parse_puids(track_xml["track"][0])
      @puids
    end

    private
    def parse_releases(xml)
      # We do a find instead of creating a new one because including
      # a release doesn't include the asin but I think it would be better
      # to make Release#asin a method and have it grab the asin if it needs
      # it
      # FIXME
      @release = Release.find(xml["release-list"]["release"][0]["id"])
      @sequence = xml["release-list"]["release"][0]["track-list"]["offset"].to_i + 1
    end

    def parse_puids(xml)
      @puids = []
      xml["puid-list"]["puid"].each do |p|
        @puids.push(p["id"])
      end
    end
  end
end
