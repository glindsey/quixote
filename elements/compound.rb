# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for compound items (and/or).
  class Sentence < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(input, _output, **_args)
        # Try parsing as either a compound 'and' or a compound 'or'.
        CompoundAnd.process(input, output, **args) ||
          CompoundOr.process(input, output, **args)
      end
    end
  end
end

