# frozen_string_literal: true

module Measures
  module Builders
    class Unit
      def self.build(system_of_units)
        builder = new(system_of_units)
        yield(builder)
        Unit.new(aliases: builder.get_aliases, quantity: builder.get_quantity, system: builder.system,
                 symbol: builder.get_symbol, prefix: builder.get_prefix)
      end

      def initialize(system_of_units)
        @system = system_of_units
        @name = nil
        @quantity = nil
        @symbol = nil
        @prefix = nil
        @aliases = []
      end
      attr_reader :system

      def get_aliases
        @aliases
      end

      def get_quantity
        @quantity
      end

      def get_symbol
        @symbol
      end

      def get_prefix
        @prefix
      end

      def aliases(*args)
        @aliases << args[0]
      end

      def quantity(*args)
        @quantity = system.quantity_for_kind(args[0])
      end

      def symbol(*args)
        @symbol = args[0]
      end

      def prefix(*args)
        @prefix = system.prefix_for_full(args[0])
      end
    end
  end
end
