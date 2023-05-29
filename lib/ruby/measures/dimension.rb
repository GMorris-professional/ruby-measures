# frozen_string_literal: true

require_relative "./dimension/factor"

module Measures
  class Dimension
    include ActiveModel::Validations

    attr_reader :factors, :system

    validates :factors, presence: true
    validates :system, presence: true

    def initialize(options = {})
      @system = options[:system]
      @factors = options[:factors].compact || []
    end

    def ==(other)
      factors.all? { |factor| other.factors.include?(factor) }
    end

    def add_factor(base, power)
      base_dimension = system.base_dimension_for_symbol(base)
      factors << Dimension::Factor.new(base: base_dimension, power: power)
    end
    alias factor add_factor

    def *(other)
      all_factors = [*factors, *other.factors]
      all_base_dimensions = all_factors.map(&:base).uniq

      factors = all_base_dimensions.map do |base_dimension|
        all_factors.select { |factor| factor.base == base_dimension }.inject(&:*)
      end
      self.class.new(factors: factors.select { |factor| factor.power > 0 || factor.power < 0 })
    end

    def /(other)
      other = self.class.new(factors: other.factors.map(&:invert))
      self * other
    end

    def base?
      factors.count == 1 &&
        factors.all? { |factor| factor.power == 1 }
    end
  end
end
