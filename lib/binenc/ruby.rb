# frozen_string_literal: true

require 'teLogger'
require 'toolrack'


require_relative "ruby/version"

require_relative 'provider'

module Binenc
  module Ruby
    class Error < StandardError; end
    # Your code goes here...
 
    # detect if the given string is binary or not
    def self.is_binary_string?(str)
      # https://stackoverflow.com/a/32536221/3625825
      str.count('01') == str.size
    end


  end
end


# register the provider
require 'binenc'
Binenc::Provider.instance.register(Binenc::Ruby::Provider)


