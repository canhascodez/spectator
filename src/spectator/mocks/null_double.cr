require "./arguments"
require "./method_call"
require "./stub"
require "./stubbable"
require "./stubbed_name"
require "./unexpected_message"
require "./value_stub"

module Spectator
  # Stands in for an object for testing that a SUT calls expected methods.
  #
  # Handles all messages (method calls), but only responds to those configured.
  # Methods called that were not configured will return self.
  # Doubles should be defined with the `#define` macro.
  #
  # Use `#_spectator_define_stub` to override behavior of a method in the double.
  # Only methods defined in the double's type can have stubs.
  # New methods are not defines when a stub is added that doesn't have a matching method name.
  abstract class NullDouble
    include Stubbable

    Log = Spectator::Log.for(self)

    # Defines a test double type.
    #
    # The *type_name* is the name to give the class.
    # Instances of the double can be named by providing a *name*.
    # This can be a symbol, string, or even a type.
    # See `StubbedName` for details.
    #
    # After the names, a collection of key-value pairs can be given to quickly define methods.
    # Each key is the method name, and the corresponding value is the value returned by the method.
    # These methods accept any arguments.
    # Additionally, these methods can be overridden later with stubs.
    #
    # Lastly, a block can be provided to define additional methods and stubs.
    # The block is evaluated in the context of the double's class.
    #
    # ```
    # Double.define(SomeDouble, meth1: 42, meth2: "foobar") do
    #   stub abstract def meth3 : Symbol
    # end
    # ```
    macro define(type_name, name = nil, **value_methods, &block)
      {% if name %}@[::Spectator::StubbedName({{name}})]{% end %}
      class {{type_name.id}} < {{@type.name}}
        {% for key, value in value_methods %}
          inject_stub def {{key.id}}(*%args, **%kwargs)
            {{value}}
          end
        {% end %}
        {% if block %}{{block.body}}{% end %}
      end
    end

    # Creates the double.
    #
    # An initial set of *stubs* can be provided.
    def initialize(@stubs : Array(Stub) = [] of Stub)
    end

    # Defines a stub to change the behavior of a method in this double.
    #
    # NOTE: Defining a stub for a method not defined in the double's type has no effect.
    protected def _spectator_define_stub(stub : Stub) : Nil
      @stubs.unshift(stub)
    end

    private def _spectator_find_stub(call : MethodCall) : Stub?
      Log.debug { "Finding stub for #{call}" }
      stub = @stubs.find &.===(call)
      Log.debug { stub ? "Found stub #{stub} for #{call}" : "Did not find stub for #{call}, returning self" }
      stub
    end

    # Returns the double's name formatted for user output.
    private def _spectator_stubbed_name : String
      {% if anno = @type.annotation(StubbedName) %}
        "#<NullDouble " + {{(anno[0] || :Anonymous.id).stringify}} + ">"
      {% else %}
        "#<NullDouble Anonymous>"
      {% end %}
    end

    private def _spectator_stub_fallback(call : MethodCall, &)
      self
    end

    private def _spectator_stub_fallback(call : MethodCall, type : self, &)
      self
    end

    private def _spectator_stub_fallback(call : MethodCall, type, &)
      yield
    end

    private def _spectator_abstract_stub_fallback(call : MethodCall)
      self
    end

    private def _spectator_abstract_stub_fallback(call : MethodCall, type : self)
      self
    end

    private def _spectator_abstract_stub_fallback(call : MethodCall, type)
      raise TypeCastError.new("#{_spectator_stubbed_name} received message #{call} and is attempting to return `self`, but returned type must be `#{type}`.")
    end

    # "Hide" existing methods and methods from ancestors by overriding them.
    macro finished
      stub_all {{@type.name(generic_args: false)}}
    end

    # Handle all methods but only respond to configured messages.
    # Returns self.
    macro method_missing(_call)
      self
    end
  end
end
