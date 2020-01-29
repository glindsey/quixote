# frozen_string_literal: true

module Mixins
  # Dummy mixin for elements that have not yet been implemented.
  module UnimplementedElement
    # Process the I/O stacks. Returns hash containing tape, success keys.
    def _process(tape:, output: [], **args)
      fail("#{self.class} has not yet been implemented", tape: tape)
    end
  end
end
