# frozen_string_literal: true

require_relative 'element'

module Elements
  # Dummy element used for testing.
  class Dummy < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      # This dummy element just shifts the first element off of the input stack,
      # wraps it in a `Dummy` class, and pushes it onto the output stack.
      def process(input, output, **_args)
        return [output, input, false] if input.nil? || input.empty?

        element = input.first
        return [output, input, false] if element.nil?

        input.shift
        new_element = Dummy.new(element: element)
        output.push(new_element)

        [output, input, true]
      end
    end
  end
end
