# frozen_string_literal: true

require_relative 'element'

require_relative '../mixins/unimplemented_element'

module Elements
  # Processor for prepositional noun phrases.
  class PrepNounPhrase < Element
    extend Mixins::UnimplementedElement
  end
end
