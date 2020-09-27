require "../spectator_context"

module Spectator
  # Base class that all test cases run in.
  # This type is used to store all test case contexts as a single type.
  # The instance must be downcast to the correct type before calling a context method.
  #
  # Nested contexts, such as those defined by `context` and `describe` in the DSL, can define their own methods.
  # The intent is that a proc will downcast to the correct type and call one of those methods.
  # This is how methods that contain test cases, hooks, and other context-specific code blocks get invoked.
  alias Context = ::SpectatorContext
end
