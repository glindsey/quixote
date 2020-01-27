# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for questions.
  class Question < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def _process(input:, output: [], **args)
        fail("#{self.class} has not yet been implemented", **args)
      end
    end
  end
end
