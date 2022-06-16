

module Binenc
  module Ruby
   
    class ASN1OID
      include ASN1Object

      def encoded
        OpenSSL::ASN1::ObjectId.new(@value).to_der
      end

    end

  end
end
