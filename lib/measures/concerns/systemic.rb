# frozen_string_literal: true

require_relative "../errors/no_system"

module Measures
  module Concerns
    module Systemic
      module SystemicPrependedMethods
        def initialize(options)
          @system = options.delete(:system)
          raise Measures::Errors::NoSystem unless @system

          method(__method__).super_method.arity.positive? ? super(options) : super()
        end
      end

      def self.included(klass)
        klass.attr_reader :system
        klass.prepend SystemicPrependedMethods
      end
    end
  end
end
