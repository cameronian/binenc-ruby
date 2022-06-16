

module Binenc
  module Ruby

    class ASN1Binary
      include ASN1Object

      def encoded
        OpenSSL::ASN1::BitString.new(@value).to_der
      end

    end
  end
end
