

module Binenc
  module Ruby
    
    class ASN1Sequence
      include ASN1Object 

      def initialize(*args, &block)
        super
        @value = to_value(@value) 
      end

      def encoded
        @value = [@value] if not @value.is_a?(Array)
        value = to_encoded(@value)
        OpenSSL::ASN1::Sequence.new(value).to_der
      end

      def is_equal?(val)
        not @value.difference(val).any?
      end

      private
      #def is_binary_string?(str)
      #  # https://stackoverflow.com/a/32536221/3625825
      #  str.count('01') == str.size
      #end

      def to_encoded(val)

        if not val.nil?
          val = [val] if not val.is_a?(Array)
          
          v = val.map do |e|

            case e
            when Integer
              ASN1Integer.new(e).encoded
            when String
              if Binenc::Ruby.is_binary_string?(e)
                ASN1Binary.new(e).encoded
              else
                ASN1String.new(e).encoded
              end
            when Time
              ASN1DateTime.new(e).encoded
            else
              logger.debug "Missed #{e} / #{e.class}"
              nil
            end

          end # map

          v.delete_if { |e| e.nil? }

        else
          []
        end


      end

      def to_value(arr)
       
        if not arr.nil? 
          arr = [arr] if not arr.is_a?(Array)

          arr.map do |e|

            case e
            when OpenSSL::ASN1::Primitive
              v = e.value

              if v.is_a?(OpenSSL::BN)
                v.to_i
              else
                v
              end
            else
              e
            end

          end # map

        else
          []
        end

      end

    end

  end
end
