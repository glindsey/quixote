# frozen_string_literal: true

require_relative 'element'

require_relative '../mixins/unimplemented_element'

module Elements
  # Processor for adjectives.
  class Adjective < Element
    extend Mixins::UnimplementedElement
  end
end
