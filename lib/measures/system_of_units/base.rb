# frozen_string_literal: true

module Measures
  module SystemOfUnits
    class Base
      def initialize(options = {})
        @name = options[:name]
        @prefixes = options[:prefixes] || {}
        @units = options[:units] || {}
        @quantities = options[:quantities] || {}
        @base_dimensions = options[:base_dimensions] || {}
      end
      attr_reader :name, :prefixes, :units, :quantities, :base_dimensions

      def base_dimension_for_symbol(symbol)
        return @base_dimensions[symbol.to_sym] if @base_dimensions.key?(symbol.to_sym)

        raise StandardError, "There is no base dimension for #{symbol} in the #{name} system of units"
      end

      def base_dimension(*args)
        add_base_dimension(*args)
      end

      def add_base_dimension(*args)
        symbol = args[0]
        @base_dimensions[symbol] = Dimension::Base.new(symbol: symbol, system: self)
      end

      def quantity(*args, &block)
        kind = args[0].to_sym
        raise StandardError, "#{kind} is already defined as a quantity in #{name}" if @quantities[kind]

        @quantities[kind] = Quantity.new(dimension: Dimension.new(terms: [], system: self), kind: kind, system: self)
        @quantities[kind].instance_eval(&block) if block_given?
      end

      def quantity_for_kind(kind)
        @quantities[kind]
      end

      def prefix(*args, &block)
        full = args[0].to_sym
        raise StandardError, "#{full} is already defined as a prefix in #{name}" if prefix_for_full(full)

        new_unit_prefix = Unit::Prefix::Builder.build(self) do |prefix_builder|
          prefix_builder.full(full)
          prefix_builder.instance_eval(&block) if block_given?
        end
        @prefixes[new_unit_prefix.full.to_sym] = new_unit_prefix
      end

      def prefix_for_full(args)
        @prefixes[args[0].to_sym]
      end

      def unit(*args, &block)
        name = args[0].to_sym
        raise StandardError, "#{name} is already defined as a unit in #{self.name}" if @units[name]

        new_unit = Unit::Builder.build(self) do |unit_builder|
          unit_builder.aliases(name)
          unit_builder.instance_eval(&block) if block_given?
        end
        new_unit.aliases.each do |unit_alias|
          @units[unit_alias.to_sym] = new_unit
        end
      end

      def unit_for_quantity(quantity)
        units.find { |unit| unit.quantity.commensurable_with?(quantity) }
      end
    end
  end
end
