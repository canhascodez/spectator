require "../example_group_hook"
require "../example_hook"
require "../example_procsy_hook"
require "../spec/builder"

module Spectator::DSL
  # Incrementally builds up a test spec from the DSL.
  # This is intended to be used only by the Spectator DSL.
  module Builder
    extend self

    # Underlying spec builder.
    @@builder = Spec::Builder.new

    # Defines a new example group and pushes it onto the group stack.
    # Examples and groups defined after calling this method will be nested under the new group.
    # The group will be finished and popped off the stack when `#end_example` is called.
    #
    # See `Spec::Builder#start_group` for usage details.
    def start_group(*args)
      @@builder.start_group(*args)
    end

    # Completes a previously defined example group and pops it off the group stack.
    # Be sure to call `#start_group` and `#end_group` symmetically.
    #
    # See `Spec::Builder#end_group` for usage details.
    def end_group(*args)
      @@builder.end_group(*args)
    end

    # Defines a new example.
    # The example is added to the group currently on the top of the stack.
    #
    # See `Spec::Builder#add_example` for usage details.
    def add_example(*args, &block : Example ->)
      @@builder.add_example(*args, &block)
    end

    # Defines a block of code to execute before any and all examples in the current group.
    def before_all(location = nil, label = "before_all", &block)
      hook = ExampleGroupHook.new(location: location, label: label, &block)
      @@builder.before_all(hook)
    end

    # Defines a block of code to execute before every example in the current group
    def before_each(location = nil, label = "before_each", &block : Example -> _)
      hook = ExampleHook.new(location: location, label: label, &block)
      @@builder.before_each(hook)
    end

    # Defines a block of code to execute after any and all examples in the current group.
    def after_all(location = nil, label = "after_all", &block)
      hook = ExampleGroupHook.new(location: location, label: label, &block)
      @@builder.after_all(hook)
    end

    # Defines a block of code to execute after every example in the current group.
    def after_each(location = nil, label = "after_each", &block : Example ->)
      hook = ExampleHook.new(location: location, label: label, &block)
      @@builder.after_each(hook)
    end

    # Defines a block of code to execute around every example in the current group.
    def around_each(location = nil, label = "around_each", &block : Example::Procsy ->)
      hook = ExampleProcsyHook.new(location: location, label: label, &block)
      @@builder.around_each(hook)
    end

    # Sets the configuration of the spec.
    #
    # See `Spec::Builder#config=` for usage details.
    def config=(config)
      @@builder.config = config
    end

    # Constructs the test spec.
    # Returns the spec instance.
    #
    # Raises an error if there were not symmetrical calls to `#start_group` and `#end_group`.
    # This would indicate a logical error somewhere in Spectator or an extension of it.
    def build : Spec
      @@builder.build
    end
  end
end
