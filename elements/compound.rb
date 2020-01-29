# frozen_string_literal: true

require_relative 'element'

require_relative 'compound_and'
require_relative 'compound_or'

module Elements
  # Processor for compound items (and/or).
  class Compound < Element
    class << self
      # Process I/O stacks. Returns hash containing tape, success keys.
      def _process(tape:, **args)
        # Try parsing as either a compound 'and' or a compound 'or'.
        try(handlers: [CompoundAnd, CompoundOr], tape: tape, **args)
      end
    end
  end
end

