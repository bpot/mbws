module MBWS
  # Top of the artist documentation page
  class Artist < Resource
    
    attr_accessor :name,:sort_name,:type,:begin,:end,:disambiguation
    
    def initialize(hash,options = {})
      @aliases = nil
      
      super
      
      attrs = ["name","type","disambiguation","sort-name"]
      attrs.each do |a|
        self.instance_variable_set("@#{a.gsub('-','_')}",hash[a])
      end
      
      @begin = hash["life-span"]["begin"] if hash["life-span"]
      @end = hash["life-span"]["end"] if hash["life-span"]
      
    end
    
    def aliases
      return @aliases if @aliases
      artist_xml = Request.get("artist/#{self.mid}",:inc => "aliases")
      parse_aliases(artist_xml["artist"][0])
      @aliases
    end
    
    # Return releases where artist is the primary artist (Single Artist Albums).
    #
    # Cached
    def releases()
      @releases if @releases
      @releases = Release.find(:artistid => self.mid, :inc => "counts",:limit => 100)
    end

    # 
    def releases_find(options = {})
      options.merge!(:artistid => self.mid, :inc => "counts")
      Release.find(options)
    end
    
    #
    def va_releases(options)
      _inc_releases("va-",options)
    end

    def sa_releases(options)
      _inc_releases("sa-",options)
    end
    
    def all_va_releases
      _all_inc_releases("va-")
    end
    
    def all_sa_releases
      _all_inc_releases("sa-")
    end

    private
    def _inc_releases(prefix,options)
      inc = []
      [:type, :status].each do |k|
        inc.push(prefix + options[k].to_s) if options.include?(k)
      end
      
      releases = []
      xml = Request.get("artist/#{self.mid}", :inc => inc)
      xml["artist"][0]["release-list"]["release"].each do |rxml|
        releases.push(Release.new(rxml,{}))
      end if ["artist"][0]["release-list"]
      releases
    end

    def _all_inc_releases(prefix)
      all = []
      [:Official, :Promotion, :Bootleg, :PseudoRelease].each do |status|
        sleep 1
        all.push(_inc_releases(prefix,:status => status))
      end
      all.compact
    end
  end
end
