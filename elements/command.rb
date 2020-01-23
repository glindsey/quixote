# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for commands.
  class Command < Processor
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(_input, _output, **_args)
        raise NotImplementedError, 'Not yet implemented'
      end
    end
  end
end
