module Refinements
  module ResultHashes
    refine Hash do
      def succeeded
        self.key?(:success) && self[:success]
      end

      def failed
        !succeeded
      end
    end
  end
end
