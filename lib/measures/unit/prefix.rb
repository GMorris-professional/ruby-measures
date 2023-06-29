# frozen_string_literal: true

module Measures
  class Unit
    class Prefix
      def self.null
        new(symbol: "", full_description: "", scaling_factor: 1)
      end
      include Measures::Concerns::Symbolic

      def initialize(options)
        @full_description = options[:full_description]
        @scaling_factor = options[:scaling_factor]
        raise Measures::Errors::NoFullDescription unless @full_description
        raise Measures::Errors::NoScalingFactor unless @scaling_factor
      end
      attr_reader :full_description, :scaling_factor

      def ==(other)
        symbol == other.symbol
      end
      alias eql? ==

      def hash
        symbol.hash
      end
    end
  end
end
