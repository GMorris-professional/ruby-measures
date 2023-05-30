# frozen_string_literal: true

module Measures
  class Unit
    include ActiveModel::Validations

    attr_reader :quantity, :symbol, :aliases, :system, :prefix, :factor

    validates :quantity, presence: true
    validates :symbol, presence: true
    validates :aliases, presence: true
    validates :system, presence: true
    validates :prefix, presence: true
    validates :factor, numericality: { greater_than: 0 }

    def initialize(options = {})
      @quantity = options[:quantity]
      @symbol = options[:symbol]
      @aliases = options[:aliases]
      @system = options[:system]
      @prefix = options[:prefix] || Measures::Unit::Prefix.null
      @factor = options[:factor] || 1
      validate!
    end

    delegate :base?, to: :quantity
    delegate :scaling_factor, to: :prefix, prefix: true

    def ==(other)
      quantity == other.quantity &&
        symbol == other.symbol &&
        aliases == other.aliases &&
        prefix == other.prefix &&
        factor == other.factor &&
        system == other.system
    end

    def commensurable_with?(other_unit)
      quantity.commensurable_with?(other_unit.quantity) &&
        system == other_unit.system
    end

    def scaled_by(factor)
      self.class.new(quantity: quantity,
                     prefix: prefix,
                     symbol: symbol,
                     aliases: aliases,
                     factor: factor,
                     system: system)
    end

    def to(other_unit)
      raise StandardError, "This unit is not commensurable with #{other_unit}" unless commensurable_with?(other_unit)

      self.class.new(quantity: other_unit.quantity,
                     symbol: other_unit.symbol,
                     prefix: other_unit.prefix,
                     aliases: other_unit.aliases,
                     factor: other_unit.factor,
                     system: other_unit.system)
    end

    def conversion_factor(other_unit, **options)
      precision = options[:precision] || 3
      numerator = factor * prefix.scaling_factor
      denominator = other_unit.factor * other_unit.prefix_scaling_factor
      (numerator / denominator).round(precision)
    end

    def remove_prefix
      self.class.new(quantity: quantity,
                     symbol: symbol,
                     aliases: aliases,
                     factor: factor * prefix.scaling_factor,
                     system: system)
    end
  end
end
