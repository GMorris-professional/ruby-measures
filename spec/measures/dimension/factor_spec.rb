# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Dimension::Factor do
  it "is equivalent to another if they have the same base and powe" do
    base_dimension = :M
    this = described_class.new(base: base_dimension)
    that = described_class.new(base: base_dimension)

    expect(this == that).to be_truthy
  end

  it "is NOT equivalent to another if they have different powers" do
    this = described_class.new(base: :M)
    that = described_class.new(base: :M, power: 2)

    expect(this == that).to be_falsey
  end

  it "is NOT equivalent to another if they have the different bases" do
    this = described_class.new(base: :M)
    that = described_class.new(base: :L)

    expect(this == that).to be_falsey
  end

  it "can use a base dimension" do
    base_dimension = instance_double(Measures::Dimension::Base, symbol: :M)
    this = described_class.new(base: base_dimension)
    that = described_class.new(base: base_dimension)

    expect(this == that).to be_truthy
  end

  it "can be multiplied by another factor with the same base " do
    this = described_class.new(base: :M)
    that = described_class.new(base: :M)

    result = this * that
    expect(result.base).to eq(this.base)
    expect(result.power).to eq(2)
  end

  it "CANNOT be multiplied by another factor with the same base " do
    this = described_class.new(base: :M)
    that = described_class.new(base: :L)

    expect { this * that }.to raise_error(StandardError, "Can't combine two factors with different bases")
  end

  it "can be divided by another factor with the same base " do
    this = described_class.new(base: :M)
    that = described_class.new(base: :M)

    result = this / that
    expect(result.base).to eq(this.base)
    expect(result.power).to eq(0)
  end

  it "CANNOT be divided by another factor with the same base " do
    this = described_class.new(base: :M)
    that = described_class.new(base: :L)

    expect { this / that }.to raise_error(StandardError, "Can't combine two factors with different bases")
  end
end
