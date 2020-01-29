# frozen_string_literal: true

require_relative 'element'

require_relative 'subject_clause'
require_relative 'verb_object_clause'

module Elements
  # Processor for statements.
  class Statement < Element
    # TODO: lots of work to be done here
    # A statement should be in the form:
    # [subject clause] [verb-object clause]
    # There are other possibilities but we're focusing on this right now.

    # Process I/O stacks. Returns hash containing tape, success keys.
    def _process(tape:, **args)

      result = in_order([SubjectClause, VerbObjectClause], tape: tape, **args)

      return fail(tape: tape) unless result.succeeded

      succeed(
        tape: tape,
        output: Statement.new(
          subject: result[:output][0],
          verb_object: result[:output][1]
        )
      )
    end
  end
end
