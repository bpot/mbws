module MBWS
  module Relations
    class RelationsBase < Array
      
      def initialize(xml = {})
        parse(xml)
      end
      
      def relations_by_type(type)
        rels = []
        self.each do |r|  
          rels.push(r) if r[:type] == type
        end
        rels
      end
      
      private    

      def parse(xml)
        klass_str = self.class.to_s.split("::")[2].gsub(/Relations$/,'')
        klass = MBWS.const_get(klass_str)
        obj_sym = klass_str.downcase.to_sym
        
        xml["relation"].each do |r|
          h = Hash.new

          h[:type] = r["type"]
          h[:direction] = r["direction"] if r["direction"]
          
          # Url's don't have their own tag
          if obj_sym == :url
            h[obj_sym] = klass.new(r)
          else
            h[obj_sym] = klass.new(r[klass_str.downcase][0])
          end
          
          self.push(h)
        end if xml["relation"]
      end
      
    end
  end
end
