# frozen_string_literal: true

require_relative "../errors/no_system"

module Measures
  module Concerns
    module Systemic
      def self.included(klass)
        klass.attr_reader :system
      end

      def initialize(options)
        @system = options.delete(:system)
        raise Measures::Errors::NoSystem unless @system

        super()
      end
    end
  end
end
