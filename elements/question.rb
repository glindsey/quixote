# frozen_string_literal: true

require_relative 'element'

require_relative '../mixins/unimplemented_element'

module Elements
  # Processor for questions.
  class Question < Element
    extend Mixins::UnimplementedElement
  end
end
