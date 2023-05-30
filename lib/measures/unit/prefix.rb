# frozen_string_literal: true

module Measures
  class Unit
    class Prefix
      def self.null
        new(symbol: "", full: "", scaling_factor: 1)
      end

      include ActiveModel::Validations

      validates :symbol, length: { minimum: 0, allow_nil: false }
      validates :full, length: { minimum: 0, allow_nil: false }
      validates :scaling_factor, numericality: true

      def initialize(options = {})
        @symbol = options[:symbol]
        @full = options[:full]
        @scaling_factor = options[:scaling_factor]
        validate!
      end
      attr_reader :symbol, :full, :scaling_factor

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
