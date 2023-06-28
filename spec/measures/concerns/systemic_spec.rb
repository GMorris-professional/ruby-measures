# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe "Measures::Concerns::Systemic" do
  class SystemicThing
    include Measures::Concerns::Systemic
  end

  context "when included" do
    it "requires  a system" do
      expect { SystemicThing.new({}) }.to raise_error(Measures::Errors::NoSystem)
    end
  end
end
