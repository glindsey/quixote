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

module Elements
  # Processor for compound items.
  class CompoundAnd < Element
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

      # Process the I/O stacks. Returns output, input, success.
      # Requires 'subclass' to be passed in, which specifies what item you are
      # looking for as a possible compound item.
      def process(input, output, **args)
        input_backup = input.dup
        output_backup = output.dup

        state = :item_1

        unless args.key?(:subclass)
          raise ArgumentError, '`subclass:` must be defined'
        end

        # A compound item is generally:
        # 'item'[[, 'item']+,? ['and'|'or'] 'item'

        state_input = input
        state_output = []

        until [
          :success_not_compound,
          :success_compound,
          :failed
        ].include?(state)
          state_output, state_input, state =
            send(state, state_input, state_output, **args)
        end

        case state
        when :success_not_compound
          output.push(state_output)
        when :success_compound
          output.push(CompoundAnd.new(elements: state_output))
        when :failed
          return [output_backup, input_backup, false]
        end

        [output, input, true]
      end

      private

      # States for this processor
      # Each returns the output stack, the input stack, and the new state

      def item_1(input, output, **args)
        output, input, success = args[:subclass].process(input, output, **args)
        return [output, input, :failed] unless success

        [output, input, :delimiter_1]
      end

      def delimiter_1(input, output, **args)
        case input.first
        when ','
          input.shift
          [output, input, :item_2]
        when 'and'
          input.shift
          [output, input, :item_l]
        else
          [output, input, :success_not_compound]
        end
      end

      def item_2(input, output, **args)
        output, input, success = args[:subclass].process(input, output, **args)
        return [output, input, :failed] unless success

        [output, input, :delimiter_n]
      end

      def delimiter_n(input, output, **args)
        case input.first
        when ','
          input.shift
          [output, input, :item_n]
        when 'and'
          input.shift
          [output, input, :item_l]
        else
          [output, input, :failed]
        end
      end

      def item_n(input, output, **args)
        if input.first == 'and'
          input.shift
          return [output, input, :item_l]
        end

        output, input, success = args[:subclass].process(input, output, **args)
        [output, input, success ? :delimiter_n : :failed]
      end

      def item_l(input, output, **args)
        if input.first == 'and'
          input.shift
          return [output, input, :failed]
        end

        output, input, success = args[:subclass].process(input, output, **args)
        return [output, input, :failed] unless success

        [output, input, :success_compound]
      end
    end
  end
end
