# frozen_string_literal: true

module Measures
  module Concerns
    module Termable
      attr_reader :terms

      def initialize(options)
        @terms = options.delete(:terms) || { self => 1 }
        super()
      end

      def *(other)
        other_terms = other.terms
        @terms.merge(other_terms) { |_key, oldval, newval| newval.to_i + oldval.to_i }
      end

      def /(other)
        other_terms = other.inverted_terms
        @terms.merge(other_terms) { |_key, oldval, newval| newval.to_i + oldval.to_i }
      end

      def inverted_terms
        inverted_terms ||= {}
        @terms.map { |key, value| inverted_terms[key] = -1 * value.to_i }
        inverted_terms
      end
    end
  end
end
