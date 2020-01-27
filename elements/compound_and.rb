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
      def _process(input:, **args)

        unless args.key?(:subclass)
          raise ArgumentError, "Args has must contain `:subclass`"
        end

        # A compound item is generally:
        # 'item'[[, 'item']+,? ['and'|'or'] 'item'

        result = run_machine(
          start_state: :item_1,
          pass_states: [:success_not_compound, :success_compound],
          fail_states: [:failed],
          input: input, **args
        )

        output = nil
        case result[:state]
        when :success_not_compound
          input = result[:input]
          output = result[:output]
        when :success_compound
          input = result[:input]
          output = CompoundAnd.new(elements: result[:output])
        when :failed
          return fail(input: input)
        end

        succeed(input: input, output: [output])
      end

      private

      # States for this processor
      # Each returns the output stack, the input stack, and the new state

      def item_1(input:, state_info:, args: {})
        result = args[:subclass].process(input: input, **args)
        return result.merge({ state: :failed }) if result.failed

        result.merge({ state: :delimiter_1 })
      end

      def delimiter_1(input:, state_info:, args: {})
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

        { input: input, state: state, args: args }
      end

      def item_2(input:, state_info:, args: {})
        result = args[:subclass].process(input: input, **args)
        result.merge({ state: result.succeeded ? :delimiter_n : :failed })
      end

      def delimiter_n(input:, state_info:, args: {})
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

        { input: input, state: state, args: args }
      end

      def item_n(input:, state_info:, args: {})
        if input.first == 'and'
          input.shift
          return { input: input, state: :item_l, args: args }
        end

        result = args[:subclass].process(input: input, **args)
        result.merge({ state: result.succeeded ? :delimiter_n : :failed })
      end

      def item_l(input:, state_info:, args: {})
        if input.first == 'and'
          input.shift
          return { input: input, state: :failed, args: args }
        end

        result = args[:subclass].process(input: input, **args)
        return result.merge({ state: :failed }) if result.failed

        { input: input, state: :success_compound, args: args }
      end
    end
  end
end
