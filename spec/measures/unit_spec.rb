# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Unit do
  it "requires a quantity, symbol, and aliases" do
    expect { Measures::Unit.new({}) }.to raise_error(Measures::Errors::NoSymbol)
    expect { Measures::Unit.new({ symbol: :test }) }.to raise_error(Measures::Errors::NoSystem)
    expect { Measures::Unit.new({ system: :test, symbol: :test }) }.to raise_error(Measures::Errors::NoQuantity)
  end

  it "is a base unit if its quantity is a base" do
    prefix = Measures::Unit::Prefix.new(symbol: "test", full: "test", scaling_factor: 1)
    quantity = instance_double(Measures::Quantity, base?: true)
    system = Measures::SystemOfUnits::Base.new(name: "test")
    unit = described_class.new(quantity: quantity, symbol: "T", aliases: ["temperature"], prefix: prefix,
                               system: system)
    expect(unit.base?).to be_truthy
  end

  it "is commensurable with another unit if their quantities commensurable" do
    prefix = Measures::Unit::Prefix.new(symbol: "test", full: "test", scaling_factor: 1)
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_quantity = instance_double(Measures::Quantity, commensurable_with?: true)
    that_quantity = instance_double(Measures::Quantity)
    this_unit = described_class.new(quantity: this_quantity, symbol: "T", aliases: ["temperature"], prefix: prefix,
                                    system: system)
    that_unit = described_class.new(quantity: that_quantity, symbol: "T", aliases: ["temperature"], prefix: prefix,
                                    system: system)
    expect(this_unit.commensurable_with?(that_unit)).to be_truthy
  end

  it "can be scaled arbitrarily" do
    prefix = Measures::Unit::Prefix.new(symbol: "cm", full: "centi", scaling_factor: 0.1)
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_quantity = instance_double(Measures::Quantity, commensurable_with?: true)
    this_unit = described_class.new(quantity: this_quantity, symbol: "m", aliases: ["meter"], prefix: prefix,
                                    system: system)
    scaled_unit = described_class.new(quantity: this_quantity,
                                      symbol: "m",
                                      aliases: ["meter"],
                                      prefix: prefix,
                                      factor: 2.54,
                                      system: system)
    expect(this_unit.scaled_by(2.54)).to eq(scaled_unit)
  end

  it "can provide a conversion factor for another unit" do
    prefix = Measures::Unit::Prefix.new(symbol: "c", full: "centi", scaling_factor: 0.1)
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_quantity = instance_double(Measures::Quantity, commensurable_with?: true)
    centimeter = described_class.new(quantity: this_quantity,
                                     symbol: "m",
                                     aliases: ["meter"],
                                     prefix: prefix,
                                     system: system)
    inch = centimeter.scaled_by(2.54)
    expect(centimeter.conversion_factor(inch)).to eq(0.394)
  end

  it "can have its prefix removed" do
    prefix = Measures::Unit::Prefix.new(symbol: "c", full: "centi", scaling_factor: 0.1)
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_quantity = instance_double(Measures::Quantity, commensurable_with?: true)
    centimeter = described_class.new(quantity: this_quantity,
                                     symbol: "m",
                                     aliases: ["meter"],
                                     prefix: prefix,
                                     system: system)
    meter = centimeter.remove_prefix
    expect(meter.factor).to eq(0.1)
    expect(meter.prefix).to eq(Measures::Unit::Prefix.null)
  end
end
