module MBWS

  class Request
    def self.get(path,options = {})
      #if !@last_call.nil? && (Time.now - @last_call < 1)
      #  p "Sleeping"
      #  t = Time.now - @last_call
      #  sleep t unless t < 0
      #end
      opts = options.collect {|k,v|
        if k == :inc and v.class == Array
          k.to_s + "=" + v.join("+")
        else
          k.to_s + "=" + v.to_s
        end
      }.join("&")
      path += "?type=xml&" + opts
#      p path
      http = Net::HTTP.new('musicbrainz.org',80)
      http.start do
        request = Net::HTTP::Get.new('/ws/1/' + URI.escape(path))
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
