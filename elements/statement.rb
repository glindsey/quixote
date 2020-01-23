# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for statements.
  class Statement < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(input, output, **_args)
        # TODO: lots of work to be done here
        # A statement should be in the form:
        # [subject clause] [verb clause] [object clause]
        # There are other possibilities but we're focusing on this right now.
        # Try to determine a subject clause.
        subject_clause, input, success = SubjectClause.process(input, output, **args)
        verb_clause, input, success = VerbClause.process(input, output, **args)
        object_clause, input, success = ObjectClause.process(input, output, **args)

        [[subject_clause, verb_clause, object_clause], input, success]
      end
    end
  end
end
