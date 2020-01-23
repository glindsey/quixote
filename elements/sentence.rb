# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for whole sentences.
  class Sentence < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(input, output, **_args)
        # A sentence can be a Statement or a Question. Let's try each.
        Statement.process(input) || Question.process(input)
      end
    end
  end
end

