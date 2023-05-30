# frozen_string_literal: true

module Measures
  module InternationalStandard
    class Quantities
      include SystemOfUnits

      system_of_units :international_standard do
        quantity :length do
          dimension do
            factor :L, 1
          end
        end

        quantity :mass do
          dimension do
            factor :M, 1
          end
        end

        quantity :area do
          dimension do
            factor :L, 2
          end
        end

        quantity :volume do
          dimension do
            factor :L, 3
          end
        end

        quantity :density do
          dimension do
            factor :M, 1
            factor :L, -3
          end
        end
      end
    end
  end
end
