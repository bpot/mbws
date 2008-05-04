#:stopdoc:
# A lot of this is based on...errr taken...from the AWS::S3 module (http://amazon.rubyforge.org/) 
# by Marcel Molina <marcel@vernix.org>
module MBWS
  module Parsing
    class XmlParser < Hash
      
      attr_reader :body, :xml_in, :root

      def initialize(body)
        @body = body
        update(parse)
#        set_root
 #       typecast_xml_in
      end

      private
        
        def parse
          @xml_in = XmlSimple.xml_in(@body, parsing_options)
        end

        def parsing_options
          {
          # Force nested elements to be put into an array, even if there is only on of them.
          'forcearray' => ['relation','artist','release','relation-list','disc','track','label','url'],

          'KeyAttr' => ['target-type']
          }
        end
        def set_root
          @root = @xml_in.keys.first.underscore
        end
        def typecast_xml_in
          typecast_xml = {}
          @xml_in.dup.each do |k,v|
            #typecast_xml[k.underscore] = typecast(v)
          end
          update(typecast_xml[root]) if typecase_xml[root].is_a?(Hash)
        end
    end
  end
end
