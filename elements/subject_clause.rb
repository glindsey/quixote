# frozen_string_literal: true

require_relative 'element'

require_relative 'noun_clause'
require_relative 'pronoun_clause'
require_relative 'gerund_clause'
require_relative 'prep_noun_phrase'

# Subject Clauses
# ===============
# Possible types of clauses:
#   - NounClause ('_the blue box_ is over there')
#   - PronounClause (subclassed into personal pronouns, possessive clauses, etc.)
#   - GerundClause ('_going to the beach_ is my favorite activity')
#   - PrepNounPhrase ('_among the reeds_ is where you will find it')
#
# To make matters even more complex, any of these can be a Compound:
#   - NounClause ('_the black dogs and the white cats_')
#   - PronounClause ('_you and your wife_')
#     - TODO: Noun and Pronoun clauses can be mixed ('_you and the boys_') but
#             let's not go there right now or I will go totally insane
#   - GerundClause ('_eating ice cream and kissing babies_')
#   - PrepNounPhrase ('_over the river and through the woods_ is where we went')

module Elements
  # Processor for subject clauses.
  class SubjectClause < Element
    class << self
      # Process I/O stacks. Returns hash containing tape, success keys.
      def _process(tape:, **args)
        # Try each of them in order.
        try_compound(
          handlers: [
            NounClause,
            PronounClause,
            GerundClause,
            PrepNounPhrase
          ],
          tape: tape, **args
        )
      end
    end
  end
end
