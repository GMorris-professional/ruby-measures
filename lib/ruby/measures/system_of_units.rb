# frozen_string_literal: true

require_relative "./system_of_units/store"
require_relative "./system_of_units/builder"

module Measures
  module SystemOfUnits
    extend ActiveSupport::Concern
    class_methods do
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

        Builder.build(Store, system_name) do |system_of_units|
          system_of_units.instance_eval(&block) if block
        end
      end
    end

    def self.define_getter_method(system_name)
      define_singleton_method system_name do
        Store.fetch(system_name)
      end
    end
  end
end
