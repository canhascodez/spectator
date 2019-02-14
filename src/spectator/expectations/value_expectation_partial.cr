require "./expectation_partial"

module Spectator::Expectations
  # Expectation partial variation that operates on a value.
  struct ValueExpectationPartial(ActualType) < ExpectationPartial
    # Actual value produced by the test.
    # This is the value passed to the `#expect` call.
    getter actual

    # Creates the expectation partial.
    # The label should be a string representation of the actual value.
    # The actual value is stored for later use.
    protected def initialize(@actual : ActualType, label, source_file, source_line)
      super(label, source_file, source_line)
    end

    # Creates the expectation partial.
    # The label is generated by calling `#to_s` on the actual value.
    # The actual value is stored for later use.
    protected def initialize(@actual : ActualType, source_file, source_line)
      super(@actual.to_s, source_file, source_line)
    end
  end
end
