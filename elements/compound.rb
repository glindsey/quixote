# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for compound items (and/or).
  class Sentence < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(input, _output, **_args)
        # Try parsing as either a compound 'and' or a compound 'or'.
        [CompoundAnd, CompoundOr].each do |handler|
          post_output, post_input, success =
            CompoundAnd.process(input, output, **args)

          return post_output, post_input, success if success
        end

        [output, input, false]
      end
    end
  end
end

