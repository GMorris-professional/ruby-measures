# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Measure do
  it "requires a magnitude and a unit" do
    expect do
      described_class.new
    end.to raise_error(ActiveModel::ValidationError,
                       "Validation failed: Magnitude is not a number, Unit can't be blank")
  end

  it "can be converted to another unit" do
    centi = Measures::Unit::Prefix.new(symbol: "c", full: "centi", scaling_factor: 0.01)
    system = Measures::SystemOfUnits::Base.new(name: "SI")
    this_quantity = instance_double(Measures::Quantity, commensurable_with?: true)
    centimeter = Measures::Unit.new(quantity: this_quantity,
                                    symbol: "m",
                                    aliases: ["meter"],
                                    prefix: centi,
                                    system: system)
    inch = Measures::Unit.new(quantity: this_quantity,
                              symbol: "m",
                              aliases: ["meter"],
                              prefix: centi,
                              system: system,
                              multiplier: 2.54)
    two_inches = Measures::Measure.new(magnitude: 2, unit: inch)
    five_centimeters = two_inches.to(centimeter)
    expect(five_centimeters.magnitude).to eq(5.08)
    expect(five_centimeters.unit).to eq(centimeter)
  end
end
