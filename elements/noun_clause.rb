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
      def _process(input:, output: [], **args)

        result = run_machine(
          start_state: :start,
          end_states: [:failed, :succeeded],
          input: input,
          output: output,
          args: args
        )

        case result[:state]
        when :succeeded
          # TODO: PUT STUFF WE FIGURED OUT HERE
          input = result[:input]
          output.push(
            NounClause.new(
              noun: result[:noun],
              adjectives: result[:adjectives],
              phrases: result[:phrases]
            )
          )
        when :failed
          return fail(input: input, output: output, **args)
        end

        succeed(input: input, output: output, **args)
      end

      def start(input:, output:, args: {})
        result = Compound.process(input: input, output: output,
                                  subclass: Adjective, **args)
        return result.merge(state: :indef_p_noun) if result.succeeded

        result = Compound.process(input: input, output: output,
                                  subclass: PluralNoun, **args)
        if result.succeeded
          result[:state] = :indef_p_adj_phr
          result[:noun] = result[:output]
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

        { input: input, output: output, state: state, args: args }
      end

      def def_adj(input:, output:, args: {})
        result = Compound.process(input: input, output: output,
                                  subclass: Adjective, **args)
        return result.merge(state: :def_noun) if result.succeeded

        result = Compound.process(input: input, output: output,
                                  subclass: SingularNoun, **args)
        if result.succeeded
          result[:state] = :def_adj_phr
          result[:noun] = result[:output]
          return result
        end

        result = Compound.process(input: input, output: output,
                                  subclass: PluralNoun, **args)

        if result.succeeded
          result[:state] = :def_adj_phr
          result[:noun] = result[:output]
          return result
        end

        # Fail on anything else
        { input: input, output: output, state: :failed, args: args }
      end

      def def_noun(input:, output:, args: {})
        result = Compound.process(input: input, output: output,
                                  subclass: SingularNoun, **args)

        if result.succeeded
          result[:state] = :def_adj_phr
          result[:noun] = result[:output]
          return result
        end

        result = Compound.process(input: input, output: output,
                                  subclass: PluralNoun, **args)

        if result.succeeded
          result[:state] = :def_adj_phr
          result[:noun] = result[:output]
          return result
        end

        # Fail on anything else
        { input: input, output: output, state: :failed, args: args }
      end

      def def_adj_phr(input:, output:, args: {})
        result = Compound.process(input: input, output: output,
                                  subclass: PrepAdjectivalPhrase, **args)
        return result.merge(state: :def_adj_phr) if result.succeeded

        # Succeed on anything else
        { input: input, output: output, state: :succeeded, args: args }
      end

      def indef_p_noun(input:, output:, args: {})
        result = Compound.process(input: input, output: output,
                                  subclass: PluralNoun, **args)

        if result.succeeded
          result[:state] = :indef_p_adj_phr
          result[:noun] = result[:output]
          return result
        end

        # Fail on anything else
        { input: input, output: output, state: :failed, args: args }
      end

      def indef_p_adj_phr(input:, output:, args: {})
        result = Compound.process(input: input, output: output,
                                  subclass: PrepAdjectivalPhrase, **args)
        return result.merge(state: :indef_p_adj_phr) if result.succeeded

        # Succeed on anything else
        { input: input, output: output, state: :succeeded, args: args }
      end

      def indef_s_adj(input:, output:, args: {})
        result = Compound.process(input: input, output: output,
                                  subclass: Adjective, **args)
        return result.merge(state: :indef_s_noun) if result.succeeded

        result = Compound.process(input: input, output: output,
                                  subclass: SingularNoun, **args)

        if result.succeeded
          result[:state] = :indef_s_adj_phr
          result[:noun] = result[:output]
          return result
        end

        # Fail on anything else
        { input: input, output: output, state: :failed, args: args }
      end

      def indef_s_noun(input:, output:, args: {})
        result = Compound.process(input: input, output: output,
                                  subclass: SingularNoun, **args)

        if result.succeeded
          result[:state] = :indef_s_adj_phr
          result[:noun] = result[:output]
          return result
        end

        # Fail on anything else
        { input: input, output: output, state: :failed, args: args }
      end

      def indef_s_adj_phr(input:, output:, args: {})
        result = Compound.process(input: input, output: output,
                                  subclass: PrepAdjectivalPhrase, **args)
        return result.merge(state: :indef_s_adj_phr) if result.succeeded

        # Succeed on anything else
        { input: input, output: output, state: :succeeded, args: args }
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
