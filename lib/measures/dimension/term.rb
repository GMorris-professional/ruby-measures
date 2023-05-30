# frozen_string_literal: true

module Measures
  class Dimension
    class Term
      include ActiveModel::Validations

      validates :base, presence: true
      validates :power, numericality: { only_integer: true }

      def initialize(options = {})
        @base = options[:base]
        @power = options[:power] || 1
      end
      attr_reader :base, :power

      def ==(other)
        base == other.base &&
          power == other.power
      end

      def eql?(other)
        self == other
      end

      def *(other)
        raise StandardError, "Can't combine two factors with different bases" unless base == other.base

        self.class.new(base: base, power: power + other.power)
      end

      def /(other)
        raise StandardError, "Can't combine two factors with different bases" unless base == other.base

        self.class.new(base: base, power: power - other.power)
      end

      def invert
        self.class.new(base: base, power: -power)
      end
    end
  end
end
