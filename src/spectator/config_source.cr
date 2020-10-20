require "./config_builder"

module Spectator
  # Interface for all places that configuration can originate.
  abstract class ConfigSource
    # Applies the specified configuration to a builder.
    # Calling this method from multiple sources builds up the final configuration.
    abstract def apply(builder : ConfigBuilder) : Nil
  end
end
