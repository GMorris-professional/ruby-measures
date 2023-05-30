# frozen_string_literal: true

module Measures
  class Quantity
    include ActiveModel::Validations

    attr_reader :dimension, :kind, :system

    validates :dimension, presence: true
    validates :kind, presence: true
    validates :system, presence: true

    def initialize(options = {})
      @dimension = options[:dimension]
      @kind = options[:kind]
      @system = options[:system]
      validate!
    end

    delegate :base?, to: :dimension

    def dimension(*_args, &block)
      @dimension.instance_eval(&block) if block_given?
      @dimension
    end

    def commensurable_with?(other)
      dimension == other.dimension
    end
  end
end
