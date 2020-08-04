module Odyssey
  # A formula describes how a specifc readability metric is computed.
  class Formula
    # Compute a score for this formula.
    #
    # @param text [Hash]
    # @option text [String] 'raw' the input string
    # @option text [Array<String>] 'words'
    # @option text [Array<String>] 'sentences'
    # @option text [Array<String>] 'syllables'
    #
    # @param stats [Hash]
    # @option stats [String] 'string_length'
    # @option stats [String] 'letter_count'
    # @option stats [String] 'syllable_count'
    # @option stats [String] 'syllable_count'
    # @option stats [String] 'word_count'
    # @option stats [String] 'sentence_count'
    # @option stats [String] 'average_words_per_sentence'
    # @option stats [String] 'average_syllables_per_word'
    #
    # @return [Number]
    def score(text, stats)
      0
    end

    # {score}, but per sentence.
    # @params (see #score)
    # see score
    def score_by_sentence(text, stats_split)
      0
    end

    # Name of this formula.
    #
    # @return [String]
    def name
      'Generic'
    end
  end
end
