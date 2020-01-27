# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for statements.
  class Statement < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def _process(input:, output: [], **args)
        # TODO: lots of work to be done here
        # A statement should be in the form:
        # [subject clause] [verb clause] [object clause]
        # There are other possibilities but we're focusing on this right now.

        fail("#{self.class}.process has not yet been implemented",
             input: input, output: output, **args)
      end
    end
  end
end
