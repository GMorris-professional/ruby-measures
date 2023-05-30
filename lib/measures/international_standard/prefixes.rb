# frozen_string_literal: true

module Measures
  module InternationalStandard
    class Prefixes
      include SystemOfUnits

      system_of_units :international_standard do
        prefix :centi do
          symbol :c
          scaling_factor 0.1
        end
      end
    end
  end
end
