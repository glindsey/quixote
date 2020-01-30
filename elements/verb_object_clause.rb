# frozen_string_literal: true

require_relative 'element'

require_relative 'transitive_verb_object_clause'
require_relative 'intransitive_verb_object_clause'

module Elements
  # Processor for verb-object clauses.
  class VerbObjectClause < Element
    class << self
      # Process I/O stacks. Returns hash containing tape, success keys.
      def _process(tape:, **args)
        # Try each of these in order.
        try(
          handlers: [
            TransitiveVerbObjectClause,
            IntransitiveVerbObjectClause
          ],
          tape: tape, **args
        )
      end
    end
  end
end
