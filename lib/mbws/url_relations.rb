module MBWS
  class Url
    attr_accessor :type,:url

    def initialize(hash)
      @type = hash["type"]
      @url = hash["target"]
    end
  end
  module Relations
    class UrlRelations < RelationsBase
    end
  end
end
