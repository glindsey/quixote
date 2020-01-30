# frozen_string_literal: true

require_relative 'element'

require_relative '../mixins/unimplemented_element'

module Elements
  # Processor for gerund clauses.
  class GerundClause < Element
    extend Mixins::UnimplementedElement
  end
end
