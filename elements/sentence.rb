# frozen_string_literal: true

require_relative 'element'

require_relative 'statement'
require_relative 'question'
require_relative 'command'

module Elements
  # Processor for whole sentences.
  class Sentence < Element
    class << self
      # Process I/O stacks. Returns hash containing tape, success keys.
      def _process(tape:, **args)
        # Try each of these in order.
        try(handlers: [Statement, Question, Command],
            tape: tape, **args)
      end
    end
  end
end

