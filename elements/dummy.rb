# frozen_string_literal: true

require_relative 'element'
require_relative '../structures/tape'

module Elements
  # Dummy element used for testing.
  class Dummy < Element
    class << self
      # Process I/O stacks. Returns hash containing tape, success keys.
      # This dummy element just takes the current tape element,
      # wraps it in a `Dummy` class, pushes it onto the output stack, and then
      # advances the tape.
      def _process(tape:, **args)
        if tape.nil?
          return fail("No tape provided", tape: tape)
        end

        element = tape.element
        if element.nil?
          return fail("Tape element is nil", tape: tape)
        end

        tape.next
        succeed(tape: tape, output: Dummy.new(element: element))
      rescue EndOfTapeError
        fail('Reached the end of the tape', tape: tape)
      end
    end
  end
end
