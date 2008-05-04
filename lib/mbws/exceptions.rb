module MBWS
  class MBWSException < StandardError
  end
  
  class ResponseError < MBWSException
  end

  class MBIDNotFound < ResponseError
  end

  class BadRequest < ResponseError
  end

  class InvalidUUID < MBWSException
    def initialize(invalid_id)
      message = "'#{invalid_id} is not a valid MBID (UUID).  "  +
                "MBIDs must be 36 characters long "             +
                "(ex. c0b2500e-0cef-4130-869d-732b23ed9df5). "  +
                "Please consult the Web Service Documentation " +
                "(http://musicbrainz.org/doc/XMLWebService) for"+
                " more information. "
      super(message)
    end
  end
end
