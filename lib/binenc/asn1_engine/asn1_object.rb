
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
            #logger.debug "Found bitstring value : #{obj.value}"
            ASN1Binary.new(obj.value)
          when OpenSSL::ASN1::UTF8String
            #logger.debug "Found UTF8String value : #{obj.value}"
            ASN1String.new(obj.value)
          when OpenSSL::ASN1::Integer
            #logger.debug "Found Integer value : #{obj.value}"
            ASN1Integer.new(obj.value)
          when OpenSSL::ASN1::Sequence
            #logger.debug "Found sequence value : #{obj.value}"
            ASN1Sequence.new(obj.value)
          when OpenSSL::ASN1::GeneralizedTime
            #logger.debug "Found GeneralizedTime value : #{obj.value}"
            ASN1DateTime.new(obj.value)
          when OpenSSL::ASN1::ObjectId
            #logger.debug "Found ObjectId value : #{obj.value}"
            ASN1OID.new(obj.value)
          else
            raise BinencEngineException, "Unhandled ASN1 object '#{obj.class}'"
          end
        else
          raise BinencEngineException, "Cannot decode empty binary #{bin}"
        end
      end

      private
      def self.logger
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


