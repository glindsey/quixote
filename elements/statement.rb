# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for statements.
  class Statement < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(input, output, **_args)
        # A statement should be in the form:
        # [subject clause] [verb clause] [object clause]
        # There are other possibilities but we're focusing on this right now.
        # Try to determine a subject clause.
        subject_clause, input = SubjectClause.process(input, output, **args)
        verb_clause, input = VerbClause.process(input, output, **args)
        object_clause, input = ObjectClause.process(input, output, **args)

        [[subject_clause, verb_clause, object_clause], input]
      end
    end
  end
end
