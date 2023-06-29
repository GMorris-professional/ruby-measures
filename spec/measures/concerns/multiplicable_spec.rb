# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Measures::Concerns::Multiplicable do
  class Term
    include Measures::Concerns::Multiplicable
  end

  context "when included by a class" do
    it "has terms" do
      multiplicable_term = Term.new(terms: { "test": 1 })
      expect(multiplicable_term.terms).to eq({ "test": 1 })
    end

    it "has inverted terms" do
      multiplicable_term = Term.new(terms: { "test": 1 })
      expect(multiplicable_term.inverted_terms).to eq({ "test": -1 })
    end

    it "can be multiplied with another multiplicable" do
      this_multiplicable_term = Term.new(terms: { "some_term": 1 })
      that_multiplicable_term = Term.new(terms: { "some_term": 1 })
      expect(this_multiplicable_term * that_multiplicable_term).to eq({ "some_term": 2 })
    end

    it "can be multiplied with another multiplicable" do
      this_multiplicable_term = Term.new(terms: { "some_term": 1 })
      that_multiplicable_term = Term.new(terms: { "some_other_term": 1 })
      expect(this_multiplicable_term * that_multiplicable_term).to eq({ "some_term": 1, "some_other_term": 1 })
    end

    it "can be multiplied with another multiplicable" do
      this_multiplicable_term = Term.new(terms: { "some_term": 1 })
      that_multiplicable_term = Term.new(terms: { "some_term": 1, "some_other_term": 1 })
      expect(this_multiplicable_term * that_multiplicable_term).to eq({ "some_term": 2, "some_other_term": 1 })
    end

    it "can be divided with another multiplicable" do
      this_multiplicable_term = Term.new(terms: { "some_term": 1 })
      that_multiplicable_term = Term.new(terms: { "some_term": 1, "some_other_term": 1 })
      expect(this_multiplicable_term / that_multiplicable_term).to eq({ "some_term": 0, "some_other_term": -1 })
    end
  end
end
