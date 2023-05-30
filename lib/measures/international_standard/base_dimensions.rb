# frozen_string_literal: true

module Measures
  module InternationalStandard
    class BaseDimensions
      include SystemOfUnits

      system_of_units :international_standard do
        base_dimension :L
        base_dimension :M
      end
    end
  end
end
