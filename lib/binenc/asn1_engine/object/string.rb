

module Binenc
  module Ruby
    
    class ASN1String
      include ASN1Object

      def encoded
        OpenSSL::ASN1::UTF8String.new(@value).to_der
      end

      def is_equal?(val)
        @value.bytes == val.bytes
      end

    end

  end
end
