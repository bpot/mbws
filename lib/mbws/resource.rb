module MBWS #:nodoc:
  class Resource
    include Relations

    attr_accessor :mid, :score
    
    def initialize(hash,options)
      @mid = hash["id"]
      @score = hash["ext:score"]
      @artist_rels = nil
      @url_rels = nil
      @track_rels = nil
      @release_rels = nil
      if options.has_key?(:inc)
        options[:inc].map {|i| i.to_s.gsub(/-/,"_")}.each do |s|
          self.send "parse_" + s,hash #if s.match(/rels/)
        end
      end
    end
    
    def self.find(*args)
      case args[0]
        when String
          self.find_by_mbid(args)
        when Hash
          self.find_by_query(args)
      end
    end
    
    # Relations

    def track_rels
      return @track_rels if @track_rels
      xml = Request.get("#{self.resource_name}/#{self.mid}",:inc => "track-rels")
      parse_track_rels(xml[self.resource_name][0])
      @track_rels
    end
    
    def url_rels
      return @url_rels if @url_rels
      xml = Request.get("#{self.resource_name}/#{self.mid}",:inc => "url-rels")
      parse_url_rels(xml[self.resource_name][0])
      @url_rels
    end
    
    def artist_rels
      return @artist_rels if @artist_rels
      xml = Request.get("#{self.resource_name}/#{self.mid}",:inc => "artist-rels")
      parse_artist_rels(xml[self.resource_name][0])
      @artist_rels
    end
    
    def release_rels
      return @release_rels if @release_rels
      xml = Request.get("#{self.resource_name}/#{self.mid}",:inc => "release-rels")
      parse_release_rels(xml[self.resource_name][0])
      @release_rels
    end
    
    def resource_name
      self.class.to_s.downcase.split("::")[1]
    end
    
    def self.resource_name
      self.to_s.downcase.split("::")[1]
    end

    private
    
    def self.find_by_mbid(args)
      mid = args[0]
      options = args[1] || {}

      raise InvalidUUID.new(mid) unless mid =~ /^\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$/

      xml = Request.get("#{self.resource_name}/#{mid}",options)
      return self.new(xml[self.resource_name][0],options)
    end

    def self.find_by_query(args)
      options = args[0]
      
      objs = []
      
      xml = Request.get("#{self.resource_name}/",options)
      xml[self.resource_name + "-list"][self.resource_name].each do |o|
        objs.push(self.new(o,options))
      end
      objs.sort_by { |o| o.score }
      objs
    end
    
    def parse_aliases(xml)
      @aliases = []
      xml["alias-list"]["alias"].each do |a|
        @aliases.push(a)
      end if xml["alias-list"]
    end

    def parse_artist(xml)
      @artist = Artist.new(xml["artist"][0])
    end

    [:track, :artist, :release, :label, :url].each do |symbol|
      class_eval(<<-EVAL,__FILE__,__LINE__)
        def parse_#{symbol}_rels(xml)
          if xml["relation-list"] && xml["relation-list"]["#{symbol.to_s.capitalize}"]
            @#{symbol}_rels = 
              #{symbol.to_s.capitalize}Relations.new(xml["relation-list"]["#{symbol.to_s.capitalize}"])  
          else
            @#{symbol}_rels = #{symbol.to_s.capitalize}Relations.new
          end
        end
      EVAL
    end
  end
end
