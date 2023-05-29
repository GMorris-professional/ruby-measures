# frozen_string_literal: true

module Measures
  class Dimension
    class Base
      include ActiveModel::Validations

      validates :symbol, presence: true
      validates :system, presence: true

      def initialize(options = {})
        @symbol = options[:symbol]
        @system = options[:system]
        validate!
      end
      attr_reader :symbol, :system

      def ==(other)
        symbol == other.symbol &&
          same_system?(other)
      end

      def hash
        symbol.hash
      end

      def eql?(other)
        symbol == other.symbol &&
          same_system?(other)
      end

      def same_system?(other)
        system == other.system
      end
    end
  end
end
