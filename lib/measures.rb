# frozen_string_literal: true

require "active_model"

require_relative "measures/version"

require_relative "measures/dimension"
require_relative "measures/dimension/base"
require_relative "measures/dimension/term"

require_relative "measures/quantity"

require_relative "measures/unit"
require_relative "measures/unit/prefix"
require_relative "measures/unit/prefix/builder"
require_relative "measures/unit/builder"

require_relative "measures/system_of_units"
require_relative "measures/system_of_units/store"
require_relative "measures/system_of_units/base"

require_relative "measures/international_standard/base_dimensions"
require_relative "measures/international_standard/quantities"
require_relative "measures/international_standard/units"
require_relative "measures/international_standard/prefixes"

require_relative "measures/measure"

module Ruby
  module Measures
    class Error < StandardError; end
  end
end
