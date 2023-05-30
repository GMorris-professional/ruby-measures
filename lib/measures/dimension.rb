# frozen_string_literal: true

require_relative "./dimension/term"

module Measures
  class Dimension
    include ActiveModel::Validations

    attr_reader :terms, :system

    validates :terms, presence: true
    validates :system, presence: true

    def initialize(options = {})
      @system = options[:system]
      @terms = options[:terms].compact || []
    end

    def ==(other)
      terms.all? { |factor| other.terms.include?(factor) }
    end

    def add_factor(base, power)
      base_dimension = system.base_dimension_for_symbol(base)
      terms << Dimension::Term.new(base: base_dimension, power: power)
    end
    alias factor add_factor

    def *(other)
      all_terms = [*terms, *other.terms]
      all_base_dimensions = all_terms.map(&:base).uniq

      terms = all_base_dimensions.map do |base_dimension|
        all_terms.select { |factor| factor.base == base_dimension }.inject(&:*)
      end
      self.class.new(terms: terms.select { |factor| factor.power > 0 || factor.power < 0 })
    end

    def /(other)
      other = self.class.new(terms: other.terms.map(&:invert))
      self * other
    end

    def base?
      terms.count == 1 &&
        terms.all? { |factor| factor.power == 1 }
    end
  end
end
