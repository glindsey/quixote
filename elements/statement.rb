# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for statements.
  class Statement < Element
    # TODO: lots of work to be done here
    # A statement should be in the form:
    # [subject clause] [verb clause] [object clause]
    # There are other possibilities but we're focusing on this right now.
    extend Mixins::UnimplementedElement
  end
end
