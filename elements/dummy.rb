# frozen_string_literal: true

require_relative 'element'

module Elements
  # Dummy element used for testing.
  class Dummy < Element
    class << self
      # Process I/O stacks. Returns hash containing input/output/success keys.
      # This dummy element just shifts the first element off of the input stack,
      # wraps it in a `Dummy` class, and pushes it onto the output stack.
      def _process(input:, **args)
        if input.nil? || input.empty?
          return fail("No input stack", input: input)
        end

        element = input.first
        if element.nil?
          return fail("First element of input stack is nil", input: input)
        end

        input.shift
        succeed(input: input, output: Dummy.new(element: element))
      end
    end
  end
end
