# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Unit::Prefix do
  it "requires a symbol, a full representation, and a scaling factor" do
    expect { Measures::Unit::Prefix.new({}) }.to raise_error(Measures::Errors::NoSymbol)
    expect { Measures::Unit::Prefix.new({ symbol: :test }) }.to raise_error(Measures::Errors::NoFullDescription)
  end
end
