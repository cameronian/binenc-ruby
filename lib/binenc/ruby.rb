# frozen_string_literal: true

require 'teLogger'
require 'toolrack'


require_relative "ruby/version"

require_relative 'provider'

module Binenc
  module Ruby
    class Error < StandardError; end
    # Your code goes here...
  end
end


# register the provider
require 'binenc'
Binenc::Provider.instance.register(Binenc::Ruby::Provider)


