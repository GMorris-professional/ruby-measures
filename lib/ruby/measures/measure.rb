# frozen_string_literal: true

module Measures
  class Measure
    include ActiveModel::Validations

    attr_reader :magnitude, :unit

    validates :magnitude, numericality: { greater_than: 0 }
    validates :unit, presence: true

    def initialize(options = {})
      @magnitude = options[:magnitude]
      @unit = options[:unit]
      validate!
    end

    def to(other_unit, **options)
      converted_unit = unit.to(other_unit)
      converted_magnitude = magnitude * unit.conversion_factor(other_unit, **options)
      self.class.new(magnitude: converted_magnitude, unit: converted_unit)
    end
  end
end
