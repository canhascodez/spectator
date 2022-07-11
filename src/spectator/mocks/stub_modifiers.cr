require "./arguments"

module Spectator
  # Mixin intended for `Stub` to return new, modified stubs.
  module StubModifiers
    # Returns a new stub of the same type with constrained arguments.
    abstract def with(constraint : AbstractArguments)

    # :ditto:
    def with(*args, **kwargs)
      constraint = Arguments.new(args, kwargs)
      self.with(constraint)
    end
  end
end
