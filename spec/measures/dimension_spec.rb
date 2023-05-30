# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Dimension do
  it "are equivalent if their terms are equivalent" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_term = Measures::Dimension::Term.new(base: base_dimension, power: 1)
    that_term = Measures::Dimension::Term.new(base: base_dimension, power: 1)

    this = described_class.new(terms: [this_term])
    that = described_class.new(terms: [that_term])

    expect(this == that).to be_truthy
  end

  it "are equivalent if their terms are equivalent" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)
    l = Measures::Dimension::Base.new(symbol: :L, system: system)
    this_term = Measures::Dimension::Term.new(base: m, power: 1)
    that_term = Measures::Dimension::Term.new(base: l, power: 1)

    this = described_class.new(terms: [this_term, that_term])
    that = described_class.new(terms: [that_term, this_term])

    expect(this == that).to be_truthy
  end

  it "are NOT equivalent if their terms are different" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)
    l = Measures::Dimension::Base.new(symbol: :L, system: system)
    this_term = Measures::Dimension::Term.new(base: m, power: 1)
    that_term = Measures::Dimension::Term.new(base: l, power: 1)

    this = described_class.new(terms: [this_term])
    that = described_class.new(terms: [that_term])

    expect(this == that).to be_falsey
  end

  it "adds common terms powers together when two dimensions are multiplied" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_term = Measures::Dimension::Term.new(base: base_dimension, power: 1)
    that_term = Measures::Dimension::Term.new(base: base_dimension, power: 1)

    this = described_class.new(terms: [this_term])
    that = described_class.new(terms: [that_term])

    result = this * that
    expect(result.terms.count).to eq(1)
    expect(result.terms.first.base).to eq(base_dimension)
    expect(result.terms.first.power).to eq(2)
  end

  it "removes terms whose new power is 0" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_term = Measures::Dimension::Term.new(base: base_dimension, power: 1)
    that_term = Measures::Dimension::Term.new(base: base_dimension, power: -1)

    this = described_class.new(terms: [this_term])
    that = described_class.new(terms: [that_term])

    result = this * that
    expect(result.terms.count).to eq(0)
    expect(result.terms).to eq([])
  end

  it "adds common terms powers together when two dimensions are multiplied" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    that_base_dimension = Measures::Dimension::Base.new(symbol: :L, system: system)
    this_term = Measures::Dimension::Term.new(base: this_base_dimension, power: 1)
    that_term = Measures::Dimension::Term.new(base: that_base_dimension, power: 1)

    this = described_class.new(terms: [this_term])
    that = described_class.new(terms: [that_term])

    result = this * that
    expect(result.terms.count).to eq(2)
    expect(result.terms).to include(this_term)
    expect(result.terms).to include(that_term)
  end

  it "subtracts common terms powers' together when two dimensions are divided" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    that_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_term = Measures::Dimension::Term.new(base: this_base_dimension, power: 2)
    that_term = Measures::Dimension::Term.new(base: that_base_dimension, power: 1)

    this = described_class.new(terms: [this_term])
    that = described_class.new(terms: [that_term])

    result = this / that
    expect(result.terms.count).to eq(1)
    expect(result.terms).to eq(that.terms)
  end

  it "subtracts common terms powers' together when two dimensions are divided" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    that_base_dimension = Measures::Dimension::Base.new(symbol: :L, system: system)
    this_term = Measures::Dimension::Term.new(base: this_base_dimension, power: 1)
    that_term = Measures::Dimension::Term.new(base: that_base_dimension, power: 1)

    this = described_class.new(terms: [this_term])
    that = described_class.new(terms: [that_term])

    result = this / that
    expect(result.terms.count).to eq(2)
  end

  it "is a base dimension if it only hase one factor with a power of 1" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    that_base_dimension = Measures::Dimension::Base.new(symbol: :L, system: system)
    this_term = Measures::Dimension::Term.new(base: this_base_dimension, power: 1)
    that_term = Measures::Dimension::Term.new(base: that_base_dimension, power: 1)

    this = described_class.new(terms: [this_term])
    that = described_class.new(terms: [that_term])

    result = this / that
    expect(this.base?).to be_truthy
    expect(that.base?).to be_truthy
    expect(result.base?).to be_falsey
  end
end
