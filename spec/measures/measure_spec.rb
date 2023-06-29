# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Measure do
  it "requires a magnitude and a unit" do
    expect { Measures::Measure.new({}) }.to raise_error(Measures::Errors::NoNumericalValue)
    expect { Measures::Measure.new({ numerical_value: 0 }) }.to raise_error(Measures::Errors::NumericalValueNotPositive)
    expect { Measures::Measure.new({ numerical_value: 1 }) }.to raise_error(Measures::Errors::NoUnit)
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
                              factor: 2.54)
    two_inches = Measures::Measure.new(numerical_value: 2, unit: inch)
    five_centimeters = two_inches.to(centimeter)
    expect(five_centimeters.numerical_value).to eq(5.08)
    expect(five_centimeters.unit).to eq(centimeter)
  end
end
