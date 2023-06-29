# frozen_string_literal: true

require_relative "./dimension/term"

module Measures
  class Dimension
    include Measures::Concerns::Multiplicable

    def ==(other)
      terms == other.terms
    end

    def add_term(base, _power)
      terms[base] += 1
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
