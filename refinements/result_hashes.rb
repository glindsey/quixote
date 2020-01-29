module Refinements
  module ResultHashes
    refine Hash do
      def succeeded
        self.key?(:success) && self[:success]
      end

      def failed
        !succeeded
      end

      def save_nouns(old_hash = {})
        self[:noun] ||= []
        self[:noun] = old_hash[:noun] if old_hash.key?(:noun)
        self[:noun].push(self[:output])
        self[:output] = []
      end

      def save_adjectives(old_hash = {})
        self[:adjectives] ||= []
        self[:adjectives] = old_hash[:adjectives] if old_hash.key?(:adjectives)
        self[:adjectives].push(self[:output])
        self[:output] = []
      end

      def save_phrases(old_hash = {})
        self[:phrases] ||= []
        self[:phrases] = old_hash[:phrases] if old_hash.key?(:phrases)
        self[:phrases].push(self[:output])
        self[:output] = []
      end
    end
  end
end
