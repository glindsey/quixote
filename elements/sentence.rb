# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for whole sentences.
  class Sentence < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def _process(input:, output: [], **args)
        # A sentence can be a Statement, a Question, or a Command.
        # Let's try each.
        try(handlers: [Statement, Question, Command],
            input: input, output: output, **args)
      end
    end
  end
end

