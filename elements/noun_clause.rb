# frozen_string_literal: true

require_relative 'element'

require_relative 'adjective'
require_relative 'compound'
require_relative 'prep_adjectival_phrase'
require_relative 'plural_noun'
require_relative '../mixins/state_machine'
require_relative '../structures/tape'

# Noun Clauses
# =============
# A noun clause follows a pattern like this:
#
# Definite singular/plural/proper:
#   the [CompoundAdjective] [SingularNoun|PluralNoun|DefProperNoun] [PrepAdjectivalPhrase]*
#
# Indefinite singular:
#   (a|an) [CompoundAdjective] [SingularNoun] [PrepAdjectivalPhrase]*
#
# Indefinite plural/proper:
#   [CompoundAdjective] [PluralNoun|IndefProperNoun] [PrepAdjectivalPhrase]*
#

STATE_TRACING = false

module Elements
  # Processor for noun clauses.
  class NounClause < Element
    extend Mixins::StateMachine
    using Refinements::ResultHashes

    class << self
      VALID_STATES = [
        :start,
        :def_adj,
        :def_adj_phr,
        :def_noun,
        :indef_p_adj_phr,
        :indef_p_noun,
        :indef_s_adj,
        :indef_s_adj_phr,
        :indef_s_noun,
        :failed,
        :succeeded
      ]

      # Process I/O stacks. Returns hash containing tape, success keys.
      def _process(tape:, **args)

        result = run_machine(
          start_state: :start,
          pass_states: [:succeeded],
          fail_states: [:failed],
          tape: tape, **args
        )

        output = nil
        case result[:state]
        when :succeeded
          tape = result[:tape]
          output = [NounClause.new(
            noun: result[:noun] || [],
            adjectives: result[:adjectives] || [],
            phrases: result[:phrases] || []
          )]
        when :failed
          return fail(tape: tape)
        end

        succeed(tape: tape, output: output)
      end

      def start(tape:, state_info:, args: {})
        result = Compound.process(tape: tape, subclass: Adjective, **args)
        if result.succeeded
          result[:state] = :indef_p_noun
          result.save_adjectives(state_info)
          return result
        end

        result = Compound.process(tape: tape, subclass: PluralNoun, **args)
        if result.succeeded
          result[:state] = :indef_p_adj_phr
          result.save_nouns(state_info)
          return result
        end

        case tape.element
        when 'the'
          tape.next
          state = :def_adj
        when 'a', 'an'
          tape.next
          state = :indef_s_adj
        else
          state = :failed
        end

        { tape: tape, state: state, args: args }
      end

      def def_adj(tape:, state_info:, args: {})
        result = Compound.process(tape: tape, subclass: Adjective, **args)
        if result.succeeded
          result[:state] = :def_noun
          result.save_adjectives(state_info)
          return result
        end

        result = Compound.process(tape: tape, subclass: SingularNoun, **args)
        if result.succeeded
          result[:state] = :def_adj_phr
          result.save_nouns(state_info)
          return result
        end

        result = Compound.process(tape: tape, subclass: PluralNoun, **args)
        if result.succeeded
          result[:state] = :def_adj_phr
          result.save_nouns(state_info)
          return result
        end

        # Fail on anything else
        { tape: tape, state: :failed, args: args }
      end

      def def_noun(tape:, state_info:, args: {})
        result = Compound.process(tape: tape, subclass: SingularNoun, **args)

        if result.succeeded
          result[:state] = :def_adj_phr
          result.save_nouns(state_info)
          return result
        end

        result = Compound.process(tape: tape, subclass: PluralNoun, **args)

        if result.succeeded
          result[:state] = :def_adj_phr
          result.save_nouns(state_info)
          return result
        end

        # Fail on anything else
        { tape: tape, state: :failed, args: args }
      end

      def def_adj_phr(tape:, state_info:, args: {})
        result = Compound.process(tape: tape, subclass: PrepAdjectivalPhrase,
                                  **args)
        if result.succeeded
          result[:state] = :def_adj_phr
          result.save_phrases(state_info)
          return result
        end

        # Succeed on anything else
        { tape: tape, state: :succeeded, args: args }
      end

      def indef_p_noun(tape:, state_info:, args: {})
        result = Compound.process(tape: tape, subclass: PluralNoun, **args)

        if result.succeeded
          result[:state] = :indef_p_adj_phr
          result.save_nouns(state_info)
          return result
        end

        # Fail on anything else
        { tape: tape, state: :failed, args: args }
      end

      def indef_p_adj_phr(tape:, state_info:, args: {})
        result = Compound.process(tape: tape, subclass: PrepAdjectivalPhrase,
                                  **args)

        if result.succeeded
          result[:state] = :indef_p_adj_phr
          result.save_phrases(state_info)
          return result
        end

        # Succeed on anything else
        { tape: tape, state: :succeeded, args: args }
      end

      def indef_s_adj(tape:, state_info:, args: {})
        result = Compound.process(tape: tape, subclass: Adjective, **args)

        if result.succeeded
          result[:state] = :indef_s_noun
          result.save_adjectives(state_info)
          return result
        end

        result = Compound.process(tape: tape, subclass: SingularNoun, **args)

        if result.succeeded
          result[:state] = :indef_s_adj_phr
          result.save_nouns(state_info)
          return result
        end

        # Fail on anything else
        { tape: tape, state: :failed, args: args }
      end

      def indef_s_noun(tape:, state_info:, args: {})
        result = Compound.process(tape: tape, subclass: SingularNoun, **args)

        if result.succeeded
          result[:state] = :indef_s_adj_phr
          result.save_nouns(state_info)
          return result
        end

        # Fail on anything else
        { tape: tape, state: :failed, args: args }
      end

      def indef_s_adj_phr(tape:, state_info:, args: {})
        result = Compound.process(tape: tape, subclass: PrepAdjectivalPhrase,
                                  **args)

        if result.succeeded
          result[:state] = :indef_s_adj_phr
          result.save_phrases(state_info)
          return result
        end

        # Succeed on anything else
        { tape: tape, state: :succeeded, args: args }
      end
    end

    attr_reader :noun, :adjectives, :adjective_phrases

    def initialize(noun: [], adjectives: [], phrases: [])
      @noun = noun
      @adjectives = adjectives
      @adjective_phrases = phrases
    end
  end
end
