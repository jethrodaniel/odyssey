module Odyssey
  # Refinements to allow obtaining metrics and scores directly from a String.
  module Refinements
    refine String do
      def readability
        Odyssey.analyze_all self
      end
    end
  end
end
