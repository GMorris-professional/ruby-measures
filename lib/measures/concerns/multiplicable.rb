# frozen_string_literal: true

module Measures
  module Concerns
    module Multiplicable
      def self.prepended(klass)
        klass.attr_reader :terms
      end

      def initialize(options)
        @terms = options.delete(:terms) || { self => 1 }
        options.any? ? super(options) : super()
      end

      def *(other)
        other_terms = other.terms
        combined_terms =  combine_terms(other_terms)
        defined?(super) ? super(combined_terms) : combined_terms
      end

      def /(other)
        other_terms = other.inverted_terms
        combined_terms = combine_terms(other_terms)
        defined?(super) ? super(combined_terms) : combined_terms
      end

      def inverted_terms
        inverted_terms ||= {}
        terms.map { |key, value| inverted_terms[key] = -1 * value.to_i }
        inverted_terms
      end

      private

      def combine_terms(other_terms)
        terms.merge(other_terms) { |_key, oldval, newval| newval.to_i + oldval.to_i }
      end
    end
  end
end
