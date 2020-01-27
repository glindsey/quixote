# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for commands.
  class Command < Processor
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def _process(input:, output: [], **args)
        fail("#{self.class} has not yet been implemented",
             input: input, output: output, **args)
      end
    end
  end
end
