# frozen_string_literal: true

require_relative 'element'
require_relative '../mixins/state_machine'

# A and B
# A, B and C
# A, B, and C

#             (END-N)                     .------------.       (END-Y)
#                ^                        |            |"N"       ^
#         "A"    |     ","         "B"    v     ","    |          | "L"
# (ITEM1) --> (DELIM1) --> (ITEM2) --> (DELIMN) --> (ITEMN)    (ITEML)
#                |                        |            |          ^
#                | "and"                  | "and"      | "and"    |
#                '------------------------'------------+----------'

module Elements
  # Processor for compound items.
  class CompoundAnd < Element
    extend Mixins::StateMachine
    using Refinements::ResultHashes

    class << self
      # Process I/O stacks. Returns hash containing input/output/success keys.
      # Requires 'subclass' to be passed in, which specifies what item you are
      # looking for as a possible compound item.
      def _process(input:, output: [], **args)

        unless args.key?(:subclass)
          raise ArgumentError, "Args has must contain `:subclass`"
        end

        # A compound item is generally:
        # 'item'[[, 'item']+,? ['and'|'or'] 'item'

        result = run_machine(
          start_state: :item_1,
          end_states: [:success_not_compound, :success_compound, :failed],
          input: input,
          output: output,
          args: args
        )

        case result[:state]
        when :success_not_compound
          input = result[:input]
          output.push(result[:output])
        when :success_compound
          input = result[:input]
          output.push(CompoundAnd.new(elements: result[:output]))
        when :failed
          return fail(input: input, output: output, **args)
        end

        args.merge(result[:args]) if result.key?(:args)
        succeed(input: input, output: output, **args)
      end

      private

      # States for this processor
      # Each returns the output stack, the input stack, and the new state

      def item_1(input:, output:, args: {})
        result = args[:subclass].process(input: input, output: output, **args)
        return result.merge({ state: :failed }) if result.failed

        result.merge({ state: :delimiter_1 })
      end

      def delimiter_1(input:, output:, args: {})
        state = nil

        case input.first
        when ','
          input.shift
          state = :item_2
        when 'and'
          input.shift
          state = :item_l
        else
          state = :success_not_compound
        end

        { input: input, output: output, state: state, args: args }
      end

      def item_2(input:, output:, args: {})
        result = args[:subclass].process(input: input, output: output, **args)
        result.merge({ state: result.succeeded ? :delimiter_n : :failed })
      end

      def delimiter_n(input:, output:, args: {})
        state = nil
        case input.first
        when ','
          input.shift
          state = :item_n
        when 'and'
          input.shift
          state = :item_l
        else
          state = :failed
        end

        { input: input, output: output, state: state, args: args }
      end

      def item_n(input:, output:, args: {})
        if input.first == 'and'
          input.shift
          return { input: input, output: output, state: :item_l, args: args }
        end

        result = args[:subclass].process(input: input, output: output, **args)
        result.merge({ state: result.succeeded ? :delimiter_n : :failed })
      end

      def item_l(input:, output:, args: {})
        if input.first == 'and'
          input.shift
          return { input: input, output: output, state: :failed, args: args }
        end

        result = args[:subclass].process(input: input, output: output, **args)
        return result.merge({state: :failed}) if result.failed

        { input: input, output: output, state: :success_compound, args: args }
      end
    end
  end
end
