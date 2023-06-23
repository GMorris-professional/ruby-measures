# frozen_string_literal: true

module Measures
  module Builders
    class PrefixBuilder
      def self.build(system_of_units)
        builder = new(system_of_units)
        yield(builder)
        Prefix.new(full: builder.get_full, symbol: builder.get_symbol, scaling_factor: builder.get_scaling_factor)
      end

      def initialize(system_of_units)
        @system = system_of_units
        @symbol = nil
        @full = nil
        @scaling_factor = 1
      end
      attr_reader :system

      def get_symbol
        @symbol
      end

      def get_full
        @full
      end

      def get_scaling_factor
        @scaling_factor
      end

      def symbol(*args)
        @symbol = args[0]
      end

      def full(*args)
        @full = args[0]
      end

      def scaling_factor(*args)
        @scaling_factor = args[0]
      end
    end
  end
end
