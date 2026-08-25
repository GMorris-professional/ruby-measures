# Ruby::Measures

An ontology-based, system-agnostic units of measurement engine for Ruby.

Most units libraries ship a hard-coded table of units and a matrix of conversion factors between
them. `Ruby::Measures` takes the opposite approach: it models the *ontology* of measurement itself —
dimensions, quantities, units, prefixes and systems as first-class objects — and lets conversion and
commensurability fall out of that structure. SI is not privileged; it is just one system you can
define, alongside imperial, US customary, nautical, historical, or a domain-specific system of your
own invention.

The vocabulary deliberately follows [OM, the Ontology of Units of
Measure](http://www.ontology-of-units-of-measure.org/resource/om-2/): a `Measure` is a *numerical
value* paired with a *unit*, a `Unit` realises a `Quantity`, a `Quantity` has a `Dimension`, and two
quantities are *commensurable* when their dimensions agree.

## The ontology

| Concept | Class | Description |
| --- | --- | --- |
| Base dimension | `Measures::Dimension::Base` | An irreducible dimension of a system, e.g. `:L`, `:M`, `:T`. |
| Dimension | `Measures::Dimension` | A product of base dimensions raised to powers, e.g. `L³` or `M·L⁻³`. Closed under `*` and `/`. |
| Quantity | `Measures::Quantity` | A *kind* of measurable thing (`:length`, `:volume`, `:density`) carrying a dimension. |
| Unit | `Measures::Unit` | A reference magnitude for a quantity, with a symbol, aliases, an optional prefix and a scaling factor. |
| Prefix | `Measures::Unit::Prefix` | A decimal (or arbitrary) multiplier applied to a unit — `centi`, `kilo`, … |
| Measure | `Measures::Measure` | A numerical value in a unit. This is the thing you actually convert. |
| System of units | `Measures::SystemOfUnits::Base` | A named namespace owning its base dimensions, quantities, units and prefixes. |

Two consequences of modelling it this way:

- **Dimensional analysis is structural.** `length * length * length` *is* volume; you never register
  a `volume` unit against a `length` unit. `Quantity#commensurable_with?` compares dimensions, so
  converting metres to litres is rejected because the dimensions differ, not because someone
  remembered to forbid it.
- **Systems are closed.** `Unit#commensurable_with?` also requires both units to belong to the same
  system, so units from unrelated systems never silently interconvert.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ruby-measures

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ruby-measures

## Usage

### Building a system

Every object belongs to a system, so start there.

```ruby
require "measures"

si = Measures::SystemOfUnits::Base.new(name: :si)
```

### Base dimensions and dimensions

```ruby
length_base = Measures::Dimension::Base.new(symbol: :L, system: si)
mass_base   = Measures::Dimension::Base.new(symbol: :M, system: si)

length  = Measures::Dimension.new(terms: { length_base => 1 }, system: si)
volume  = length * length * length
density = Measures::Dimension.new(terms: { mass_base => 1 }, system: si) / volume

length.base?   # => true
volume.terms   # => { L => 3 }
density.terms  # => { M => 1, L => -3 }
```

Dimensions are values: `Dimension#==` compares terms, so any two `L³` dimensions are equal
regardless of how they were derived.

### Quantities

```ruby
length_quantity = Measures::Quantity.new(dimension: length, kind: :length, system: si)
volume_quantity = Measures::Quantity.new(dimension: volume, kind: :volume, system: si)

length_quantity.base?                                   # => true
length_quantity.commensurable_with?(volume_quantity)    # => false
```

### Prefixes and units

A unit is a quantity plus a symbol, aliases, an optional prefix and a scaling `factor`. Units without
a prefix get `Prefix.null` (scaling factor `1`).

```ruby
centi = Measures::Unit::Prefix.new(symbol: :c, full_description: "centi", scaling_factor: 0.01)

meter      = Measures::Unit.new(quantity: length_quantity, symbol: :m,  aliases: [:m, :meter], system: si)
centimeter = Measures::Unit.new(quantity: length_quantity, symbol: :cm, aliases: [:cm],
                                prefix: centi, system: si)

meter.commensurable_with?(centimeter)   # => true
```

Derive a new unit from an existing one with `scaled_by` — this is how you express a unit defined in
terms of another, rather than in terms of the system's base:

```ruby
inch = centimeter.scaled_by(2.54)       # an inch is 2.54 centimetres

inch.conversion_factor(centimeter)      # => 2.54
centimeter.conversion_factor(meter)     # => 0.01
```

`remove_prefix` folds a prefix into the scaling factor, giving an equivalent prefix-free unit:

```ruby
centimeter.remove_prefix.factor         # => 0.01
```

### Measures and conversion

```ruby
two_inches = Measures::Measure.new(numerical_value: 2, unit: inch)

result = two_inches.to(centimeter)
result.numerical_value                  # => 5.08
result.unit.symbol                      # => :cm
```

Converting between incommensurable units raises rather than returning a wrong answer:

```ruby
Measures::Measure.new(numerical_value: 1, unit: meter).to(some_mass_unit)
# => StandardError: This unit is not commensurable with ...
```

**Precision.** `Unit#conversion_factor` rounds to 3 decimal places by default, which silently loses
significant figures when the two units differ by orders of magnitude. Pass `precision:` for these
cases:

```ruby
one_inch = Measures::Measure.new(numerical_value: 1, unit: inch)

one_inch.to(meter).numerical_value                  # => 0.025    (rounded at 3 dp)
one_inch.to(meter, precision: 12).numerical_value   # => 0.0254
```

**Numerical values must be positive.** `Measure` currently rejects zero and negative values with
`Measures::Errors::NumericalValueNotPositive`.

## Status

The object model above — dimensions, quantities, units, prefixes, measures, conversion and
commensurability — is implemented and covered by specs.

The declarative DSL is **not yet wired up**. The intent is that you will be able to describe a whole
system declaratively, with definitions spread across as many files as you like:

```ruby
class Units
  include SystemOfUnits

  system_of_units :international_standard do
    unit :meter do
      aliases :m
      quantity :length
      symbol :m
    end
  end
end
```

The classes under `lib/measures/international_standard/` are written against this DSL, but
`Measures::Builders::SystemOfUnitsBuilder` still has stub methods, so the declarations register
nothing today:

```ruby
Measures::SystemOfUnits.international_standard.units   # => {}
```

Until that lands, build systems with the direct object API shown under [Usage](#usage). Wiring the
builders to `SystemOfUnits::Base` is the next milestone, followed by a first-class SI definition.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Run `rake` for the default task (specs plus RuboCop), and `rake documentation` to generate RDoc into `doc/`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/GMorris-professional/ruby-measures. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/GMorris-professional/ruby-measures/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby::Measures project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/GMorris-professional/ruby-measures/blob/master/CODE_OF_CONDUCT.md).
