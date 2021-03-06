# frozen_string_literal: true

require_relative 'element'

require_relative '../mixins/unimplemented_element'

module Elements
  # Processor for commands.
  class Command < Element
    extend Mixins::UnimplementedElement
  end
end
