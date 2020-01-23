# frozen_string_literal: true

require_relative 'element'

# Noun Clauses
# =============
# A noun clause follows a pattern like this:
#
# Definite singular/plural:
#   the [Adjective|CompoundAdjective] [SingularNoun|PluralNoun] [PrepAdjectivalPhrase]*
#
# Indefinite singular:
#   (a|an) [Adjective|CompoundAdjective] [SingularNoun] [PrepAdjectivalPhrase]*
#
# Indefinite plural:
#   [Adjective|CompoundAdjective] [PluralNoun] [PrepAdjectivalPhrase]*
#
# Proper noun:
#   [ProperNoun]
#   It may employ adjectives/prep. phrases, but only in flowery writing
#     (i.e. "the beautiful Eiffel Tower in the center of the city")
#

module Elements
  # Processor for noun clauses.
  class NounClause < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(input, output, **args)
        raise NotImplementedError, 'Not yet implemented'
      end
    end
  end
end
