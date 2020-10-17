require "./example_context_delegate"
require "./example_group"
require "./example_node"
require "./result"
require "./source"

module Spectator
  # Standard example that runs a test case.
  class Example < ExampleNode
    # Indicates whether the example already ran.
    getter? finished : Bool = false

    # Retrieves the result of the last time the example ran.
    # TODO: Make result not nil and default to pending.
    getter! result : Result

    # Creates the example.
    # The *delegate* contains the test context and method that runs the test case.
    # The *name* describes the purpose of the example.
    # It can be a `Symbol` to describe a type.
    # The *source* tracks where the example exists in source code.
    # The example will be assigned to *group* if it is provided.
    def initialize(@delegate : ExampleContextDelegate,
                   name : String? = nil, source : Source? = nil, group : ExampleGroup? = nil)
      super(name, source, group)
    end

    # Executes the test case.
    # Returns the result of the execution.
    # The result will also be stored in `#result`.
    def run : Result
      Log.debug { "Running example #{self}" }
      @delegate.call(self)
      raise NotImplementedError.new("#run")
    end

    # Exposes information about the example useful for debugging.
    def inspect(io)
      # Full example name.
      io << '"'
      to_s(io)
      io << '"'

      # Add source if it's available.
      if (s = source)
        io << " @ "
        io << s
      end

      # TODO: Add result.
    end
  end
end
