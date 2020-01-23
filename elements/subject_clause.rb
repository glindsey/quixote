# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for subject clauses.
  class SubjectClause < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(input, output, **_args)
        # TODO: we'll come back to this
      end
    end
  end
end
