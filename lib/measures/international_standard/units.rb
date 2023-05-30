# frozen_string_literal: true

module Measures
  module InternationalStandard
    class Units
      include SystemOfUnits

      system_of_units :international_standard do
        unit :meter do
          aliases :m
          quantity :length
          symbol :m
        end

        unit :centimeter do
          aliases :cm
          quantity :length
          symbol :cm
          prefix :centi
        end

        unit :kilogram do
          aliases :kg
          quantity :mass
          symbol :kg
          prefix :kilo
        end
      end
    end
  end
end
