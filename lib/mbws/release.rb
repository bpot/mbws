module MBWS
  class Release < Resource

    attr_accessor :title,:mid,:type,:status,:release_events,:asin
    
    def initialize(hash,options = {})
      @discs = nil
      @discs_count = nil
      @tracks_count = nil
      @artist = nil
      @tracks = nil
      @release_events = nil
      
      super
      
      @title = hash["title"]
      @asin = hash["asin"]
      @mid = hash["id"]
      @type = hash["type"].split(" ")[0] if hash["type"]
      @status = hash["type"].split(" ")[1] if hash["type"]
    end
    
    def artist
      return @artist if @artist
      release_xml = Request.get("release/#{self.mid}",:inc => "artist")
      parse_artist(release_xml["release"][0])
    end

    def discs
      return @discs if @discs
      release_xml = Request.get("release/#{self.mid}",:inc => "discs")
      parse_discs(release_xml["release"][0])
    end
    
    def tracks
      return @tracks if @tracks
      release_xml = Request.get("release/#{self.mid}",:inc => "tracks")
      parse_tracks(release_xml["release"][0])
      @tracks
    end
    
    def tracks_count
      return @tracks_count if @tracks_count
      nil
      #release_xml = Request.get("release/#{self.mid}",:inc => "counts")
      #parse_counts(release_xml["release"][0])
      #@tracks_count
    end

    private
      
      def parse_counts(xml)
      	@tracks_count = xml["track-list"]["count"]
      end

      def parse_discs(xml)
        @discs = []
        xml["disc-list"]["disc"].each do |d|
          @discs.push({:sectors => d["sectors"], :id => d["id"]})
        end
        @discs_count = @discs.size
      end

      def parse_tracks(xml)
        @tracks = []
        xml["track-list"]["track"].each do |t|
          @tracks.push(Track.new(t))
        end
      end

      def parse_release_events(xml)
        @release_events = []
        xml["release-event-list"]["event"].each do |re|
          @release_events.push(re)
        end
      end
  end
end
