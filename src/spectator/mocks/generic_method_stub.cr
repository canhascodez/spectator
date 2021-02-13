require "./arguments"
require "./generic_arguments"
require "./method_call"
require "./method_stub"

module Spectator::Mocks
  abstract class GenericMethodStub(ReturnType) < MethodStub
    getter! arguments : Arguments

    def initialize(name, location, @args : Arguments? = nil)
      super(name, location)
    end

    def callable?(call : MethodCall) : Bool
      super && (!@args || @args === call.args)
    end

    def to_s(io)
      super(io)
      if @args
        io << '('
        io << @args
        io << ')'
      end
      io << " : "
      io << ReturnType
      io << " at "
      io << @location
    end
  end
end
