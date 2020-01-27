# frozen_string_literal: true

require_relative '../mixins/unimplemented_element'
require_relative '../refinements/result_hashes'

module Elements
  attr_reader :args

  DEBUG_TRACING = false
  SANITY_CHECKS = true

  # Virtual class for implementing a stack processor.
  class Element
    class << self
      using Refinements::ResultHashes

      # Process I/O stacks. Returns hash containing input/output/success keys.
      def process(input:, **args)
        if SANITY_CHECKS
          unless input.is_a?(Array)
            raise ArgumentError, "Input stack must be an Array"
          end
          unless args.is_a?(Hash)
            raise ArgumentError, "Args must be a Hash"
          end
        end

        if self.respond_to?(:_process)
          if DEBUG_TRACING
            warn "-- #{self.name}: Processing " \
                 "input = #{input}, args = #{args}"
          end

          result = _process(input: input.dup, **args)

          warn "-- #{self.name}: Results = #{result}" if DEBUG_TRACING

          result
        else
          raise NotImplementedError, 'Subclass must implement `_process`'
        end
      end

      # Try several different handlers, and go with the first one that works.
      # This may be augmented at a later time to try multiple handlers
      # simultaneously via multithreading.
      def try(handlers:, input:, **args)

        handlers.each do |handler|
          warn "-- #{self.name}: Trying #{handler}" if DEBUG_TRACING

          result = handler.process(input: input, **args)

          return result if result.succeeded
        end

        fail("No handler in #{handlers} succeeded in parsing", input: input)
      end

      # Return a standard failure result, with an optional message.
      def fail(message = '', input:)
        {
          input: input,
          output: [],
          success: false,
          message: message
        }
      end

      # Return a standard success result.
      def succeed(input:, output: [])
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

    # def inspect
    #   "#{self.class.name}: args = #{@args}"
    # end
  end
end
