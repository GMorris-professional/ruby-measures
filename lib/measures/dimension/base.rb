# frozen_string_literal: true

module Measures
  class Dimension
    ##
    # This class represents a base dimension that can be used to construct derived dimensions
    class Base
      include ActiveModel::Validations

      validates :symbol, presence: true
      validates :system, presence: true

      ##
      # Creates a new Base Dimension described by a +symbol+.
      #
      # An ActiveModel::ValidationError is raised if a +symbol+ is not provided
      # An ActiveModel::ValidationError is raised if a +system+ is not provided
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
