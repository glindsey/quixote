# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for plural nouns.
  class PluralNoun < Element
    class << self
      # TODO: actually implement this instead of faking it
      def _process(tape:, **args)
        elem = tape.element

        stupid_dictionary = {'boys' => 'boy', 'balls' => 'ball'}
        if stupid_dictionary.key?(elem)
          succeed(tape: tape, output: PluralNoun.new(stupid_dictionary[elem]))
        else
          fail(tape: tape)
        end
      end
    end

    attr_reader :what

    def initialize(str = '')
      @what = str
    end
  end
end
