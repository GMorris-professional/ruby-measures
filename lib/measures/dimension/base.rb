# frozen_string_literal: true

require_relative "../concerns/systemic"
require_relative "../concerns/symbolic"
require_relative "../errors/no_symbol"

module Measures
  class Dimension
    class Base
      include Measures::Concerns::Symbolic
      include Measures::Concerns::Systemic

      def initialize(options); end

      def ==(other)
        symbol == other.symbol &&
          same_system?(other)
      end

      def hash
        symbol.hash
      end

      def eql?(other)
        symbol == other.symbol &&
          same_system?(other)
      end

      def same_system?(other)
        system == other.system
      end
    end
  end
end
