# frozen_string_literal: true

require_relative '../mixins/unimplemented_element'
require_relative '../refinements/result_hashes'
require_relative '../structures/tape'

module Elements
  attr_reader :args

  DEBUG_TRACING = false
  SANITY_CHECKS = true

  # Virtual class for implementing a stack processor.
  class Element
    class << self
      using Refinements::ResultHashes

      # Process I/O stacks. Returns hash containing tape, success keys.
      def process(tape:, **args)
        if SANITY_CHECKS
          unless tape.is_a?(Tape)
            raise ArgumentError, "`tape` must be a Tape object"
          end
          unless args.is_a?(Hash)
            raise ArgumentError, "Args must be a Hash"
          end
        end

        if self.respond_to?(:_process)
          if DEBUG_TRACING
            warn "-- #{self.name}: Processing " \
                 "tape = #{tape}, args = #{args}"
          end

          result = _process(tape: tape.dup, **args)

          warn "-- #{self.name}: Results = #{result}" if DEBUG_TRACING

          result
        else
          raise NotImplementedError, 'Subclass must implement `_process`'
        end
      end

      # Try several different handlers, and go with the first one that works.
      # This may be augmented at a later time to try multiple handlers
      # simultaneously via multithreading.
      def try(handlers:, tape:, **args)

        handlers.each do |handler|
          warn "-- #{self.name}: Trying #{handler}" if DEBUG_TRACING

          result = handler.process(tape: tape, **args)

          return result if result.succeeded
        end

        fail("No handler in #{handlers} succeeded in parsing", tape: tape)
      end

      # Try several handlers in order. The results of the handlers are
      # collected into an array in the output.
      def in_order(handlers:, tape:, **args)
        original_tape = tape
        output = []

        handlers.each do |handler|
          result = handler.process(tape: tape, **args)

          if result.failed
            return fail(tape: original_tape)
          end

          tape = result[:tape]
          output.push(result[:output])
        end

        success(tape: tape, output: output)
      end

      # Return a standard failure result, with an optional message.
      def fail(message = '', tape:)
        {
          tape: tape,
          output: nil,
          success: false,
          message: message
        }
      end

      # Return a standard success result.
      def succeed(tape:, output: nil)
        {
          tape: tape,
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
