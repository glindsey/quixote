# frozen_string_literal: true

require_relative 'element'

require_relative '../mixins/unimplemented_element'

# TODO: kill this

module Elements
  # Processor for intransitive verb-object clauses.
  # Gonna be:
  # Adverb* IntransitiveVerb ObjectClause PrepAdvPhrase*
  # "quietly eat your sandwich at the table"


  class IntransitiveVerbObjectClause < Element
    extend Mixins::UnimplementedElement
  end
end
