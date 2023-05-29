# frozen_string_literal: true

module Measures
  module SystemOfUnits
    class Builder
      def self.build(store, system_name)
        builder = new(store, system_name)
        yield(builder)
      end

      def initialize(store, system_name)
        @store = store
        @system_of_units = @store.fetch(system_name)
        @store.register(system_name, @system_of_units)
      end

      def base_dimension(_args)
        puts "test"
      end

      def base_dimension(_args)
        puts "test"
      end

      def quantity(args); end

      def prefix(args); end

      def unit(args); end
    end
  end
end
