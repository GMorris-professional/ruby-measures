# frozen_string_literal: true

require_relative "../errors/no_symbol"

module Measures
  module Concerns
    module Symbolic
      module SymbolicPrependedMethods
        def initialize(options)
          @symbol = options.delete(:symbol)
          raise Measures::Errors::NoSymbol unless @symbol

          return unless defined?(super)

          method(__method__).super_method.arity.positive? ? super : super()
        end
      end

      def self.included(klass)
        klass.attr_reader :symbol
        klass.prepend SymbolicPrependedMethods
      end
    end
  end
end
