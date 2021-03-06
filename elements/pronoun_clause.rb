# frozen_string_literal: true

require_relative 'element'

require_relative '../mixins/unimplemented_element'

module Elements
  # Processor for pronoun clauses.
  class PronounClause < Element
    extend Mixins::UnimplementedElement
  end
end
