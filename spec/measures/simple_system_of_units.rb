# frozen_string_literal: true

require "spec_helper"

class SimpleSystemOfUnits
  include SystemOfUnits

  system_of_units :standard_international do
  end
end
