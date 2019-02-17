# Example that always fails.
class FailingExample < Spectator::RunnableExample
  # Dummy description.
  def what
    "FAIL"
  end

  # Dummy source.
  def source
    ::Spectator::Source.new(__FILE__, __LINE__)
  end

  # Dummy symbolic flag.
  def symbolic?
    false
  end

  # Dummy instance.
  def instance
    nil
  end

  # Run the example that always fails.
  private def run_instance
    report_expectations(0, 1)
  end

  # Creates a failing example.
  def self.create
    hooks = Spectator::ExampleHooks.empty
    conditions = Spectator::ExampleConditions.empty
    group = Spectator::RootExampleGroup.new(hooks, conditions)
    values = Spectator::Internals::SampleValues.empty
    new(group, values).tap do |example|
      group.children = [example.as(Spectator::ExampleComponent)]
    end
  end
end
