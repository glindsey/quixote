# frozen_string_literal: true

require_relative 'element'

require_relative '../mixins/unimplemented_element'

# TODO: kill this

module Elements
  # Processor for prepositional adjectival phrases.
  class PrepAdjectivalPhrase < Element
    extend Mixins::UnimplementedElement
  end
end
