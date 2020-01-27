# frozen_string_literal: true

require_relative '../refinements/result_hashes'

module Elements
  attr_reader :args

  DEBUG_TRACING = false
  SANITY_CHECKS = true

  # Virtual class for implementing a stack processor.
  class Element
    class << self
      using Refinements::ResultHashes

      # Process the I/O stacks. Returns output, input, success.
      def process(input:, output: [], **args)
        if SANITY_CHECKS
          unless input.is_a?(Array)
            raise ArgumentError, "Input stack must be an Array"
          end
          unless args.is_a?(Hash)
            raise ArgumentError, "Args must be a Hash"
          end
        end

        unless output.is_a?(Array)
          warn "#{self.name}.process: output stack provided is not an Array; " \
               "clearing"
          args[:output] = []
        end

        if self.respond_to?(:_process)
          if DEBUG_TRACING
            warn "** BEGIN #{self.name}.process **\n" \
                 "input = #{input}, output = #{output}, args = #{args}"
          end

          result = _process(input: input.dup, output: output.dup, **args)

          if DEBUG_TRACING
            warn "**   END #{self.name}.process **\n" \
                 "input = #{result[:input]}, output = #{result[:output]}"
          end

          result
        else
          raise NotImplementedError, 'Subclass must implement `_process`'
        end
      end

      # Try several different handlers, and go with the first one that works.
      # This may be augmented at a later time to try multiple handlers
      # simultaneously via multithreading.
      def try(handlers:, input:, output: [], **args)
        handlers.each do |handler|
          result = handler.process(input: input, output: output, **args)

          return result if result.succeeded
        end

        fail("No handler in #{handler_list} succeeded in parsing",
             input: input, output: output, **args)
      end

      # Return a standard failure result, with an optional message.
      def fail(message = '', input:, output: [], **args)
        {
          input: input,
          output: output,
          success: false,
          message: message
        }
      end

      # Return a standard success result.
      def succeed(input:, output: [], **args)
        {
          input: input,
          output: output,
          success: true
        }
      end
    end

    # The default initializer just saves the passed-in args in an `args` member.
    def initialize(args = {})
      @args = args
    end

    def inspect
      "#{self.class.name}: args = #{@args}"
    end
  end
end
