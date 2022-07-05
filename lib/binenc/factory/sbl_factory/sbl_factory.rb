
require_relative 'sbl_dsl'

module Binenc
  module Ruby

    # simple binary layout factory
    class SBLFactory
      include SBLDSL

      def define(&block)
        instance_eval(&block) 
        self
      end

      def encoded
        res = []
        structure.each do |st|
          res << self.send("#{to_instance_method_name(st)}").encoded
        end

        ASN1Sequence.new(res).encoded
      end

      def from_bin(bin)
        
        seq = ASN1Object.decode(bin).value

        if seq.length > structure.length
          logger.warn "Given binary has more field (#{seq.length}) than the defined specification (#{structure.length}). Different version of structure?"
        elsif structure.length > seq.length
          logger.warn "Defined specification has more field (#{structure.length}) than given binary (#{seq.length}). Different version of structure?"
        end

        structure.each_index do |i|
          name = structure[i]
          
          if seq[i].is_a?(String)
            # begin block is to cater sequence but tagged as binary field
            # Therefore during 1st decode, it will become an array with actual value, 
            # no longer a ASN1 encoded field.
            # Different if the field is tagged as sequence, then this will not happened
            begin
              val = ASN1Object.decode(seq[i]).value
            rescue OpenSSL::ASN1::ASN1Error
              val = seq[i]
            end
          else
            val = seq[i]
          end

          case val
          when OpenSSL::BN
            val = val.to_i
          end
          create_instance_method(name, val)
        end

        self

      end

      def value_from_bin_struct(bin, *fieldNo)

        begin
          seq = ASN1Object.decode(bin).value

          ret = []
          fieldNo.each do |fn|
            raise BinencEngineException, "Given field no '#{fn}' to extract is larger than found fields (#{seq.length})" if fn > seq.length

            v = seq[fn]
            if v.is_a?(String)
              begin
                vv = ASN1Object.decode(v).value
              rescue OpenSSL::ASN1::ASN1Error
                vv = v
              end
            else
              vv = v
            end

            case vv
            when OpenSSL::BN
              ret << vv.to_i
            else
              ret << vv
            end
          end

          ret
        rescue OpenSSL::ASN1::ASN1Error => ex
          raise BinencDecodingError, ex
        end

      end

      private
      def logger
        if @logger.nil?
          @logger = TeLogger::Tlogger.new
          @logger.tag = :sbl_fact
        end
        @logger
      end

    end

  end
end
