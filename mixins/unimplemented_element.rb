# frozen_string_literal: true

module Mixins
  # Dummy mixin for elements that have not yet been implemented.
  module UnimplementedElement
    # Process the I/O stacks. Returns hash containing input/output/success keys.
    def _process(input:, output: [], **args)
      fail("#{self.class} has not yet been implemented",
           input: input, output: output, **args)
    end
  end
end
