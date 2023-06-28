# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Dimension do
  it "are equivalent if their terms are equivalent" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)

    this = described_class.new(terms: { base_dimension => 1 })
    that = described_class.new(terms: { base_dimension => 1 })

    expect(this == that).to be_truthy
  end

  it "are equivalent if their terms are equivalent" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)
    l = Measures::Dimension::Base.new(symbol: :L, system: system)

    this = described_class.new(terms: { m => 1, l => 1 })
    that = described_class.new(terms: { m => 1, l => 1 })

    expect(this == that).to be_truthy
  end

  it "are NOT equivalent if their terms are different" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)
    l = Measures::Dimension::Base.new(symbol: :L, system: system)

    this = described_class.new(terms: { m => 1 })
    that = described_class.new(terms: { l => 1 })

    expect(this == that).to be_falsey
  end

  it "adds common terms powers together when two dimensions are multiplied" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)

    this = described_class.new(terms: { m => 1 })
    that = described_class.new(terms: { m => 1 })

    result = this * that
    expect(result.terms).to eq({ m => 2 })
  end

  it "adds common terms powers together when two dimensions are multiplied" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)
    l = Measures::Dimension::Base.new(symbol: :L, system: system)

    this = described_class.new(terms: { m => 1 })
    that = described_class.new(terms: { l => 1 })

    result = this * that
    expect(result.terms).to eq({ m => 1, l => 1 })
  end

  it "subtracts common terms powers' together when two dimensions are divided" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)

    this = described_class.new(terms: { m => 1 })
    that = described_class.new(terms: { m => 1 })

    result = this / that
    expect(result.terms).to eq({ m => 0 })
  end

  it "subtracts common terms powers' together when two dimensions are divided" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)
    l = Measures::Dimension::Base.new(symbol: :L, system: system)

    this = described_class.new(terms: { m => 1 })
    that = described_class.new(terms: { l => 1 })

    result = this / that
    expect(result.terms).to eq({ m => 1, l => -1 })
  end

  it "is a base dimension if it only hase one factor with a power of 1" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    m = Measures::Dimension::Base.new(symbol: :M, system: system)
    l = Measures::Dimension::Base.new(symbol: :L, system: system)

    this = described_class.new(terms: { m => 1 })
    that = described_class.new(terms: { l => 1 })

    result = this / that
    expect(this.base?).to be_truthy
    expect(that.base?).to be_truthy
    expect(result.base?).to be_falsey
  end
end
