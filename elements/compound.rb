# frozen_string_literal: true

require_relative 'element'

require_relative 'compound_and'
require_relative 'compound_or'

module Elements
  # Processor for compound items (and/or).
  class Compound < Element
    class << self
      # Process I/O stacks. Returns hash containing input/output/success keys.
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

