# frozen_string_literal: true

require_relative "base"

module Measures
  module SystemOfUnits
    class Store
      def self.systems
        @systems ||= {}
      end

      def self.register(name, system_of_units)
        systems[name] = system_of_units
        self
      end

      def self.fetch(name)
        systems[name.to_sym] || SystemOfUnits::Base.new(name: name)
      end
    end
  end
end
