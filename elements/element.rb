# frozen_string_literal: true

module Elements
  attr_reader :args

  # Virtual class for implementing a stack processor.
  class Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(_input, _output, **_args)
        raise NotImplementedError, 'Subclass must implement `process`'
      end
    end

    # The default initializer just saves the passed-in args in an `args` member.
    def initialize(args = {})
      @args = args
    end
  end
end
