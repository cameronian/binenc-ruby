

module Binenc
  module Ruby
    
    class ASN1Integer
      include ASN1Object

      def encoded
        OpenSSL::ASN1::Integer.new(@value).to_der
      end
    end

  end
end
