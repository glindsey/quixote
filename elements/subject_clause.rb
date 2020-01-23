# frozen_string_literal: true

require_relative 'element'

# Subject Clauses
# ===============
# Possible types of clauses:
#   - NounClause ('_the blue box_ is over there')
#   - PronounClause (subclassed into personal pronouns, possessive clauses, etc.)
#   - GerundClause ('_going to the beach_ is my favorite activity')
#   - PrepNounPhrase ('_among the reeds_ is where you will find it')

module Elements
  # Processor for subject clauses.
  class SubjectClause < Element
    class << self
      # Process the I/O stacks. Returns output, input, success.
      def process(input, output, **args)
        # Try each of them in order.
        [NounClause, PronounClause, GerundClause, PrepNounPhrase].each do |handler|
          post_output, post_input, success =
            handler.process(input, output, **args)

          return post_output, post_input, success if success
        end

        [output, input, false]
      end
    end
  end
end
