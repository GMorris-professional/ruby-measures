# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Dimension do
  it "are equivalent if their factors are equivalent" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_factor = Measures::Dimension::Term.new(base: base_dimension, power: 1)
    that_factor = Measures::Dimension::Term.new(base: base_dimension, power: 1)

    this = described_class.new(factors: [this_factor])
    that = described_class.new(factors: [that_factor])

    expect(this == that).to be_truthy
  end

  it "are equivalent if their factors are equivalent" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)
    l = Measures::Dimension::Base.new(symbol: :L, system: system)
    this_factor = Measures::Dimension::Term.new(base: m, power: 1)
    that_factor = Measures::Dimension::Term.new(base: l, power: 1)

    this = described_class.new(factors: [this_factor, that_factor])
    that = described_class.new(factors: [that_factor, this_factor])

    expect(this == that).to be_truthy
  end

  it "are NOT equivalent if their factors are different" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)
    l = Measures::Dimension::Base.new(symbol: :L, system: system)
    this_factor = Measures::Dimension::Term.new(base: m, power: 1)
    that_factor = Measures::Dimension::Term.new(base: l, power: 1)

    this = described_class.new(factors: [this_factor])
    that = described_class.new(factors: [that_factor])

    expect(this == that).to be_falsey
  end

  it "adds common factors powers together when two dimensions are multiplied" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_factor = Measures::Dimension::Term.new(base: base_dimension, power: 1)
    that_factor = Measures::Dimension::Term.new(base: base_dimension, power: 1)

    this = described_class.new(factors: [this_factor])
    that = described_class.new(factors: [that_factor])

    result = this * that
    expect(result.factors.count).to eq(1)
    expect(result.factors.first.base).to eq(base_dimension)
    expect(result.factors.first.power).to eq(2)
  end

  it "removes factors whose new power is 0" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_factor = Measures::Dimension::Term.new(base: base_dimension, power: 1)
    that_factor = Measures::Dimension::Term.new(base: base_dimension, power: -1)

    this = described_class.new(factors: [this_factor])
    that = described_class.new(factors: [that_factor])

    result = this * that
    expect(result.factors.count).to eq(0)
    expect(result.factors).to eq([])
  end

  it "adds common factors powers together when two dimensions are multiplied" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    that_base_dimension = Measures::Dimension::Base.new(symbol: :L, system: system)
    this_factor = Measures::Dimension::Term.new(base: this_base_dimension, power: 1)
    that_factor = Measures::Dimension::Term.new(base: that_base_dimension, power: 1)

    this = described_class.new(factors: [this_factor])
    that = described_class.new(factors: [that_factor])

    result = this * that
    expect(result.factors.count).to eq(2)
    expect(result.factors).to include(this_factor)
    expect(result.factors).to include(that_factor)
  end

  it "subtracts common factors powers' together when two dimensions are divided" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    that_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_factor = Measures::Dimension::Term.new(base: this_base_dimension, power: 2)
    that_factor = Measures::Dimension::Term.new(base: that_base_dimension, power: 1)

    this = described_class.new(factors: [this_factor])
    that = described_class.new(factors: [that_factor])

    result = this / that
    expect(result.factors.count).to eq(1)
    expect(result.factors).to eq(that.factors)
  end

  it "subtracts common factors powers' together when two dimensions are divided" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    that_base_dimension = Measures::Dimension::Base.new(symbol: :L, system: system)
    this_factor = Measures::Dimension::Term.new(base: this_base_dimension, power: 1)
    that_factor = Measures::Dimension::Term.new(base: that_base_dimension, power: 1)

    this = described_class.new(factors: [this_factor])
    that = described_class.new(factors: [that_factor])

    result = this / that
    expect(result.factors.count).to eq(2)
  end

  it "is a base dimension if it only hase one factor with a power of 1" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    that_base_dimension = Measures::Dimension::Base.new(symbol: :L, system: system)
    this_factor = Measures::Dimension::Term.new(base: this_base_dimension, power: 1)
    that_factor = Measures::Dimension::Term.new(base: that_base_dimension, power: 1)

    this = described_class.new(factors: [this_factor])
    that = described_class.new(factors: [that_factor])

    result = this / that
    expect(this.base?).to be_truthy
    expect(that.base?).to be_truthy
    expect(result.base?).to be_falsey
  end
end
