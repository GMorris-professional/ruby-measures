# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Unit::Prefix do
  it "requires a symbol, a full representation, and a scaling factor" do
    expect do
      described_class.new
    end.to raise_error(ActiveModel::ValidationError,
                       "Validation failed: Symbol is too short (minimum is 0 characters), Full is too short (minimum is 0 characters), Scaling factor is not a number")
  end
end
