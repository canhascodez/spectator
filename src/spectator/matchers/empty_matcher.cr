require "./matcher"

module Spectator::Matchers
  # Matcher that tests whether a collection is empty.
  # The values are checked with the `empty?` method.
  struct EmptyMatcher < Matcher
    private def match?(actual)
      actual.value.empty?
    end

    def description
      "is empty"
    end

    private def failure_message(actual)
      "#{actual.label} is not empty"
    end

    private def failure_message_when_negated(actual)
      "#{actual.label} is empty"
    end

    private def values(actual) : Array(LabeledValue)
      [LabeledValue.new(actual.value.inspect, "actual")]
    end
  end
end
