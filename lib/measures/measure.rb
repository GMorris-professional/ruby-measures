# frozen_string_literal: true

module Measures
  class Measure
    include ActiveModel::Validations

    attr_reader :numerical_value, :unit

    def initialize(options)
      @numerical_value = options[:numerical_value]
      @unit = options[:unit]
      raise Measures::Errors::NoNumericalValue unless @numerical_value
      raise Measures::Errors::NumericalValueNotPositive unless @numerical_value.positive?
      raise Measures::Errors::NoUnit unless @unit
    end

    def to(other_unit, **options)
      converted_unit = unit.to(other_unit)
      converted_numerical_value = numerical_value * unit.conversion_factor(other_unit, **options)
      self.class.new(numerical_value: converted_numerical_value, unit: converted_unit)
    end
  end
end
