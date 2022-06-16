

module Binenc
  module Ruby
    
    class ASN1DateTime
      include ASN1Object
      
      def encoded
        raise BinencEngineException, "Given value is not a Time object. #{@value.class}" if not @value.is_a?(Time)
        OpenSSL::ASN1::GeneralizedTime.new(@value).to_der
      end

      def is_equal?(val)

        case val
        when Integer
          @value.to_i == val
        when Time
          @value.to_i == val.to_i
        else
          @value == val
        end
        
      end

    end

  end
end
