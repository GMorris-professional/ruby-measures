# frozen_string_literal: true

require_relative "./dimension/term"

module Measures
  class Dimension
    include Measures::Concerns::Multiplicable
    include ActiveModel::Validations

    def ==(other)
      terms == other.terms
    end

    def add_term(base, power)
      base_dimension = system.base_dimension_for_symbol(base)
      terms << Dimension::Term.new(base: base_dimension, power: power)
    end

    def *(other)
      combined_terms = super(other)
      self.class.new(terms: combined_terms)
    end

    def /(other)
      combined_terms = super(other)
      self.class.new(terms: combined_terms)
    end

    def base?
      terms.keys.count == 1 &&
        terms.all? { |_base, power| power == 1 }
    end
  end
end
