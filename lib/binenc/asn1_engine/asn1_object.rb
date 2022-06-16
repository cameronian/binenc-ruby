
require 'binenc'

module Binenc
  module Ruby
    module ASN1Object
      include Binenc::BinaryObject
      include TR::CondUtils
     
      attr_accessor :value

      def initialize(*args, &block)
        @value = args.first
      end

      def is_equal?(val)
        @value == val
      end

      def self.decode(bin)
        if not_empty?(bin)
          obj = OpenSSL::ASN1.decode(bin)    
          case obj
          when OpenSSL::ASN1::BitString
            ASN1Binary.new(obj.value)
          when OpenSSL::ASN1::UTF8String
            ASN1String.new(obj.value)
          when OpenSSL::ASN1::Integer
            ASN1Integer.new(obj.value)
          when OpenSSL::ASN1::Sequence
            ASN1Sequence.new(obj.value)
          when OpenSSL::ASN1::GeneralizedTime
            ASN1DateTime.new(obj.value)
          when OpenSSL::ASN1::ObjectId
            ASN1OID.new(obj.value)
          else
            raise BinencEngineException, "Unhandled ASN1 object '#{obj.class}'"
          end
        else
          raise BinencEngineException, "Cannot decode empty binary"
        end
      end

      private
      def logger
        if @logger.nil?
          @logger = TeLogger::Tlogger.new
          @logger.tag = :ruby_asn1Obj
        end
        @logger
      end


    end
  end
end


Dir.glob(File.join(File.dirname(__FILE__),"object","*.rb")) do |f|
  require_relative f
end


