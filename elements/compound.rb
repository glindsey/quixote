# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for compound items (and/or).
  class Sentence < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def _process(input:, output: [], **args)
        # Try parsing as either a compound 'and' or a compound 'or'.
        try(
          handlers: [CompoundAnd, CompoundOr],
          input: input, output: output, **args
        )
      end
    end
  end
end

