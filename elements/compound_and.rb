# frozen_string_literal: true

require_relative 'element'
require_relative '../mixins/state_machine'
require_relative '../structures/tape'

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
  # TODO: Flag for when the final "and" can be omitted. For example, it's okay
  #       to say "the clean, shiny ball" instead of "the clean and shiny ball",
  #       but it's not okay to say "the ball is clean, shiny".
  # TODO: Likewise, flag for when it's okay to omit commas entirely, as in
  #       "the shiny red ball". (In this case, the "and" should *never* be
  #       present.)
  class CompoundAnd < Element
    extend Mixins::StateMachine
    using Refinements::ResultHashes

    class << self
      # Process I/O stacks. Returns hash containing tape, success keys.
      # Requires 'subclass' to be passed in, which specifies what item you are
      # looking for as a possible compound item.
      def _process(tape:, **args)

        unless args.key?(:subclass)
          raise ArgumentError, "Args has must contain `:subclass`"
        end

        # A compound item is generally:
        # 'item'[[, 'item']+,? ['and'|'or'] 'item'

        result = run_machine(
          start_state: :item_1,
          pass_states: [:success_not_compound, :success_compound],
          fail_states: [:failed],
          tape: tape, **args
        )

        output = nil
        case result[:state]
        when :success_not_compound
          tape = result[:tape]
          output = result[:output]
        when :success_compound
          tape = result[:tape]
          output = CompoundAnd.new(elements: result[:output])
        when :failed
          return fail(tape: tape)
        end

        succeed(tape: tape, output: [output])
      end

      private

      # States for this processor
      # Each returns the tape, the output stack, and the new state

      def item_1(tape:, state_info:, args: {})
        result = args[:subclass].process(tape: tape, **args)
        return result.merge({ state: :failed }) if result.failed

        result.merge({ state: :delimiter_1 })
      end

      def delimiter_1(tape:, state_info:, args: {})
        if args[:allow_space_delimiters]
          result = args[:subclass].process(tape: tape, **args)
          return result.merge({ state: :item_spaced_n }) if result.succeeded
        end

        state = nil

        case tape.element
        when ','
          tape.next
          state = :item_2
        when 'and'
          tape.next
          state = :item_l
        else
          state = :success_not_compound
        end

        { tape: tape, state: state, args: args }
      end

      def item_2(tape:, state_info:, args: {})
        result = args[:subclass].process(tape: tape, **args)
        result.merge({ state: result.succeeded ? :delimiter_n : :failed })
      end

      def item_spaced_n(tape:, state_info:, args: {})
        result = args[:subclass].process(tape: tape, **args)
        result.merge({ state: result.succeeded ? :item_spaced_n : :success_compound })
      end

      def delimiter_n(tape:, state_info:, args: {})
        state = nil
        case tape.element
        when ','
          tape.next
          state = :item_n
        when 'and'
          tape.next
          state = :item_l
        else
          if args[:allow_commas_only]
            state = :success_compound
          else
            state = :failed
          end
        end

        { tape: tape, state: state, args: args }
      end

      def item_n(tape:, state_info:, args: {})
        if tape.element == 'and'
          tape.next
          return { tape: tape, state: :item_l, args: args }
        end

        result = args[:subclass].process(tape: tape, **args)
        result.merge({ state: result.succeeded ? :delimiter_n : :failed })
      end

      def item_l(tape:, state_info:, args: {})
        if tape.element == 'and'
          tape.next
          return { tape: tape, state: :failed, args: args }
        end

        result = args[:subclass].process(tape: tape, **args)
        return result.merge({ state: :failed }) if result.failed

        { tape: tape, state: :success_compound, args: args }
      end
    end
  end
end
