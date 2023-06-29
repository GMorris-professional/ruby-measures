# frozen_string_literal: true

require_relative "./concerns/systemic"
require_relative "./errors/no_kind"
require_relative "./errors/no_dimension"

module Measures
  class Quantity
    include Measures::Concerns::Systemic

    attr_reader :dimension, :kind

    def initialize(options)
      @dimension = options[:dimension]
      @kind = options[:kind]
      raise Measures::Errors::NoKind unless @kind
      raise Measures::Errors::NoDimension unless @dimension
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
