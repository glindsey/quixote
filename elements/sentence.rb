# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for whole sentences.
  class Sentence < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(input, output, **args)
        # A sentence can be a Statement or a Question. Let's try each.
        [Statement, Question].each do |handler|
          post_output, post_input, success =
            handler.process(input, output, **args)

          return post_output, post_input, success if success
        end

        [output, input, false]
      end
    end
  end
end

