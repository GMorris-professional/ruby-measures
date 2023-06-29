# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Concerns::Symbolic do
  class SymbolicThing
    include Measures::Concerns::Symbolic
  end

  context "when included" do
    it "requires  a system" do
      expect { SymbolicThing.new({}) }.to raise_error(Measures::Errors::NoSymbol)
    end
  end
end
