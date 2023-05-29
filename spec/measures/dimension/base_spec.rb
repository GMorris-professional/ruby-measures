# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Dimension::Base do
  context "when condition" do
    it "requires a symbol and a system" do
      expect do
        described_class.new
      end.to raise_error(ActiveModel::ValidationError,
                         "Validation failed: Symbol can't be blank, System can't be blank")
    end

    it "is equivalent to another if they share the same symbol" do
      system = Measures::SystemOfUnits::Base.new(name: "test")
      this = described_class.new(symbol: :M, system: system)
      that = described_class.new(symbol: :M, system: system)

      expect(this == that).to be_truthy
    end
  end
end
