# frozen_string_literal: true

require_relative "./builders/system_of_units_builder"

module Measures
  module SystemOfUnits
    module SystemOfUnitsClassMethods
      def system_of_units(*args, &block)
        if args[0].is_a?(Symbol) || args[0].is_a?(String)
          # using custom name
          system_name = args[0].to_sym
          options = args[1] || {}
        else
          # using the default system name
          system_name = :default
          options = args[0] || {}
        end

        Measures::SystemOfUnits.define_getter_method(system_name)

        Measures::Builders::SystemOfUnitsBuilder.build(Measures::SystemOfUnits, system_name) do |system_of_units|
          system_of_units.instance_eval(&block) if block
        end
      end
    end

    def self.included(klass)
      klass.extend SystemOfUnitsClassMethods
    end

    def self.define_getter_method(system_name)
      define_singleton_method system_name do
        fetch(system_name)
      end
    end

    def self.systems
      @systems ||= {}
    end

    def self.register(name, system_of_units)
      systems[name] = system_of_units
      self
    end

    def self.fetch(name)
      systems[name.to_sym] || Measures::SystemOfUnits::Base.new(name: name)
    end
  end
end
