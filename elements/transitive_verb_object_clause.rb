# frozen_string_literal: true

require_relative 'element'

require_relative '../mixins/unimplemented_element'

module Elements
  # Processor for transitive verb-object clauses.
  # Gonna be:
  # Adverb* TransitiveVerb ObjectClause PrepAdvPhrase*

  class TransitiveVerbObjectClause < Element
    extend Mixins::UnimplementedElement
  end
end
