# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Quantity do
  it "requires a dimension, a kind and a system" do
    expect do
      described_class.new
    end.to raise_error(ActiveModel::ValidationError,
                       "Validation failed: Dimension can't be blank, Kind can't be blank, System can't be blank")
  end

  it "is a base quantity if its dimension is a base dimension" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_factor = Measures::Dimension::Factor.new(base: this_base_dimension, power: 1)

    this_dimension = Measures::Dimension.new(factors: [this_factor], system: system)
    that_dimension = this_dimension * this_dimension

    this = described_class.new(dimension: this_dimension, kind: :test, system: :some_system)
    that = described_class.new(dimension: that_dimension, kind: :test, system: :some_system)

    expect(this.base?).to be_truthy
    expect(that.base?).to be_falsey
  end

  it "commensurable with another quantity if they have the same dimensions" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_factor = Measures::Dimension::Factor.new(base: this_base_dimension, power: 1)

    this_dimension = Measures::Dimension.new(factors: [this_factor], system: system)

    this = described_class.new(dimension: this_dimension, kind: :test, system: :some_system)
    that = described_class.new(dimension: this_dimension, kind: :test, system: :some_system)

    expect(this.commensurable_with?(that)).to be_truthy
  end

  it "commensurable with another quantity if they have the same dimensions" do
    system = Measures::SystemOfUnits::Base.new(name: "test")
    this_base_dimension = Measures::Dimension::Base.new(symbol: :M, system: system)
    this_factor = Measures::Dimension::Factor.new(base: this_base_dimension, power: 1)

    this_dimension = Measures::Dimension.new(factors: [this_factor], system: system)
    that_dimension = this_dimension * this_dimension

    this = described_class.new(dimension: this_dimension, kind: :test, system: :some_system)
    that = described_class.new(dimension: that_dimension, kind: :test, system: :some_system)

    expect(this.commensurable_with?(that)).to be_falsey
  end
end
