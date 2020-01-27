# frozen_string_literal: true

require_relative 'element'

require_relative 'adjective'
require_relative 'compound'
require_relative 'prep_adjectival_phrase'
require_relative 'plural_noun'
require_relative '../mixins/state_machine'

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

      # Process I/O stacks. Returns hash containing input/output/success keys.
      def _process(input:, **args)

        result = run_machine(
          start_state: :start,
          pass_states: [:succeeded],
          fail_states: [:failed],
          input: input, **args
        )

        output = nil
        case result[:state]
        when :succeeded
          input = result[:input]
          output = [NounClause.new(
            noun: result[:noun] || [],
            adjectives: result[:adjectives] || [],
            phrases: result[:phrases] || []
          )]
        when :failed
          return fail(input: input)
        end

        succeed(input: input, output: output)
      end

      def start(input:, state_info:, args: {})
        result = Compound.process(input: input, subclass: Adjective, **args)
        if result.succeeded
          result[:state] = :indef_p_noun
          result.save_adjectives(state_info)
          return result
        end

        result = Compound.process(input: input, subclass: PluralNoun, **args)
        if result.succeeded
          result[:state] = :indef_p_adj_phr
          result.save_nouns(state_info)
          return result
        end

        case input.first
        when 'the'
          input.shift
          state = :def_adj
        when 'a', 'an'
          input.shift
          state = :indef_s_adj
        else
          state = :failed
        end

        { input: input, state: state, args: args }
      end

      def def_adj(input:, state_info:, args: {})
        result = Compound.process(input: input, subclass: Adjective, **args)
        if result.succeeded
          result[:state] = :def_noun
          result.save_adjectives(state_info)
          return result
        end

        result = Compound.process(input: input, subclass: SingularNoun, **args)
        if result.succeeded
          result[:state] = :def_adj_phr
          result.save_nouns(state_info)
          return result
        end

        result = Compound.process(input: input, subclass: PluralNoun, **args)
        if result.succeeded
          result[:state] = :def_adj_phr
          result.save_nouns(state_info)
          return result
        end

        # Fail on anything else
        { input: input, state: :failed, args: args }
      end

      def def_noun(input:, state_info:, args: {})
        result = Compound.process(input: input, subclass: SingularNoun, **args)

        if result.succeeded
          result[:state] = :def_adj_phr
          result.save_nouns(state_info)
          return result
        end

        result = Compound.process(input: input, subclass: PluralNoun, **args)

        if result.succeeded
          result[:state] = :def_adj_phr
          result.save_nouns(state_info)
          return result
        end

        # Fail on anything else
        { input: input, state: :failed, args: args }
      end

      def def_adj_phr(input:, state_info:, args: {})
        result = Compound.process(input: input, subclass: PrepAdjectivalPhrase,
                                  **args)
        if result.succeeded
          result[:state] = :def_adj_phr
          result.save_phrases(state_info)
          return result
        end

        # Succeed on anything else
        { input: input, state: :succeeded, args: args }
      end

      def indef_p_noun(input:, state_info:, args: {})
        result = Compound.process(input: input, subclass: PluralNoun, **args)

        if result.succeeded
          result[:state] = :indef_p_adj_phr
          result.save_nouns(state_info)
          return result
        end

        # Fail on anything else
        { input: input, state: :failed, args: args }
      end

      def indef_p_adj_phr(input:, state_info:, args: {})
        result = Compound.process(input: input, subclass: PrepAdjectivalPhrase,
                                  **args)

        if result.succeeded
          result[:state] = :indef_p_adj_phr
          result.save_phrases(state_info)
          return result
        end

        # Succeed on anything else
        { input: input, state: :succeeded, args: args }
      end

      def indef_s_adj(input:, state_info:, args: {})
        result = Compound.process(input: input, subclass: Adjective, **args)

        if result.succeeded
          result[:state] = :indef_s_noun
          result.save_adjectives(state_info)
          return result
        end

        result = Compound.process(input: input, subclass: SingularNoun, **args)

        if result.succeeded
          result[:state] = :indef_s_adj_phr
          result.save_nouns(state_info)
          return result
        end

        # Fail on anything else
        { input: input, state: :failed, args: args }
      end

      def indef_s_noun(input:, state_info:, args: {})
        result = Compound.process(input: input, subclass: SingularNoun, **args)

        if result.succeeded
          result[:state] = :indef_s_adj_phr
          result.save_nouns(state_info)
          return result
        end

        # Fail on anything else
        { input: input, state: :failed, args: args }
      end

      def indef_s_adj_phr(input:, state_info:, args: {})
        result = Compound.process(input: input, subclass: PrepAdjectivalPhrase,
                                  **args)

        if result.succeeded
          result[:state] = :indef_s_adj_phr
          result.save_phrases(state_info)
          return result
        end

        # Succeed on anything else
        { input: input, state: :succeeded, args: args }
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
