# frozen_string_literal: true

require_relative 'element'

module Elements
  # Processor for singular nouns.
  class SingularNoun < Element
    class << self
      # TODO: actually implement this instead of faking it
      def _process(tape:, **args)
        elem = tape.element

        if ['boy', 'ball'].include?(elem)
          succeed(tape: tape, output: SingularNoun.new(elem))
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
