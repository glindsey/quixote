# frozen_string_literal: true

require_relative 'element'

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

STATE_TRACING = false

module Elements
  # Processor for compound items.
  class CompoundAnd < Element
    using Refinements::ResultHashes

    class << self
      VALID_STATES = [
        :item_1,
        :delimiter_1,
        :item_2,
        :delimiter_n,
        :item_n,
        :item_l,
        :succeeded,
        :failed
      ]

      END_STATES = [
        :success_not_compound,
        :success_compound,
        :failed
      ]

      # Process the I/O stacks. Returns output, input, success.
      # Requires 'subclass' to be passed in, which specifies what item you are
      # looking for as a possible compound item.
      def _process(input:, output: [], **args)

        unless args.key?(:subclass)
          raise ArgumentError, "Args has must contain `:subclass`"
        end

        # A compound item is generally:
        # 'item'[[, 'item']+,? ['and'|'or'] 'item'

        state_input = input
        state_output = []
        state = :item_1

        until END_STATES.include?(state)
          if STATE_TRACING
            warn "**** #{name} state #{state} BEGIN: " \
                 "input = #{state_input}, output = #{state_output}"
          end

          result = send(state, input: state_input, output: state_output, **args)

          if STATE_TRACING
            warn "**** #{name} state #{state} END: " \
                 "input = #{result[:input]}, output = #{result[:output]}, " \
                 "new state = #{result[:state]}"
          end

          state_input = result[:input]
          state_output = result[:output]
          state = result[:state]

        end

        case state
        when :success_not_compound
          output.push(state_output)
        when :success_compound
          output.push(CompoundAnd.new(elements: state_output))
        when :failed
          return fail(input: input, output: output, **args)
        end

        succeed(input: input, output: output, **args)
      end

      private

      # States for this processor
      # Each returns the output stack, the input stack, and the new state

      def item_1(input:, output:, **args)
        result = args[:subclass].process(input: input, output: output, **args)
        return result.merge({ state: :failed }) if result.failed

        result.merge({ state: :delimiter_1 })
      end

      def delimiter_1(input:, output:, **args)
        case input.first
        when ','
          input.shift
          { input: input, output: output, state: :item_2 }
        when 'and'
          input.shift
          { input: input, output: output, state: :item_l }
        else
          { input: input, output: output, state: :success_not_compound }
        end
      end

      def item_2(input:, output:, **args)
        result = args[:subclass].process(input: input, output: output, **args)
        return result.merge({state: :failed}) if result.failed

        result.merge({ state: :delimiter_n })
      end

      def delimiter_n(input:, output:, **args)
        case input.first
        when ','
          input.shift
          { input: input, output: output, state: :item_n }
        when 'and'
          input.shift
          { input: input, output: output, state: :item_l }
        else
          { input: input, output: output, state: :failed }
        end
      end

      def item_n(input:, output:, **args)
        if input.first == 'and'
          input.shift
          return { input: input, output: output, state: :item_l }
        end

        result = args[:subclass].process(input: input, output: output, **args)
        result.merge({ state: result.succeeded ? :delimiter_n : :failed })
      end

      def item_l(input:, output:, **args)
        if input.first == 'and'
          input.shift
          return { input: input, output: output, state: :failed }
        end

        result = args[:subclass].process(input: input, output: output, **args)
        return result.merge({state: :failed}) if result.failed

        { input: input, output: output, state: :success_compound }
      end
    end
  end
end
