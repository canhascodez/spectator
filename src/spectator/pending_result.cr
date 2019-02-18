require "./result"

module Spectator
  # Outcome that indicates running an example was pending.
  # A pending result means the example is not ready to run yet.
  # This can happen when the functionality to be tested is not implemented yet.
  class PendingResult < Result
    # Calls the `pending` method on *interface* and passes self.
    def call(interface)
      interface.pending(self)
    end
  end
end
