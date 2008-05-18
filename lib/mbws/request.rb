module MBWS
  class Request
    @@requests = []
    def self.get(path,options = {})
      # MB limits us to 13 requests every 10 seconds.
      # We police ourselves a bit stricter to make certain
      # that we don't exceed this limit.
      #
      # Another way to do this would be to pace ourselves
      # so that there is always 10/13 of a second between
      # requests but this method allows short bursts
      
      # Delete requests if they happened more than 11 seconds ago
      now = Time.now
      @@requests.delete_if{ |t| (now - t) > 11}

      # If there are 11 or more requests sleep until
      # only 10 have occured in the past 10 seconds
      if @@requests.size > 10
        interval = 10 - (now - @@requests[-11])
        sleep interval if interval > 0
      end

      opts = options.collect {|k,v|
        if k == :inc and v.class == Array
          k.to_s + "=" + v.join("+")
        else
          k.to_s + "=" + v.to_s
        end
      }.join("&")
      path += "?type=xml&" + opts
      http = Net::HTTP.new('musicbrainz.org',80)
      http.start do
        request = Net::HTTP::Get.new('/ws/1/' + URI.escape(path))
        @@requests.push(Time.now)
        res = http.request(request)
        if res.code == 404
          raise MBIDNotFound
        else
          return Parsing::XmlParser.new(res.body)
        end
      end
    end
  end
end
